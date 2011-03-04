;;; 40_dired.el

(require 'dired-sort)
(require 'dired-color) ; dired-mode で色をつける

;; dired-mode で関連されたファイルを開く
;; 参考: http://d.hatena.ne.jp/mooz/20100915/p1
(defun open-file-dwim (filename)
  "Open file dwim"
  (let* ((winp (string-equal window-system "w32"))
         (opener (if (file-directory-p filename)
                     (if winp '("explorer.exe") '("gnome-open"))
                   (if winp '("fiber.exe") '("gnome-open"))))
         (fn (replace-regexp-in-string "/$" "" filename))
         (args (append opener (list (if winp
                                        (replace-regexp-in-string "/" (rx "\\") fn)
                                      fn))))
         (process-connection-type nil))
    (apply 'start-process "open-file-dwim" nil args)))

;; カーソル下のファイルやディレクトリを関連付けられたプログラムで開く
(defun dired-open-dwim ()
  "Open file under the cursor"
  (interactive)
  (open-file-dwim (dired-get-filename)))

;; 現在のディレクトリを関連付けられたプログラムで開く
(defun dired-open-here ()
  "Open current directory"
  (interactive)
  (open-file-dwim (expand-file-name dired-directory)))

(add-hook 'dired-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c o") 'dired-open-dwim)
             (local-set-key (kbd "C-c .") 'dired-open-here)
             (local-set-key "r" 'wdired-change-to-wdired-mode)
             (local-unset-key (kbd "C-k"))))

;;; dired-mode でディレクトリを移動しても，新しいバッファを作成しない
;; @see: http://www.pshared.net/diary/20071207.html
;; @see: http://xahlee.org/emacs/file_management.html
(require 'dired)
(put 'dired-find-alternate-file 'disabled nil)
(define-key dired-mode-map "a" 'dired-advertised-find-file)
(define-key dired-mode-map "\C-m" 'dired-find-alternate-file)
(define-key dired-mode-map (kbd "^")
    (lambda () (interactive) (find-alternate-file "..")))
