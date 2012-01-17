;;; 90_other-extensions.el ---
;; その他の拡張

;; Migemo
(when (locate-library "migemo")
  (require 'migemo))

;; ibus
(when (locate-library "ibus")
  (require 'ibus)
  (add-hook 'after-init-hook 'ibus-mode-on))

(progn
  ;; 同名のファイルを開いたときファイル名がわかりやすく見えるように設定
  (require 'uniquify)
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
  )

(require 'anything-coding-system)


(progn
  ;; windows
  ;; @see: http://d.hatena.ne.jp/khiker/20110508/windowsel
  (setq win:use-frame nil
        win:quick-selection nil
        win:switch-prefix "\C-z")
  (require 'windows)
  (win:startup-with-window)
  (define-key win:switch-map ";" 'win-switch-menu)
  (define-key ctl-x-map "C" 'see-you-again))
