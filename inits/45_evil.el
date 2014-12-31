;;; evil
(setq evil-cross-lines t
      evil-search-module 'evil-search
      evil-ex-search-vim-style-regexp t)

(require 'evil)
(evil-mode 1)

(evil-define-command evil-save-and-delete-buffer (file &optional bang)
  "Saves the current buffer and closes the buffer."
  :repeat nil
  (interactive "<f><!>")
  (evil-write nil nil nil file bang)
  (evil-delete-buffer (current-buffer)))
(evil-ex-define-cmd "wq" 'evil-save-and-delete-buffer)
(evil-ex-define-cmd "q[uit]" 'kill-this-buffer)

;;; keybind
(define-key evil-insert-state-map "\C-k" nil)

;; 物理行で移動
(define-key evil-motion-state-map "j" 'evil-next-visual-line)
(define-key evil-motion-state-map "k" 'evil-previous-visual-line)

(define-key evil-motion-state-map "/" 'helm-swoop)

(define-key evil-normal-state-map "f" 'jaunte)
