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
        (:name rinari-taks :type git
               :url "https://github.com/taks/rinari.git"
               :load-path ("." "util" "util/jump")
               :compile ("\\.el$" "util")
               :build ("rake doc:install_info")
               :info "doc")
        rhtml-mode
        zencoding-mode
        ;; csharp-mode
        (:name yatex :type hg :url "http://www.yatex.org/hgrepos/yatex")
        (:name matlab-emacs :type git :url "https://github.com/ruediger/matlab-emacs.git"
               :build ("make")
               :load-path ("."))

        smartchr

        ;; ruby関連
        ruby-block

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
               :features popwin
               :after (lambda ()
                        (setq display-buffer-function 'popwin:display-buffer)))

        ;;; anything-replace-string
        ;; @see: http://emacs.g.hatena.ne.jp/k1LoW/20110107/1294408979
        ;; @see: https://github.com/k1LoW/anything-replace-string
        (:name anything-replace-string :type git
               :url "https://github.com/k1LoW/anything-replace-string.git"
               :features anything-replace-string)
        ))

(el-get 'sync)

(provide 'init-el-get.el)
;;; init-el-get.el ends here
