;;; init-el-get.el ---

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(when (not (require 'el-get nil t))
  (error "Please bootstrap el-get using the instructions here: http://github.com/dimitri/el-get/, then restart Emacs"))

(setq el-get-sources
      '(el-get
        anything
        (:name split-root :type http
               :url "http://nschum.de/src/emacs/split-root/split-root.el")
        yasnippet
        (:name anything-c-yasnippet :type http
               :url "http://svn.coderepos.org/share/lang/elisp/anything-c-yasnippet/anything-c-yasnippet.el" )

        (:name color-theme-bzr :type bzr
               :url "http://bzr.savannah.nongnu.org/r/color-theme/trunk"
               :load "color-theme.el"
               :features "color-theme"
               :post-init (lambda ()
                            (color-theme-initialize)
                            (setq color-theme-is-global t)))

        auto-complete

        (:name shell-command :type http :url "http://www.namazu.org/~tsuchiya/elisp/shell-command.el")
        multi-term

        (:name color-moccur :type http :url "http://www.bookshelf.jp/elc/color-moccur.el")
        (:name moccur-edit :type http :url "http://www.bookshelf.jp/elc/moccur-edit.el")
        (:name anything-c-moccur :type svn
               :url "http://svn.coderepos.org/share/lang/elisp/anything-c-moccur/trunk")

        ;; recentfの拡張
        ;; @see: http://d.hatena.ne.jp/rubikitch/20091224/recentf
        (:name recentf-ext :type emacswiki :features recentf-ext)

        (:name redo+ :type emacswiki
               :after (lambda ()
                        (require 'redo+)
                        (global-set-key (kbd "C-M-/") 'redo)
                        (setq undo-no-redo t)))

        (:name goto-chg-git :type git :url "https://github.com/martinp26/goto-chg.git"
               :features goto-chg
               :after (lambda ()
                        (global-set-key (kbd "C-.") 'goto-last-change)
                        (global-set-key (kbd "C-,") 'goto-last-change-reverse)))

        nav

        ;; historyf
        ;; @see: http://emacs.g.hatena.ne.jp/k1LoW/20100410/1270886156
        (:name historyf :type git :url "https://github.com/k1LoW/emacs-historyf.git"
               :features historyf)

        (:name d-mode :type bzr :url "lp:emacs-d-mode"
               :after (lambda ()
                        (autoload 'd-mode "d-mode" "Major mode for editing D code." t)
                        (add-to-list 'auto-mode-alist '("\\.d[i]?\\'" . d-mode))
                        (add-hook 'd-mode-hook
                                  '(lambda ()
                                     (c-toggle-auto-state)))))
        lua-mode
        yaml-mode
        quack
        slime
        ac-slime
        (:name rinari-taks :type git
               :url "https://github.com/taks/rinari.git"
               :load-path ("." "util" "util/jump")
               :compile ("\\.el$" "util")
               :build ("rake doc:install_info")
               :info "doc")
        rhtml-mode
        zencoding-mode
        moz-repl
        ;; csharp-mode
        (:name yatex :type hg :url "http://www.yatex.org/hgrepos/yatex")
        (:name matlab-emacs :type git :url "https://github.com/ruediger/matlab-emacs.git"
               :build ("make")
               :load-path ("."))
        (:name my-ess
               :type svn
               :url "https://svn.r-project.org/ESS/trunk/"
               :info "doc/info/"
               :build `(,(concat "make --directory=lisp all EMACS=" el-get-emacs))
               :load-path ("lisp")
               :features ess-site)

        smartchr

        ;; ruby関連
        ruby-block
        ruby-end

        (:name sequential-command :type emacswiki)
        (:name sequential-command-config :type emacswiki)

        ;; emacs の中で sudo を行う
        ;; 参考: http://d.hatena.ne.jp/rubikitch/20101018/sudoext
        (:name sudo-ext :type emacswiki :features sudo-ext)

        (:name hideshowvis :type emacswiki)

        (:name shell-pop :type emacswiki)

        (:name revive :type http :url "http://www.gentei.org/~yuuji/software/revive.el")
        (:name windows-from-http :type http :url "http://www.gentei.org/~yuuji/software/windows.el")

        sunrise-commander

        ;; @see: http://d.hatena.ne.jp/m2ym/20110120/1295524932
        (:name popwin :type git :url "https://github.com/m2ym/popwin-el.git"
               :load-path ("." "misc")
               :features popwin
               :after (lambda ()
                        (setq display-buffer-function 'popwin:display-buffer)))

        ;;; anything-replace-string
        ;; @see: http://emacs.g.hatena.ne.jp/k1LoW/20110107/1294408979
        ;; @see: https://github.com/k1LoW/anything-replace-string
        (:name anything-replace-string :type git
               :url "https://github.com/k1LoW/anything-replace-string.git"
               :features anything-replace-string)

        ;;; anything-git-project
        ;; @see: http://d.hatena.ne.jp/yaotti/20101216/1292500323
        (:name anything-git-project :type http
               :url "https://gist.github.com/raw/741587/3c47bd2cb0350ae40a44bfc075ad93f41524f32c/anything-git-project.el"
               :load "anything-git-project.el")
        magit
        ;;; anything-hg-project
        (:name anything-hg-project :type http
               :url "https://gist.github.com/raw/810580/76b28aba497acf7fed873399a9997d4d382c0de1/anything-hg-project.el"
               :features anything-hg-project)
        ))

(el-get 'sync)

(provide 'init-el-get.el)
;;; init-el-get.el ends here
