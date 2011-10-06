;;; 40_cl.el
;; slime の設定
(set-language-environment "utf-8")
(setq inferior-lisp-program "~/opt/ccl/lx86cl")
(require 'slime)
(setq slime-net-coding-system 'utf-8-unix)
(slime-setup '(slime-repl slime-fancy slime-banner slime-scratch))
(add-hook 'slime-mode-hook
          (lambda ()
            (require 'ac-slime)
            (set-up-slime-ac)))
(add-hook 'after-init-hook
          '(lambda ()
             (slime-scratch)
             (define-key slime-scratch-mode-map (kbd "C-j") nil)))

;;; 履歴の設定
(setq slime-repl-history-remove-duplicates t)
(setq slime-repl-history-trim-whitespaces t)

;; pop-win の設定
(push '("*slime-apropos*") popwin:special-display-config)
(push '("*slime-macroexpansion*") popwin:special-display-config)
(push '("*slime-description*") popwin:special-display-config)
(push '("*slime-compilation*" :noselect t) popwin:special-display-config)
(push '("*slime-xref*") popwin:special-display-config)
(push '(sldb-mode :stick t) popwin:special-display-config)
(push '(slime-repl-mode) popwin:special-display-config)
(push '(slime-connection-list-mode) popwin:special-display-config)

;; インデントの修正
(when (require 'cl-indent-patches nil t)
  ;; emacs-lispのインデントと混同しないように
  (setq lisp-indent-function
        (lambda (&rest args)
          (apply (if (memq major-mode '(emacs-lisp-mode lisp-interaction-mode))
                     'lisp-indent-function
                   'common-lisp-indent-function)
                 args))))
