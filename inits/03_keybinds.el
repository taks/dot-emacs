;;; 01_keybinds.el ---

;; (global-set-key "\C-c\C-t" 'transient-mark-mode)    ;;領域に色を付けるコマンド
;; (global-set-key "\C-xy"    'clipboard-yank)          ;;コピー
;; (global-set-key "\C-xw"    'clipboard-kill-ring-save);;貼り付け

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(global-set-key (kbd "C-\\") nil)
(global-set-key (kbd "C-x r b") 'anything-bookmarks)

(progn
  (require 'cc-cmds)
  (global-set-key (kbd "C-<backspace>") 'c-hungry-delete))
(global-set-key (kbd "M-<backspace>") 'delete-region)

(progn
  ;; smartchr
  ;; @see: http://d.hatena.ne.jp/handlename/20101211/1292079384
  ;; (auto-install-from-url "https://github.com/imakado/emacs-smartchr/raw/master/smartchr.el")
  (require 'smartchr)
  (global-set-key (kbd "(") (smartchr '("(`!!')" "(")))
  (global-set-key (kbd "[") (smartchr '("[`!!']" "[")))
  ;; (global-set-key (kbd "<") (smartchr '("<`!!'>" "<")))
  (global-set-key (kbd "{") (smartchr '("{`!!'}" "{\n`!!'\n}" "{")))
 )

(progn
  ;; カーソル移動に関する設定
  ;;物理行での移動
  (setq-default physical-line-mode t)
  (global-set-key (kbd "C-h") 'backward-char)
  (global-set-key (kbd "C-j") 'next-line)
  (global-set-key (kbd "C-k") 'previous-line)
  (global-set-key (kbd "C-l") 'forward-char)
  (global-set-key (kbd "M-h") 'backward-word)
  (global-set-key (kbd "M-l") 'forward-word)
  (global-unset-key (kbd "C-f"))
  (global-unset-key (kbd "C-b"))
  (global-unset-key (kbd "C-p"))
  (global-set-key (kbd "C-n") 'recenter)
  (global-unset-key (kbd "C-e"))
  (global-unset-key (kbd "C-a"))
  (global-unset-key (kbd "M-b"))
  (global-unset-key (kbd "M-f"))

  (load "vz")
  ;; sequential-command
  ;; @see: http://emacs.g.hatena.ne.jp/k1LoW/20101211/1292046538
  (require 'sequential-command)
  (progn
    (define-sequential-command seq-home
      back-to-indentation vz-left-of-screen beginning-of-buffer seq-return)
    (global-set-key (kbd "C-;") 'seq-home)
    )
  (progn
    (define-sequential-command seq-end
      vz-right-of-screen end-of-buffer seq-return)
    (global-set-key (kbd "C-:") 'seq-end))
  )

(global-set-key (kbd "M-y") 'anything-show-kill-ring)


;;window-sysytemでの設定
(cond (window-system
       (global-unset-key (kbd "C-x C-c"))
       (if (equal (lookup-key (current-global-map) (kbd "C-z")) 'suspend-frame)
           (global-unset-key (kbd "C-z")))
       (global-unset-key (kbd "<inseart>"))
       (load "key-context-menu")
       (global-set-key (kbd "<mouse-3>") 'key-context-menu)
       ))

;;doc-viewでの設定
;(define-key doc-view-mode-map "k" nil)

;; ;; multi-term の起動
;; (global-set-key (kbd "C-c t") '(lambda ()
;;                                  (interactive)
;;                                  (if (get-buffer "*terminal<1>*")
;;                                      (switch-to-buffer "*terminal<1>*")
;;                                    (multi-term))))

(progn
;;; emacs-nav
  (require 'nav)
  (global-set-key (kbd "C-x C-d") 'nav-toggle))

;;; anything
(global-set-key (kbd "M-x") 'anything-M-x)
