;;; 45_auto-complete.el ---

;; auto-complete ポップアップメニューで自動補完
;; @see: http://cx4a.org/software/auto-complete/manual.ja.html
(require 'auto-complete)
(global-auto-complete-mode t)
;; Maybe default-enable-multibyte-characters is t by default
(setq default-enable-multibyte-characters t)
;; デフォルトの情報源
(require 'auto-complete-yasnippet)
(setq-default ac-sources '(ac-source-words-in-same-mode-buffers
                           ac-source-yasnippet
                           ac-source-filename
                           ))
;; @see: http://bitbucket.org/sakito/dot.emacs.d/src/047708c00326/site-start.d/init_ac.el
;; クイックヘルプが表示されるとバッファが大きく変更される場合があるので停止
(setq ac-use-quick-help nil)
;; キー設定
(define-key ac-completing-map (kbd "C-m") 'ac-complete)
(define-key ac-completing-map (kbd "C-j") 'ac-next)
(define-key ac-completing-map (kbd "C-k") 'ac-previous)
(define-key ac-completing-map (kbd "<C-tab>") 'ac-stop)

;; 補完対象のモードを追加
(when (boundp 'ac-modes)
  (setq ac-modes
        (append ac-modes
                (list 'd-mode 'yatex-mode 'matlab-mode
                      'gauche-mode 'scheme-mode 'ess-mode))))
;; 色の変更
(add-hook 'AC-mode-hook
          (set-face-background 'ac-selection-face "gray35"))
