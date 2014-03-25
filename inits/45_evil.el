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

(define-key evil-insert-state-map "\C-k" nil)

(setq evil-emacs-state-modes nil)
