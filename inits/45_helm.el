;;; 45_helm.el ---
;; helm 関連の設定

(require 'helm)
(progn
  ;; キーバインド
  (define-key helm-map (kbd "C-j") 'helm-next-line)
  (define-key helm-map (kbd "C-k") 'helm-previous-line)
  (define-key helm-map (kbd "C-p") nil)
  (define-key helm-map (kbd "C-n") nil))

(progn
  ;; どんなにウィンドウが分かれてていても強制的に下部に表示
  ;; @see: http://d.hatena.ne.jp/grandVin/20090716/1247725452
  ;; @see: http://emacs.g.hatena.ne.jp/k1LoW/20090713/1247496970
  ;; @see: http://d.hatena.ne.jp/rubikitch/20101031/splitroot
  (require 'split-root)
  (defvar helm-compilation-window-height-percent 50.0)
  (defun helm-compilation-window-root (buf)
    (setq helm-compilation-window
          (split-root-window (truncate (* (frame-height)
                                          (/ helm-compilation-window-height-percent
                                             100.0)))))
    (set-window-buffer helm-compilation-window buf))
  (setq helm-display-function 'helm-compilation-window-root))

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
