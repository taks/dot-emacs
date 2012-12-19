;;; 40_ibuffer.el
;; 参考: http://www.emacswiki.org/emacs/IbufferMode
;;     : http://martinowen.net/blog/2010/02/tips-for-emacs-ibuffer.html
(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("dired" (mode . dired-mode))
               ("matlab" (mode . matlab-mode))
               ("planner" (or
                           (name . "^\\*Calendar\\*$")
                           (name . "^diary$")
                           (mode . muse-mode)))
               ("emacs"  (name . "^\\*[^\\*]+\\*$"))
               ("gnus" (or
                        (mode . message-mode)
                        (mode . bbdb-mode)
                        (mode . mail-mode)
                        (mode . gnus-group-mode)
                        (mode . gnus-summary-mode)
                        (mode . gnus-article-mode)
                        (name . "^\\.bbdb$")
                        (name . "^\\.newsrc-dribble")))))))
(add-hook 'ibuffer-mode-hook
          '(lambda ()
             (ibuffer-switch-to-saved-filter-groups "default")))

;; filter(上記)でマッチしない場合は、フィルタグループを表示しない
(setq ibuffer-show-empty-filter-groups nil)

;; ディレクトリの表示の短縮
(setq ibuffer-directory-abbrev-alist
      '(("^/ssh:\\([a-zA-Z]+\\)@figaro:/home/\\1/" . "figaro:~/")))

;; 表示しないバッファの設定 (for emacs23.2 ?)
(require 'ibuf-ext)
(add-to-list 'ibuffer-never-show-predicates "^\\*tramp/ssh")
(add-to-list 'ibuffer-never-show-predicates "^\\*helm[\\* ]")

(add-hook 'ibuffer-hook
          '(lambda ()
             (local-unset-key (kbd "C-k"))))

;; カーソルの行に色をつける
(require 'hl-line)
(add-hook 'ibuffer-mode-hook
          '(lambda ()
             (hl-line-mode t)))
