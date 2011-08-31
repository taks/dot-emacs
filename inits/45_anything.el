;;; 45_anything.el ---
;; anything 関連の設定

(progn
  ;; キーバインド
  (define-key anything-map (kbd "C-j") 'anything-next-line)
  (define-key anything-map (kbd "C-k") 'anything-previous-line)
  (define-key anything-map (kbd "C-p") nil)
  (define-key anything-map (kbd "C-n") nil)
  )

(progn
  ;; どんなにウィンドウが分かれてていても強制的に下部にanything
  ;; @see: http://d.hatena.ne.jp/grandVin/20090716/1247725452
  ;; @see: http://emacs.g.hatena.ne.jp/k1LoW/20090713/1247496970
  ;; @see: http://d.hatena.ne.jp/rubikitch/20101031/splitroot
  ;; (auto-install-from-url "http://nschum.de/src/emacs/split-root/split-root.el")
  (require 'split-root)
  (defvar anything-compilation-window-height-percent 50.0)
  (defun anything-compilation-window-root (buf)
    (setq anything-compilation-window
          (split-root-window (truncate (* (frame-height)
                                          (/ anything-compilation-window-height-percent
                                             100.0)))))
    (set-window-buffer anything-compilation-window buf))
  (setq anything-display-function 'anything-compilation-window-root)
  )

(progn
  ;; 縦分割/横分割切り替え
  ;; @see: http://d.hatena.ne.jp/grandVin/20090716/1247725452
  (defun my-anything-toggle-resplit-window ()
    (interactive)
    (when (anything-window)
      (save-selected-window
        (select-window (anything-window))
        (let ((before-height (window-height)))
          (delete-other-windows)
          (switch-to-buffer anything-current-buffer)
          (if (= (window-height) before-height)
              (split-window-vertically)
            (split-window-horizontally)))
        (select-window (next-window))
        (switch-to-buffer anything-buffer))))

  (define-key anything-map (kbd "C-o") 'my-anything-toggle-resplit-window))
