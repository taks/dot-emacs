;;; 45_shell.el ---

;; shell-commandの補完
(require 'shell-command)
(shell-command-completion-mode)

;; term-mode
(add-hook 'term-mode-hook
          '(lambda ()
             (define-key term-raw-map (kbd "C-j") 'backward-char)
             (define-key term-raw-map (kbd "C-k") 'next-line)
             (define-key term-raw-map (kbd "C-l") 'previous-line)
             (define-key term-raw-map (kbd "C-;") 'forward-char)))

;;; multi-term
(require 'multi-term)
(setq multi-term-program shell-file-name)

;;; shell-popup
;; @see: http://e-arrows.sakura.ne.jp/2010/02/vim-to-emacs.html
;; @see: http://sakito.jp/emacs/emacsshell.html
(require 'shell-pop)
;; multi-term に対応
(add-to-list 'shell-pop-internal-mode-list '("multi-term" "*terminal<1>*" '(lambda () (multi-term))))
(shell-pop-set-internal-mode "multi-term")
;; 25% の高さに分割する
(shell-pop-set-window-height 25)
(shell-pop-set-internal-mode-shell shell-file-name)
;; ショートカット
(global-set-key [f8] 'shell-pop)
