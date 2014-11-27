;;; 45_helm.el ---
;; helm 関連の設定

(require 'helm)
(progn
  ;; キーバインド
  (define-key helm-map (kbd "C-j") 'helm-next-line)
  (define-key helm-map (kbd "C-k") 'helm-previous-line)
  (define-key helm-map (kbd "C-p") nil)
  (define-key helm-map (kbd "C-n") nil))

;; どんなにウィンドウが分かれてていても強制的に下部に表示
(when (require 'popwin)
  (setq helm-samewindow nil)
  (setq display-buffer-function 'popwin:display-buffer)
  (setq popwin:special-display-config '(("*compilatoin*" :noselect t)
                                        ("helm" :regexp t :height 0.5))))

(require 'helm-coding-system)
