;;; 40_cl.el
;; slime の設定
(set-language-environment "utf-8")
(setq inferior-lisp-program "~/opt/ccl/lx86cl")
(require 'slime)
(setq slime-net-coding-system 'utf-8-unix)
(slime-setup '(slime-repl))
(add-hook 'slime-mode-hook
          (lambda ()
            (require 'ac-slime)
            (set-up-slime-ac)))

;; pop-win の設定
(push '("*slime-apropos*") popwin:special-display-config)
(push '("*slime-macroexpansion*") popwin:special-display-config)
(push '("*slime-description*") popwin:special-display-config)
(push '("*slime-compilation*" :noselect t) popwin:special-display-config)
(push '("*slime-xref*") popwin:special-display-config)
(push '(sldb-mode :stick t) popwin:special-display-config)
(push '(slime-repl-mode) popwin:special-display-config)
(push '(slime-connection-list-mode) popwin:special-display-config)
