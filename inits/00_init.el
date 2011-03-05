;;; 00_init.el ---
;; 基本的な設定

(setq custom-file "~/.emacs.d/customize.el")
(load custom-file t)               ;;customizeによる設定を.emacsから分離

(set-scroll-bar-mode 'right)    ; スクロールバーを右に表示
(setq frame-title-format (format "emacs@%s : %%f" (system-name))) ; タイトルバーの設定
(tool-bar-mode 0)
(menu-bar-mode 1)
(column-number-mode t) ; カーソルの位置が何文字目かを表示する
(which-function-mode 1) ; 現在の関数名をモードラインに表示
(setq inhibit-startup-message t) ; 起動時の画面を表示しない
(show-paren-mode t)

(auto-compression-mode t)  ; 日本語infoの文字化け防止
(setq kill-whole-line t) ; 行の先頭でC-kを一回押すだけで行全体を消去する
(setq default-tab-width 4)
(setq scroll-step 1)    ; 画面上下の端の外にスクロールしたときの移動量を1にする設定
(setq bookmark-save-flag 1)      ; しおりの逐次保存
(setq visible-bell t)  ; beep音を消す
(setq-default indent-tabs-mode nil)   ; スペースだけでインデントする
(setq require-final-newline t) ; 最後に改行がない場合、自動的に改行する
(setq redisplay-dont-pause t) ; スクロールを早くする
(add-hook 'before-save-hook 'delete-trailing-whitespace) ; ファイルのセーブ時に行末の空白を消去

;; avoid "Symbolic link to SVN-controlled source file; follow link? (yes or no)"
(setq vc-follow-symlinks t)

(progn
;;; バックアップファイルの設定
  (setq make-backup-files t)
  (setq backup-directory-alist
        (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
              backup-directory-alist))
  (setq version-control t)
  (setq kept-new-versions 2)   ;; 新しいものをいくつ残すか
  (setq kept-old-versions 2)   ;; 古いものをいくつ残すか
  (setq delete-old-versions t)
  )
(setq auto-save-default t)

;; Dropbox に Emacs のバックアップファイルを同期させない
;; @see: http://d.hatena.ne.jp/mooz/20110107/p1
(let ((dropbox-directory (expand-file-name "~/Dropbox/"))
      (destination-directory temporary-file-directory))
  (add-to-list 'auto-save-file-name-transforms
               `(,(concat dropbox-directory "\\([^/]*/\\)*\\([^/]*\\)$")
                 ,(concat destination-directory "\\2") t))
  (add-to-list 'backup-directory-alist
               `(,dropbox-directory . ,destination-directory)))

;;動的略語補完の設定
(setq dabbrev-case-fold-search nil)

;; 画面の最大化
(if (string< "23.2" emacs-version)
    (set-frame-parameter nil 'fullscreen 'maximized))

;; ブックマークの保存位置
(setq bookmark-default-file "~/.emacs.d/.emacs.bmk")

;;; ediffを1ウィンドウで実行
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
