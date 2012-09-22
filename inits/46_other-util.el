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
;; 選択範囲の情報表示
;; @see: http://murakan.cocolog-nifty.com/blog/2011/06/emacs-e05e.html
(defun count-lines-and-chars ()
  (if mark-active
      (format "[%3d:%4d]"
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
    ""))
(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))
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
  (eval-after-load "hideshow"
    '(define-key hs-minor-mode-map (kbd "M-+") 'toggle-hiding)))

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

;; 折りたたみの見た目の変更
(progn
  (define-fringe-bitmap 'hs-marker [0 24 24 126 126 24 24 0])

  (defcustom hs-fringe-face 'hs-fringe-face
    "*Specify face used to highlight the fringe on hidden regions."
    :type 'face
    :group 'hideshow)

  (defface hs-fringe-face
    '((t (:foreground "#888" :box (:line-width 2 :color "grey75" :style released-button))))
    "Face used to highlight the fringe on folded regions"
    :group 'hideshow)

  (defcustom hs-face 'hs-face
    "*Specify the face to to use for the hidden region indicator"
    :type 'face
    :group 'hideshow)

  (defface hs-face
    '((t (:background "#ff8" :box t)))
    "Face to hightlight the ... area of hidden regions"
    :group 'hideshow)

  (defun display-code-line-counts (ov)
    (when (eq 'code (overlay-get ov 'hs))
      (let* ((marker-string "*fringe-dummy*")
             (marker-length (length marker-string))
             (display-string (format " (%d)... " (count-lines (overlay-start ov) (overlay-end ov))))
             )
        (overlay-put ov 'help-echo "Hiddent text. C-c,= to show")
        (put-text-property 0 marker-length 'display (list 'left-fringe 'hs-marker 'hs-fringe-face) marker-string)
        (overlay-put ov 'before-string marker-string)
        (put-text-property 0 (length display-string) 'face 'hs-face display-string)
        (overlay-put ov 'display display-string)
        )))

  (setq hs-set-up-overlay 'display-code-line-counts))

;;; tab binding for hs-minor mode
;; called once on a line that contains a hidden block, shows the
;; block; otherwise calls the default action of TAB; called twice on a
;; line that does not contain a hidden block, hide the block from the
;; current position of the cursor
(defun tab-hs-hide ( &optional arg )
  (interactive "P")
  (let ((sl (save-excursion (move-beginning-of-line nil) (point)))
        (el (save-excursion (move-end-of-line nil) (point)))
        obj)
    (catch 'stop
      (dotimes (i (- el sl))
        (mapc
         (lambda (overlay)
           (when (eq 'hs (overlay-get overlay 'invisible))
             (setq obj t)))
         (overlays-at (+ i sl)))
        (and obj (throw 'stop 'stop))))
    (cond ((and (null obj)
                (eq last-command this-command))
           (hs-hide-block))
          (obj
           (progn
             (move-beginning-of-line nil)
             (hs-show-block)))
          (t
           (save-excursion
             (funcall (lookup-key (current-global-map) (kbd "^I")) arg))))))
(eval-after-load "hideshow"
  '(define-key hs-minor-mode-map [tab] 'tab-hs-hide))

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
;; Sunrise Commander
;; @see: http://www.emacswiki.org/emacs/Sunrise_Commander
(require 'sunrise-commander)
(add-to-list 'auto-mode-alist '("\\.srvm\\'" . sr-virtual-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; wgrep.el
;; (auto-install-from-emacswiki "wgrep.el")
;; (require 'wgrep)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; moz.el

;; MozReplのポート番号。
;; (setq moz-repl-port 24242)

(defun moz-send-reload ()
  (interactive)
  (comint-send-string
   (inferior-moz-process)
   ;; URLのホスト部がlocalhostの場合のみリロード
   "if (content.location.host.indexOf('localhost') != -1) { BrowserReload(); }"))
(add-hook 'after-save-hook
          '(lambda ()
             (if (string-match "\.\\(html\\|css\\|js\\|php\\)" (buffer-file-name))
                 (moz-send-reload))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; magit
(autoload 'magit-status "magit" nil t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; paredit-mode
(define-key paredit-mode-map (kbd "C-j") nil)
(define-key paredit-mode-map (kbd "C-k") nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; folding
(setq folding-mode-prefix-key "\C-c")
(require 'folding)
(define-key folding-mode-map (kbd "M-t") 'folding-toggle-show-hide)
