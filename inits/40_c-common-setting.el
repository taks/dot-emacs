;;; 40_c-common-setting.el ---
;; c系共通設定

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;doxymacs
;; (require 'doxymacs)
;; (defun doxygen-menu (arg &optional char)
;;   "menu for call doxymacs command"
;;   (interactive "P")
;;   (message "F)anction member(;) f(I)le M)ultiline")
;;   (let ((sw (selected-window)) (c (or char (read-char))))
;;     (require 'doxymacs)
;;     (select-window sw)
;;     (cond
;;      ((= c ?f) (doxymacs-insert-function-comment))
;;      ((= c ?\;) (doxymacs-insert-member-comment))
;;      ((= c ?i) (doxymacs-insert-file-comment))
;;      ((= c ?m) (doxymacs-insert-blank-multiline-comment))
;;      ((= c ?s) (doxymacs-insert-blank-singleline-comment))
;;      ((= c ?c) (doxygen-command))
;;      )))

;; (defvar doxygen-specialcommand-char "@")
;; (defvar doxygen-specialcommand-list
;;       '(("attension") ("autor") ("brief") ("bug") ("date") ("deprecated")
;;         ("exception") ("note") ("par") ("param") ("post")
;;         ("pre") ("remarks") ("return") ("retval") ("see") ("test") ("todo")
;;         ("version") ("warning")))
;; (defun doxygen-command ()
;;   "complement doxygen special command"
;;   (interactive)
;;   (let (command)
;;     (setq command (completing-read "Select special command: " doxygen-specialcommand-list))
;;     (insert (concat doxygen-specialcommand-char command " "))
;;     (if (fboundp (intern-soft (concat "doxygen::" command)))
;;         (funcall (intern-soft (concat "doxygen::" command))))))
;; (defun doxygen::autor () (insert (concat user-full-name "<" user-mail-address ">")))
;; (defun doxygen::date () (insert (format-time-string "%Y/%m/%d" (current-time))))
;; (defun doxygen::f$ () (insert "f$"))

;; (defun char-ahead-line-text ()
;;   (let (char)
;;     (save-excursion
;;       (beginning-of-line)
;;       (skip-chars-forward " \t")
;;       (setq char (char-after)))
;;   char))

;; (defun my-doxymacs-font-lock-hook ()
;;   (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode) (eq major-mode 'jde-mode))
;;       (doxymacs-font-lock)))
;; (add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 関数定義
(defun c-newline-in-brace ()
  (newline)
  (newline-and-indent)
  (vz-left-of-screen)
  (backward-char)
  (c-indent-command))
(defun c-common-newline ()
  "newline for programming"
  (interactive)
  (cond
   ((and (= (preceding-char) ?{) (= (following-char) ?}))
        (c-newline-in-brace))
   (t (newline-and-indent))
   ))

(defun c-in-string-p ()
  (let ((p (point)) (nest 0))
    (save-excursion
      (goto-char (point-min))
      (while (< (point) p)
        (if (and (= (following-char) ?\") (not (= (preceding-char) 92)))
            (setq nest (+ nest 1)))
        (forward-char)
        )
      )
    (= (% nest 2) 1)))
(defun c-insert-qote ()
  (interactive)
  (if (c-in-string-p)
      (if (and (= (following-char) ?\") (= (preceding-char) ?\"))
          (forward-char)
        (insert "\""))
    (insert "\"\"")
    (backward-char)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (autoload 'gtags-mode "gtags" "" t)

;;c-modeでのswitchのインデントがうまくいくように
;;(c-set-offset 'case-label '+)
(setq c-basic-offset 4) ; cモードのタブ幅を4に

(add-hook 'c-mode-common-hook
          '(lambda ()
             (setq indent-tabs-mode nil) ;全部空白
             ;; (c-toggle-auto-state -1) ;自動的に改行しない
             (define-key c-mode-base-map (kbd "C-m") 'c-common-newline)
             (define-key doxymacs-mode-map (kbd "C-c d") 'doxygen-menu)
             ;; (define-key doxymacs-mode-map "@" 'doxygen-command)
             (define-key c-mode-base-map [M-return] 'c-indent-new-comment-line)
             (local-set-key "\"" 'c-insert-qote)
             (doxymacs-mode)
             ;; (gtags-mode 1)
             ;; (gtags-make-complete-list)
             (local-unset-key (kbd "C-c C-d"))))

;; CやJavaの"if"の後の"="を警告表示にする
;; @see: http://ynomura.dip.jp/archives/2011/01/emacs_font_lock.html
(add-hook 'c-mode-common-hook
  '(lambda ()
    (font-lock-add-keywords major-mode '(
      ("\\<if\\>"
       ("[^<>=]\\(=\\)[^=]" nil nil (1 font-lock-warning-face))
       )))))
