;;; 40_other-mode-setting.el ---
;; 各モードの細々とした設定

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; scala-mode
;; (require 'scala-mode-auto)
;; (setq scala-interpreter "/usr/local/bin/scala")
;; ;; sbt (for scala)
;; (require 'sbt)

;; ;; scala-modeで*inferior-scala*をポップアップさせるadvice
;; ;; @see: http://d.hatena.ne.jp/tototoshi/20110122/1295689870
;; (defadvice scala-eval-region (after pop-after-scala-eval-region)
;;   (pop-to-buffer scala-inf-buffer-name))
;; (ad-activate 'scala-eval-region)
;; (defadvice scala-eval-buffer (after pop-after-scala-eval-buffer)
;;   (pop-to-buffer scala-inf-buffer-name))
;; (ad-activate 'scala-eval-buffer)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; csharp-mode
(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist (cons '("\\.cs$" . csharp-mode) auto-mode-alist))

;; NOTE: The version of cc-langs.el that came with my Emacs
;; installation has the function c-filter-op defined only at compile
;; time, but it's needed by csharp-mode at run-time. I hacked
;; cc-langs.el and recompiled it to fix this.

;; Patterns for finding Microsoft C# compiler error messages:
(require 'compile)
(push '("^\\(.*\\)(\\([0-9]+\\),\\([0-9]+\\)): error" 1 2 3 2) compilation-error-regexp-alist)
(push '("^\\(.*\\)(\\([0-9]+\\),\\([0-9]+\\)): warning" 1 2 3 1) compilation-error-regexp-alist)

;; Patterns for defining blocks to hide/show:
(push '(csharp-mode
        "\\(^\\s *#\\s *region\\b\\)\\|{"
        "\\(^\\s *#\\s *endregion\\b\\)\\|}"
        "/[*/]"
        nil
        hs-c-like-adjust-block-beginning)
      hs-special-modes-alist)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; zencoding
(require 'zencoding-mode)
(add-hook 'sgml-mode-hook 'zencoding-mode)
(add-hook 'nxml-mode 'zencoding-mode)
(define-key zencoding-mode-keymap (kbd "C-M-j") 'zencoding-expand-line)
(define-key zencoding-mode-keymap (kbd "C-j") nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; bibtex
(modify-coding-system-alist 'file "\\.bib\\'" 'euc-jp)
(add-hook 'bibtex-mode-hook
          '(lambda ()
             (local-unset-key (kbd "C-j"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; doc-view-mode
(add-hook 'doc-view-mode-hook
          '(lambda ()
             (local-unset-key "k")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; view-mode
(global-set-key (kbd "C-x C-q") 'view-mode)
(add-hook 'view-mode-hook
          '(lambda()
             (define-key view-mode-map "j" 'View-scroll-line-forward)
             (define-key view-mode-map "k" 'View-scroll-line-backward)
             (define-key view-mode-map (kbd "C-j") nil)))

(progn
  ;; @see: http://d.hatena.ne.jp/rubikitch/20081104/1225745862
  ;; 書き込み不能なファイルはview-modeで開くように
  (defadvice find-file
    (around find-file-switch-to-view-file (file &optional wild) activate)
    (if (and (not (file-writable-p file))
             (not (file-directory-p file)))
        (view-file file)
      ad-do-it))
  (progn
    ;; 書き込み不能な場合はview-modeを抜けないように
    (defvar view-mode-force-exit nil)
    (defmacro do-not-exit-view-mode-unless-writable-advice (f)
      `(defadvice ,f (around do-not-exit-view-mode-unless-writable activate)
         (if (and (buffer-file-name)
                  (not view-mode-force-exit)
                  (not (file-writable-p (buffer-file-name))))
             (message "File is unwritable, so stay in view-mode.")
           ad-do-it)))

    (do-not-exit-view-mode-unless-writable-advice view-mode-exit)
    (do-not-exit-view-mode-unless-writable-advice view-mode-disable)
    )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; gtags-mode
;; (add-hook gtags-mode
;;           '(lambda ()
;;              (local-set-key (kbd "M-t") 'gtags-find-tag)
;;              (local-set-key (kbd "M-r") 'gtags-find-rtag)
;;              (local-set-key (kbd "M-s") 'gtags-find-symbol)
;;              (local-set-key (kbd "C-t") 'gtags-pop-stack)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yaml-mode
(add-hook 'yaml-mode-hook
          '(lambda ()
             (local-unset-key (kbd "C-j"))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ajc-java-complete
;; (require 'ajc-java-complete-config)
;; (add-hook 'java-mode-hook 'ajc-java-complete-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; scss-mode
(setq scss-compile-at-save nil) ;; 自動コンパイルをオフにする
(setq css-indent-offset 2) ;; インデント量
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; diff-mode
(require 'diff-mode)
(set-face-attribute 'diff-added-face nil
                    :background nil :foreground "green"
                    :weight 'normal)
(set-face-attribute 'diff-removed-face nil
                    :background nil :foreground "firebrick1"
                    :weight 'normal)
(set-face-attribute 'diff-file-header-face nil
                    :background nil :weight 'extra-bold)
(set-face-attribute 'diff-hunk-header-face nil
                    :foreground "chocolate4"
                    :background "white" :weight 'extra-bold
                    :underline t :inherit nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;x
;; js2-mode
(setq c-basic-offset 2)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;x
;; markdowm-mode
;; 折りたたみ
(add-hook 'markdown-mode-hook
          (lambda()
            (define-key markdown-mode-map (kbd "C-i") 'markdown-cycle)
            (hide-sublevels 2)))
(add-to-list 'auto-mode-alist
             '("\\.[Rr]md$" . gfm-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;x
;; pure-mode
(add-hook 'pure-mode-hook
          (lambda ()
            (setq pure-libdir (replace-regexp-in-string "/bin/" "/lib/" pure-prog))))
