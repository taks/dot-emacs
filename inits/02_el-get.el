;;; 02_el-get.el ---

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil t)
  ;; el-get がインストールされていなければ，インストールを行う
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp))))
;; 追加のレシピ置き場
(add-to-list 'el-get-recipe-path
             "~/.emacs.d/el-get-local-recipes")

(setq my-packages
      '(el-get
        helm
        org-mode
        markdown-mode
        split-root

        yasnippet
        anything-c-yasnippet

        auto-complete-github
        ;; fuzzy

        shell-command
        multi-term

        color-moccur
        moccur-edit
        anything-c-moccur

        recentf-ext

        redo+

        goto-chg

        nav

        historyf

        d-mode
        pure-mode
        lua-mode
        tuareg-mode
        typerex2
        fsharp-mode
        yaml-mode
        geiser
        slime
        ac-slime
        paredit
        rainbow-delimiters-github
        ;; cl-indent-patches

        cl-test-more

        ;; rinari-taks
        rhtml-mode
        zencoding-mode
        moz-repl
        scss-mode
        js2-mode-mooz

        auctex
        ac-math

        matlab-emacs

        ess-github

        imaxima
        sage-mode

        ;; ajc-java-complete

        smartchr

        ruby-block
        ruby-end

        haskell-mode

        sequential-command
        sequential-command-config

        sudo-ext

        hideshowvis
        folding-my

        shell-pop

        revive
        windows

        sunrise-commander

        popwin

        anything-replace-string

        anything-git-project
        magit
        emacs-git-gutter

        jaunte

        ;;scratch-log
        ))

(el-get 'sync my-packages)
;;; 02_el-get.el ends here
