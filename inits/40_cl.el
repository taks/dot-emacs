;;; 40_cl.el
;; slime の設定
(set-language-environment "utf-8")
(setq inferior-lisp-program "~/opt/ccl/lx86cl")
(require 'slime)
(setq slime-net-coding-system 'utf-8-unix)
(slime-setup)
