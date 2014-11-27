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

(progn
  ;; 縦分割/横分割切り替え
  ;; @see: http://d.hatena.ne.jp/grandVin/20090716/1247725452
  (defun my-helm-toggle-resplit-window ()
    (interactive)
    (when (helm-window)
      (save-selected-window
        (select-window (helm-window))
        (let ((before-height (window-height)))
          (delete-other-windows)
          (switch-to-buffer helm-current-buffer)
          (if (= (window-height) before-height)
              (split-window-vertically)
            (split-window-horizontally)))
        (select-window (next-window))
        (switch-to-buffer helm-buffer))))
  (define-key helm-map (kbd "C-o") 'my-helm-toggle-resplit-window))

(require 'helm-coding-system)
