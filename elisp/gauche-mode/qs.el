;;; qs.el - A port of the Quicksilver string ranking algorithm
;;;
;;; Copyright (c) 2009 OOHASHI Daichi <leque@katch.ne.jp>,
;;; All rights reserved.
;;;
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:
;;;
;;; 1. Redistributions of source code must retain the above copyright
;;;    notice, this list of conditions and the following disclaimer.
;;;
;;; 2. Redistributions in binary form must reproduce the above copyright
;;;    notice, this list of conditions and the following disclaimer in the
;;;    documentation and/or other materials provided with the distribution.
;;;
;;; 3. Neither the name of the authors nor the names of its contributors
;;;    may be used to endorse or promote products derived from this
;;;    software without specific prior written permission.
;;;
;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;;; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;;; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
;;; A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
;;; OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
;;; SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
;;; TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
;;; PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
;;; LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;;;

;;; The Quicksilver code is available here:
;;; - http://code.google.com/p/blacktree-alchemy/
;;; - http://code.google.com/p/blacktree-alchemy/source/browse/trunk/Crucible/Code/NSString_BLTRExtensions.m#61

(require 'cl)

(defun qs-default-penalty-function (_str _n)
  nil)

(defun qs-CamelCase-penalty-function (str n)
  (let ((upper-case-p
         #'(lambda (ch)
             (and (eql ch (upcase ch))
                  (not (eql ch (downcase ch)))))))
    (and (> n 0)
         (funcall upper-case-p (aref str n))
         (let ((nwords (count-if upper-case-p (substring str 0 n))))
           (+ nwords (* (- n nwords) 0.15))))))

(defun qs-c_like-penalty-function (str n)
  (and (> n 0)
       (eql (aref str (- n 1)) ?_)
       (let ((nwords (count ?_ (substring str 0 n))))
         (+ nwords (* (- n nwords) 0.15)))))

(defvar qs-lisp-separator-chars "-+/>&:")

(defun qs-lisp-penalty-function (str n)
  (and (> n 0)
       (find (aref str (- n 1)) qs-lisp-separator-chars)
       (let ((nwords (count-if
                      #'(lambda (ch)
                          (find ch qs-lisp-separator-chars))
                      (substring str 0 n))))
         (+ nwords (* (- n nwords) 0.15)))))

(defun qs-score (str pat &optional penalty-function)
  "Calculate Quicksilver ranking score for `pat' against `str'."
  (let ((lstr (downcase str))
        (lpat (downcase pat))
        (slen (length str))
        (plen (length pat))
        (penalty-function (or penalty-function
                              #'qs-default-penalty-function)))
    (cond
     ((< slen plen) 0)
     ((zerop plen) 0.9)
     (t
      (do ((n plen (- n 1)))
          ((zerop n) 0)
        (let ((fn (search (substring lpat 0 n) lstr)))
          (when fn
            (let* ((tstr (substring str (+ fn n)))
                   (tlen (length tstr))
                   (tscore (qs-score tstr (substring pat n)
                                               penalty-function)))
              (when (> tscore 0)
                (return (/ (+ n
                              (* tscore tlen)
                              (- fn (or (let ((p (funcall penalty-function
                                                          str fn)))
                                          (and p (max 0 (min p fn))))
                                        fn)))
                           slen)))))))))))

(defun qs-filter-candidates (pat words &optional penalty-function maxnum)
  "Returns sorted `words' with respect to Quicksilver ranking score for `pat'.
Words do not match against `pat' are removed."
  (let ((cs (mapcar
             #'cdr
             (sort* (mapcan
                     #'(lambda (w)
                         (let ((s (qs-score w pat penalty-function)))
                           (and (> s 0)
                                (list (cons s w)))))
                     words)
                    #'>
                    :key #'car))))
    (if (not maxnum)
        cs
      (let ((rs '()))
        (do ((i 0 (+ i 1))
             (xs cs (cdr xs)))
            ((or (null xs) (= i maxnum)) (nreverse rs))
          (push (car xs) rs))))))

(provide 'qs)
