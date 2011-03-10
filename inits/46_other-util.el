;;; 46_other-util.el ---

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 削除ファイルをごみ箱に入れる
(cond
 ;; (linux-p ; linux
 ;;  (load "trash-settings")
 ;;  (setq delete-by-moving-to-trash t)
 ;;  (setq system-trash-exclude-matches '("#[^/]+#$" ".*~$"))
 ;;  (setq system-trash-exclude-paths '("^/tmp"))
 ;;  )
  (t      ; default
   ;; dired-mode でのみゴミ箱に捨てる
   (add-hook 'dired-mode-hook (lambda () (set (make-local-variable 'delete-by-moving-to-trash) t)))
   )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; モードラインにバッファで開いているファイルのタイムスタンプを表示する
(require 'file-time-stamp)
(add-hook 'c-mode-common-hook 'file-time-stamp-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;対括弧移動
;(require 'mic-paren)
;(defun my-paren (ARG)
;  (interactive "P")
;  (let ((FOL-CHAR (char-to-string (following-char)))
;        (PRE-CHAR (char-to-string (preceding-char)))
;        (OPEN  "\\s(")
;        (CLOSE "\\s)"))
;    (save-match-data
;      (cond
;       ((and (string-match OPEN FOL-CHAR) (string-match CLOSE PRE-CHAR))
;          (if ARG (mic-paren-forward-sexp) (mic-paren-backward-sexp)))
;       ((string-match OPEN FOL-CHAR)  (mic-paren-forward-sexp))
;       ((string-match CLOSE PRE-CHAR) (mic-paren-backward-sexp))
;       (t (re-search-backward OPEN))))))

;(setq auto-mode-alist (append (list
;                               '(".mybash" . shell-script-mode)
;                               auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; インクリメンタル grep 検索
(load "isearch-grep")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; カーソル付近のファイル/URL を開く
;; C-u C-x C-f で従来の find-file になる
;; 参考: http://www.bookshelf.jp/soft/meadow_23.html#SEC231
(ffap-bindings)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hw-minor-mode の設定
(progn
  ;; "M-+" で折り畳みを切り替えできるようにする
  ;; @see: http://www.emacswiki.org/emacs/HideShow
  (defun toggle-hiding (column)
    (interactive "P")
    (if hs-minor-mode
        (if (condition-case nil
                (hs-toggle-hiding)
              (error t))
            (hs-show-all))
      (toggle-selective-display column)))
  (global-set-key (kbd "M-+") 'toggle-hiding))

(when (locate-library "hideshowvis")
  ;; hideshowvis
  ;; @see: http://d.hatena.ne.jp/uhiaha888/20100720/1279618275
  (autoload 'hideshowvis-enable "hideshowvis" "Highlight foldable regions")
  (autoload 'hideshowvis-minor-mode
    "hideshowvis"
    "Will indicate regions foldable with hideshow in the fringe."
    'interactive)

  (dolist (hook (list 'emacs-lisp-mode-hook
                      'c++-mode-hook
                      'matlab-mode-hook))
    (add-hook hook 'hideshowvis-enable))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; emacs 内でログファイルを tail -f する設定
;; @see: http://d.hatena.ne.jp/kitokitoki/20101211/p1

;; /var/log/ 以下のファイルは自動的に auto-revert-tail-mode マイナーモードで開く
;; バッファ更新時は最新のログを表示するように、ポイントをバッファの末尾に移動させる
(add-hook 'find-file-hook
          '(lambda ()
             (when (string-match "^/var/log/" default-directory)
               (auto-revert-tail-mode t))))
(add-hook 'after-revert-hook
          '(lambda ()
             (when (and (boundp 'auto-revert-tail-mode) auto-revert-tail-mode)
               (end-of-buffer))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 指定したキーワードを目立たせる
;; M-x my-keep-highlight-regexp すれば、対象とする語を指定できます．
;; @see: http://d.hatena.ne.jp/kitokitoki/20101211/p1
;; @see: http://d.hatena.ne.jp/kitokitoki/20100706/p1
(make-face 'my-highlight-face)
(set-face-foreground 'my-highlight-face "black")
(set-face-background 'my-highlight-face "yellow")
(setq my-highlight-face 'my-highlight-face)

(defun my-keep-highlight-regexp (re)
  (interactive "sRegexp: \n")
  (setq my-highlight-keyword re)
  (my-keep-highlight-set-font-lock my-highlight-keyword))

(defun my-keep-highlight-symbole-at-point ()
  (interactive)
  (setq my-highlight-keyword (or (thing-at-point 'symbol) ""))
  (my-keep-highlight-set-font-lock my-highlight-keyword))


(defun my-keep-highlight-set-font-lock (re)
  (font-lock-add-keywords 'nil (list (list re 0 my-highlight-face t)))
  (font-lock-fontify-buffer))

(defun my-cancel-highlight-regexp ()
  (interactive)
  (font-lock-remove-keywords 'nil (list (list my-highlight-keyword 0 my-highlight-face t)))
  (font-lock-fontify-buffer))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cua-mode の使用
;; @see: http://e-arrows.sakura.ne.jp/2010/02/vim-to-emacs.html
;; @see: http://d.hatena.ne.jp/peccu/20100202/1265088619
(cua-mode t)
(setq cua-enable-cua-keys nil) ;; 変なキーバインド禁止

;; @see: http://d.hatena.ne.jp/kitokitoki/20110305/]
(defadvice cua-sequence-rectangle (around my-cua-sequence-rectangle activate)
  "連番を挿入するとき、マークしているところの文字を上書きしないで左にずらす"
  (interactive
   (list (if current-prefix-arg
             (prefix-numeric-value current-prefix-arg)
           (string-to-number
            (read-string "Start value: (0) " nil nil "0")))
         (string-to-number
          (read-string "Increment: (1) " nil nil "1"))
         (read-string (concat "Format: (" cua--rectangle-seq-format ") "))))
  (if (= (length format) 0)
      (setq format cua--rectangle-seq-format)
    (setq cua--rectangle-seq-format format))
  (cua--rectangle-operation 'clear nil t 1 nil
     '(lambda (s e l r)
         (kill-region s e)
         (insert (format format first))
         (yank)
         (setq first (+ first incr)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; windows.el + revive.el
(defvar win:switch-prefix "\C-z")
(require 'windows)
(setq win:use-frame nil)
(win:startup-with-window)
(define-key ctl-x-map "C" 'see-you-again)
(define-key global-map "\C-c\C-r" 'resume-windows)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sunrise Commander
;; @see: http://www.emacswiki.org/emacs/Sunrise_Commander
(require 'sunrise-commander)
(add-to-list 'auto-mode-alist '("\\.srvm\\'" . sr-virtual-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; wgrep.el
;; (auto-install-from-emacswiki "wgrep.el")
;; (require 'wgrep)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
