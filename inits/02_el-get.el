;;; init-el-get.el ---

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(when (not (require 'el-get nil t))
  (error "Please bootstrap el-get using the instructions here: http://github.com/dimitri/el-get/, then restart Emacs"))

(setq el-get-sources
      '(el-get
        anything
        org-mode
        markdown-mode
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
        tuareg-mode
        yaml-mode
        quack
        slime
        ac-slime
        (:name cl-indent-patches :type git :url "https://github.com/m2ym/cl-indent-patches-el.git")
        (:name cl-test-more :type http
               :url "https://raw.github.com/netpyoung/emacs-config/master/cl-test-more/cl-test-more.el"
               :after (lambda ()
                        (add-hook 'slime-load-hook (lambda () (require 'cl-test-more)))))

        (:name rinari-taks :type git
               :url "https://github.com/taks/rinari.git"
               :load-path ("." "util" "util/jump")
               :compile ("\\.el$" "util")
               :build ("rake doc:install_info")
               :info "doc")
        rhtml-mode
        zencoding-mode
        moz-repl
        scss-mode
        (:name js2-mode-mooz :type git :url "https://github.com/mooz/js2-mode.git"
               :compile "js2-mode.el"
               :post-init (lambda ()
                            (autoload 'js2-mode "js2-mode" nil t)))
        ;; csharp-mode
        (:name yatex :type hg :url "http://www.yatex.org/hgrepos/yatex")
        (:name matlab-emacs :type git :url "https://github.com/ruediger/matlab-emacs.git"
               :build ("make")
               :load-path ("."))
        (:name my-ess
               :type git
               :url "https://github.com/emacsmirror/ess.git"
               :info "doc/info/"
               :build `(,(concat "make clean && make SVN-REVISION && make --directory=etc all && make --directory=lisp all EMACS=" el-get-emacs))
               :load-path ("lisp")
               :features ess-site)
        (:name auto-complete-acr :type git
               :url "https://github.com/taks/auto-complete-acr.el.git"
               :features (auto-complete-acr ess-R-object-popup))

        (:name ajc-java-complete :type git :url "https://github.com/jixiuf/ajc-java-complete.git"
               :build ("javac Tags.java" "java Tags"))

        smartchr

        ;; ruby関連
        ruby-block
        ruby-end

        haskell-mode

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
        (:name monky :type git
               :url "https://github.com/ananthakumaran/monky.git"
               :autoloads t)
        ;;; anything-hg-project
        (:name anything-hg-project :type http
               :url "https://gist.github.com/raw/810580/76b28aba497acf7fed873399a9997d4d382c0de1/anything-hg-project.el"
               :features anything-hg-project)

        (:name jaunte :type git
               :url "https://github.com/kawaguchi/jaunte.el.git"
               :post-init (lambda ()
                            (require 'jaunte)
                            (global-set-key (kbd "C-c SPC") 'jaunte)))

        (:name scratch-log :type git
               :url "https://github.com/wakaran/scratch-log.git"
               :features scratch-log)
        (:name slime-scratch-log :type git
               :url "https://github.com/wakaran/slime-scratch-log.git"
               :features slime-scratch-log)
        ))

(el-get 'sync (mapcar 'el-get-source-name el-get-sources))

(provide 'init-el-get.el)
;;; init-el-get.el ends here
