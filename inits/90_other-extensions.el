;;; 90_other-extensions.el ---
;; その他の拡張

;; Migemo
(when (locate-library "migemo")
  (require 'migemo))

;; ibus
(when (locate-library "ibus")
  (require 'ibus)
  (add-hook 'after-init-hook 'ibus-mode-on))

(require 'generic-x) ; 一般的なファイルモード(OS 固有含む)

(progn
  ;; 同名のファイルを開いたときファイル名がわかりやすく見えるように設定
  (require 'uniquify)
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
  )

(require 'anything-coding-system)
