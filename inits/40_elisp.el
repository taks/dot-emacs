;;; 40_elisp.el

(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; lisp-interaction-mode
(add-hook 'lisp-interaction-mode-hook
          '(lambda ()
             (local-unset-key (kbd "C-j"))
             (local-set-key (kbd "C-c C-j") 'eval-print-last-sexp)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; emacs-lisp-mode
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (hs-minor-mode t)
             (local-set-key [return] 'newline-and-indent)))

(progn
  ;; eldoc
  ;; @see: http://d.hatena.ne.jp/rubikitch/20090207/1233936430
  (require 'eldoc)
  ;; (auto-install-from-emacswiki "eldoc-extension.el")
  ;; (require 'eldoc-extension)
  (setq eldoc-idle-delay 0)
  (setq eldoc-echo-area-use-multiline-p t)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'ielm-mode-hook 'turn-on-eldoc-mode))

(add-hook 'emacs-lisp-mode 'rainbow-delimiters-mode)
