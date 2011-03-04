;;; -*- coding: euc-jp -*-
;;;
;;; Copyright (c) 2007-2009 OOHASHI Daichi <leque@katch.ne.jp>,
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

(eval-when-compile
  (defvar qs-complete-penalty-function)
  (defvar qs-complete-candidates-functions)
  (require 'cl))

(require 'scheme)
(require 'cmuscheme)
(require 'info-look)

(defgroup gauche-mode nil
  "A mode for editing Gauche Scheme codes in Emacs"
  :prefix "gauche-mode-"
  :group 'applications)

(defcustom gauche-mode-profiler-max-rows "#f"
  "max number of rows of profiler output"
  :type '(choice integer
		 (const "#f" :tag "output all data"))
  :group 'gauche-mode)

(defcustom gauche-mode-pprint-procedure "write"
  "pretty print procedure for output of macroexpand etc."
  :type 'string
  :group 'gauche-mode)

(defvar gauche-mode-font-lock-keywords
  (append
   `((,(format "(%s\\>"
               (regexp-opt
		'(
		  "define-reader-ctor"
		  "define-record-type"
		  "define-values"
		  "define-constant"
		  "define-in-module"
		  "and-let*"
		  "begin0"
		  "call-with-builder"
		  "call-with-cgi-script"
		  "call-with-client-socket"
		  "call-with-current-continuation"
		  "call-with-ftp-connection"
		  "call-with-input-conversion"
		  "call-with-input-file"
		  "call-with-input-process"
		  "call-with-input-string"
		  "call-with-iterator"
		  "call-with-iterators"
		  "call-with-output-conversion"
		  "call-with-output-file"
		  "call-with-output-process"
		  "call-with-output-string"
		  "call-with-process-io"
		  "call-with-string-io"
		  "call-with-values"
		  "case-lambda"
		  "cond-expand"
		  "cond-list"
		  "cut"
		  "cute"
		  "delay"
		  "dolist"
		  "dotimes"
		  "eager"
		  "guard"
		  "hash-table-for-each"
		  "if-let1"
		  "if-match"
		  "lazy"
		  "let*-values"
		  "let-args"
		  "let-keywords"
		  "let-keywords*"
		  "let-match"
		  "let-optionals*"
		  "let-syntax"
		  "let-values"
		  "let1"
		  "let/cc"
		  "letrec-syntax"
		  "make"
		  "multiple-value-bind"
		  "parameterize"
		  "parse-options"
		  "receive"
		  "rlet1"
		  "rxmatch-case"
		  "rxmatch-cond"
		  "rxmatch-if"
		  "rxmatch-let"
		  "syntax-rules"
		  "unless"
		  "until"
		  "unwind-protect"
		  "when"
		  "while"
		  "with-builder"
		  "with-error-handler"
		  "with-exception-handler"
		  "with-error-to-port"
		  "with-input-conversion"
		  "with-input-from-file"
		  "with-input-from-port"
		  "with-input-from-process"
		  "with-input-from-string"
		  "with-iterator"
		  "with-locking-mutex"
		  "with-module"
		  "with-output-conversion"
		  "with-output-to-file"
		  "with-output-to-port"
		  "with-output-to-process"
		  "with-port-locking"
		  "with-ports"
		  "with-signal-handlers"
		  "with-string-io"
		  "with-time-counter"
		  )
		t))
      1 font-lock-keyword-face)
     (,(format "(%s\\>"
               (regexp-opt
                '("error" "errorf" "syntax-error" "syntax-errorf") t))
      1 font-lock-warning-face)
     (,(format "\\<%s\\>"
	       (regexp-opt
		'("<>" "<...>") t))
      0 font-lock-builtin-face t)
     ("#!\\w+"
      0 font-lock-comment-face)
     ("\\`#!.*"
      0 font-lock-preprocessor-face t)
     ("\\(#\\?=\\|#[0-9]+#\\|#[0-9]+=\\)"
      0 font-lock-preprocessor-face)
     )
   scheme-font-lock-keywords-1
   scheme-font-lock-keywords-2))

(mapc #'(lambda (s)
	  (put (car s) 'scheme-indent-function (cdr s)))
      '(
	(and-let* . 1)
	(begin0 . 0)
	(call-with-builder . 1)
	(call-with-cgi-script . 1)
	(call-with-client-socket . 1)
	(call-with-ftp-connection . 1)
	(call-with-input-conversion . 1)
	(call-with-input-file . 1)
	(call-with-input-process . 1)
	(call-with-input-string . 1)
	(call-with-iterator . 1)
	(call-with-iterators . 1)
	(call-with-output-conversion . 1)
	(call-with-output-file . 1)
	(call-with-output-process . 1)
	(call-with-output-string . 0)
	(call-with-process-io . 1)
	(call-with-string-io . 1)
	(call-with-temporary-file . 1)
	(call-with-values . 1)
	(dolist . 1)
	(dotimes . 1)
	(guard . 1)
	(hash-table-for-each . 1)
	(if-let1 . 2)
	(if-match . 2)
	(let*-values . 1)
	(let-args . 2)
	(let-keywords . 2)
	(let-keywords* . 2)
	(let-match . 2)
	(let-optionals* . 2)
	(let-values . 1)
	(let1 . 2)
	(let/cc . 1)
	(make . 1)
	(make-parameter . 1)
	(match . 1)
	(parameterize . 1)
	(parse-options . 1)
	(pre-pose-order . 1)
	(rlet1 . 2)
	(receive . 2)
	(rxmatch-case . 1)
	(rxmatch-cond . 0)
	(rxmatch-if  . 4)
	(rxmatch-let . 2)
	(syntax-rules . 1)
	(unless . 1)
	(until . 1)
	(unwind-protect . 1)
	(when . 1)
	(while . 1)
	(with-builder . 1)
	(with-error-handler . 1)
	(with-exception-handler . 1)
	(with-error-to-port . 1)
	(with-input-conversion . 1)
	(with-input-from-port . 1)
	(with-input-from-file . 1)
	(with-input-from-process . 1)
	(with-input-from-string . 1)
	(with-iterator . 1)
	(with-locking-mutex . 1)
	(with-module . 1)
	(with-output-conversion . 1)
	(with-output-to-file . 1)
	(with-output-to-port . 1)
	(with-output-to-process . 1)
	(with-port-locking . 1)
	(with-ports . 3)
	(with-signal-handlers . 1)
	(with-string-io . 1)
	(with-time-counter . 1)
	;; R6RS
	(call-with-bytevector-output-port . 0)
	(call-with-current-continuation . 0)
	(call-with-port . 1)
	(call-with-string-output-port . 0)
	(call/cc . 0)
	(datum->syntax . 1)
	(define-condition-type . 2)
	(define-enumeration . 1)
	(define-record-type . 1)
	(dynamic-wind . 0)
	(identifier-syntax . 0)
	(library . 1)
	(letrec* . 1)
	(with-syntax . 1)
	))

(defvar gauche-mode-syntax-table
  (let ((syntax (copy-syntax-table scheme-mode-syntax-table)))
    (modify-syntax-entry ?\| "  2b3" syntax)
    (modify-syntax-entry ?# "_ p14b" syntax)
    syntax))

(defvar gauche-mode-font-lock-syntactic-keywords
  '(
    ;; regexp
    ("#\\(/\\)\\(\\(\\\\\\\\\\)+\\|\\\\[^\\]\\|[^/\\]\\)*\\(/\\)"
     (1 (7 . ?/))
     (4 (7 . ?/)))
    ;; R6RS inline hex escape
    ("\\\\[xX][0-9a-zA-Z]+\\(;\\)" 1 "_")
    ;; R6RS bytevector
    ("#\\(vu8\\)(" 1 "'")
    ))

(defvar gauche-mode-map 
  (let ((map (make-sparse-keymap)))
    (define-key map [(control ?c) (control ?d)] #'gauche-mode-toggle-debug-print)
    (define-key map [(control ?c) (meta ?x)] #'gauche-mode-export-current-symbol)
    (define-key map [(control ?c) (meta ?d)] #'gauche-mode-disassemble)
    (define-key map [(control ?c) (meta ?m)] #'gauche-mode-macroexpand)
    (define-key map [(control ?c) (control ?m)] #'gauche-mode-macroexpand-1)
    (define-key map [(control ?c) (control ?p)] #'gauche-mode-profile-last-sexp)
    (define-key map [(control ?c) ?\;] #'gauche-mode-toggle-datum-comment)
    map))

(define-derived-mode gauche-mode scheme-mode
  "Gauche" "Major mode for Gauche."
  (use-local-map gauche-mode-map)
  (set-syntax-table gauche-mode-syntax-table)
  (setq scheme-program-name "gosh")
  (when (featurep 'qs-complete)
    (set (make-local-variable 'qs-complete-penalty-function)
         #'qs-lisp-penalty-function)
    (set (make-local-variable 'qs-complete-candidates-functions)
         (cons #'gauche-mode-info-candidates
               qs-complete-candidates-functions)))
  (setq comment-start ";;"
        font-lock-defaults
        `(,gauche-mode-font-lock-keywords
          nil t (("+-*/.<>=!?$%_&~^:" . "w")) beginning-of-defun
	  (font-lock-syntactic-keywords . gauche-mode-font-lock-syntactic-keywords)
          (font-lock-mark-block-function . mark-defun)
	  (parse-sexp-lookup-properties . t))
	))

(defun gauche-mode-last-sexp ()
  (save-excursion
    (let* ((ep (point))
          (sp (progn (backward-sexp) (point))))
      (buffer-substring sp ep))))

(defun gauche-mode-export-current-symbol ()
  (interactive)
  (let ((word (thing-at-point 'sexp)))
    (save-excursion
      (unless (re-search-backward "^\\s *(export\\Sw+" nil t)
	(error "No export clause found."))
      (let ((bp (match-beginning 0)))
	(unless (re-search-forward "\\s)" nil t)
	  (error "Unclosed export clause."))
	(let ((ep (match-beginning 0)))
	  (goto-char bp)
	  (if (re-search-forward
	       (concat "\\s " (regexp-quote word) "[ \t\n\f\v\)]") (1+ ep) t)
	      (message "%s is already exported." word) 
	    (goto-char ep)
	    (insert " " word)
	    (lisp-indent-line)
	    (message "Exported %s." word)))))))

(defun gauche-mode-macroexpand (arg &optional n)
  "Expands the last macro and print it on *scheme* buffer.
With universal-argument, do not unwrap syntax."
  (interactive "P")
  (let ((exp (gauche-mode-last-sexp))
        (f (if arg "values" "unwrap-syntax")))
    (comint-send-string
     (scheme-proc)
     (format "(begin (newline) (%s (%s (%%macroexpand%s %s))))\n"
             gauche-mode-pprint-procedure
             f (or n "") exp))))

(defun gauche-mode-macroexpand-1 (arg)
  "Similar to gauche-mode-macroexpand, but use macroexpand-1 instead."
  (interactive "P")
  (gauche-mode-macroexpand arg "-1"))

(defun gauche-mode-profile-last-sexp (key)
  (interactive (list (completing-read "Sort result by: "
				      '("time" "count" "time-per-call")
				      nil t "time" nil)))
  (let ((exp (gauche-mode-last-sexp)))
    (comint-send-string
     (scheme-proc)
     (format "(unwind-protect
                  (begin (newline) (profiler-reset) (profiler-start) %s)
                  (begin (profiler-stop)
                         (profiler-show :sort-by '%s :max-rows %s)))\n"
	     exp key gauche-mode-profiler-max-rows))))

(defun gauche-mode-disassemble (exp)
  (interactive (list (read-string "Disassemble: "
				  (or (thing-at-point 'sexp)
				      (gauche-mode-last-sexp)))))
  (comint-send-string
   (scheme-proc)
   (format "(begin (newline) (disasm %s))\n" exp)))

(defun gauche-mode-toggle-debug-print ()
  (interactive)
  (let ((p (point))
	(c (char-after))
	(d (char-before)))
    (cond
     ((null c) t)			; do nothing
     ((and d
	   (char-equal d ?=)
	   (char-equal (char-before (- p 1)) ??)
	   (char-equal (char-before (- p 2)) ?#))
      (delete-region (- p 3) p))
     ((and (char-equal c ?#)
	   (char-equal (char-after (+ p 1)) ??)
	   (char-equal (char-after (+ p 2)) ?=))
      (delete-region p (+ p 3)))
     ((and (char-equal c ??)
	   (char-equal (char-after (- p 1)) ?#)
	   (char-equal (char-after (+ p 1)) ?=))
      (delete-region (- p 1) (+ p 2)))
     ((and (char-equal c ?=)
	   (char-equal (char-after (- p 1)) ??)
	   (char-equal (char-after (- p 2)) ?#))
      (delete-region (- p 2) (+ p 1)))
     (t
      (insert "#?=")))))

(defun gauche-mode-toggle-datum-comment ()
  (interactive)
  (let ((p (point))
	(b (char-before))
	(c (char-after)))
    (cond
     ((null c) t)			; do nothing
     ((and b
	   (char-equal b ?\;)
	   (char-equal (char-before (- p 1)) ?#))
      (delete-region (- p 2) p))
     ((and (char-equal b ?#)
	   (char-equal c ?\;))
      (delete-region (- p 1) (+ p 1)))
     ((and (char-equal c ?#)
	   (char-equal (char-after (+ p 1)) ?\;))
      (delete-region p (+ p 2)))
     (t
      (insert "#;")))))

;;; info
;; ;; Manual (English)
;; (eval-after-load "info-look"
;;   '(info-lookup-add-help
;;     :topic 'symbol
;;     :mode  'gauche-mode
;;     :regexp "[^()'\" \t\n]+"
;;     :ignore-case nil
;;     :doc-spec '(("(gauche-refe.info)Function and Syntax Index" nil
;;                  "^[ \t]+-- [^:]+:[ \t]*" nil)
;;                 ("(gauche-refe.info)Module Index" nil
;;                  "^[ \t]+-- [^:]+:[ \t]*" nil)
;;                 ("(gauche-refe.info)Class Index" nil
;;                  "^[ \t]+-- [^:]+:[ \t]*" nil)
;;                 ("(gauche-refe.info)Variable Index" nil
;;                  "^[ \t]+-- [^:]+:[ \t]*" nil))
;;     :parse-rule  nil
;;     :other-modes nil))

;; Manual (Japanese)
(eval-after-load "info-look"
  '(info-lookup-add-help
    :topic 'symbol
    :mode  'gauche-mode
    :regexp "[^()'\" \t\n]+"
    :ignore-case nil
    :doc-spec '(("(gauche-refj.info)Index - 手続きと構文索引" nil
                 "^[ \t]+-+ [^:]+:[ \t]*" nil)
                ("(gauche-refj.info)Index - モジュール索引"   nil
                 "^[ \t]+-+ [^:]+:[ \t]*" nil)
                ("(gauche-refj.info)Index - クラス索引"      nil
                 "^[ \t]+-+ [^:]+:[ \t]*" nil)
                ("(gauche-refj.info)Index - 変数索引"        nil
                 "^[ \t]+-+ [^:]+:[ \t]*" nil))
    :parse-rule  nil
    :other-modes nil))

(defun gauche-mode-info-candidates (_pat)
  (mapcar #'car (info-lookup->completions 'symbol 'gauche-mode)))

(provide 'gauche-mode)
