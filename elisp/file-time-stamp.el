;;; file-time-stamp.el --- display file time stamps in the mode line

;;; Copyright (C) 2005 R

;; Author: R
;; Version: $Id: file-time-stamp.el,v 1.00 2005/04/25 09:00:00 $

;; file-time-stamp.el is free software; you can redistribute it
;; and/or modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2, or
;; (at your option) any later version.

;; file-time-stamp.el is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied warranty
;; of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.

;;; Commentary:
;;
;; This package displays the time stamp saved at the end of the open file
;; in the mode line.  Use M-x file-time-stamp-mode RET to
;; toggle.

;;; Code:

(defconst file-time-stamp-version "1.0.0"
  "Version number of this package.")

(defvar file-time-stamp nil
  "String used by function `file-time-stamp-mode'.")
(make-variable-buffer-local 'file-time-stamp)

;; Customizable variables

(defgroup file-time-stamp nil
  "Display file time stamps in the mode line."
  :group 'tools)

(defcustom file-time-stamp-format nil
  "Time stamp format used for `file-time-stamp'.
If a string, the value is passed to `format-time-string'. If a
function, this is evaluated, and should return a string. If nil,
`current-time-string' is used."
  :group 'file-time-stamp
  :set (lambda (sym val)
         (set sym val)
         (and (fboundp 'file-time-stamp-update)
              (dolist (b (buffer-list))
                (with-current-buffer b
                  (file-time-stamp-update)))))
  :type '(choice (const :tag "Default format (current-time-string)" nil)
                 (string :tag "Custom format")
                 (function :tag "Lisp function name (or lambda expression)")))

(define-minor-mode file-time-stamp-mode
  "Toggle File Time-Stamp mode.
This package displays the time stamp saved at the end of the open file
 in the mode line."
  nil file-time-stamp nil
  (if file-time-stamp-mode
      (progn
         (add-hook 'find-file-hooks 'file-time-stamp-update nil t)
         (add-hook 'after-save-hook 'file-time-stamp-update nil t)
         (add-hook 'after-revert-hook 'file-time-stamp-update nil t)
        (setq file-time-stamp " "))
    (remove-hook 'find-file-hooks 'file-time-stamp-update t)
    (remove-hook 'after-save-hook 'file-time-stamp-update t)
    (remove-hook 'after-revert-hook 'file-time-stamp-update t)
    (setq file-time-stamp nil)))

(defun file-time-stamp-update (&rest ignore)
  "Update `file-time-stamp' for the current buffer."
  (when file-time-stamp-mode
    (setq file-time-stamp
          (format " [%s]"
                  (cond
                   ((null file-time-stamp-format)
                    (current-time-string (visited-file-modtime)))     ;; ++
                   ((stringp file-time-stamp-format)
                    (format-time-string file-time-stamp-format))
                   ((functionp file-time-stamp-format)
                    (let ((res (funcall file-time-stamp-format)))
                      (if (stringp res) res "?")))
                   (t
                    "?"))))
    (force-mode-line-update)))

(provide 'file-time-stamp)

;;; file-time-stamp.el ends here
