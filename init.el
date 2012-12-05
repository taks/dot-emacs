;; -*- coding: utf-8 -*-

(progn
  ;; Emacs の種類/バージョンを判別するための変数を定義
  ;; @see http://github.com/elim/dotemacs/blob/master/init.el
  ;; @see http://www.gfd-dennou.org/member/uwabami/cc-env/EmacsBasic.html
  (defun x->bool (elt) (not (not elt)))
  (defvar emacs22-p (equal emacs-major-version 22))
  (defvar emacs23-p (equal emacs-major-version 23))
  (defvar darwin-p (eq system-type 'darwin))
  (defvar ns-p (featurep 'ns))
  (defvar carbon-p (and (eq window-system 'mac) emacs22-p))
  (defvar mac-p (and (eq window-system 'mac) emacs23-p))
  (defvar linux-p (eq system-type 'gnu/linux))
  (defvar colinux-p (when linux-p
                      (let ((file "/proc/modules"))
                        (and
                         (file-readable-p file)
                         (x->bool
                          (with-temp-buffer
                            (insert-file-contents file)
                            (goto-char (point-min))
                            (re-search-forward "^cofuse\.+" nil t)))))))
  (defvar cygwin-p (eq system-type 'cygwin))
  (defvar nt-p (eq system-type 'windows-nt))
  (defvar meadow-p (featurep 'meadow))
  (defvar windows-p (or cygwin-p nt-p meadow-p))
  )

(progn
  ;; 言語・文字コードの設定
  ;; @see http://www.gfd-dennou.org/member/uwabami/cc-env/EmacsBasic.htmlw
  (set-language-environment "Japanese")
  (set-language-environment-coding-systems "Japanese")
  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-buffer-file-coding-system 'utf-8)
  (cond
   (mac-p ; local variables
    ;; Mac OS X の HFS+ ファイルフォーマットではファイル名は NFD (の様な
    ;; 物)で扱う. 以下はファイル名を NFC で扱う環境と共同作業等する場合の
    ;; 対処
    (require 'ucs-normalize)
    (setq file-name-coding-system 'utf-8-hfs)
    (setq default-file-name-coding-system 'utf-8-hfs)
    (setq local-coding-system 'utf-8-hfs))
   (windows-p  ; local variables
    ;; Windows 用の設定
    (setq file-name-coding-system 'sjis-dos)
    (setq default-file-name-coding-system 'sjis-dos)
    (setq local-coding-system 'utf-8))
   (t
    ;; default の設定.
    (setq file-name-coding-system 'utf-8)
    (setq default-file-name-coding-system 'utf-8)
    (setq local-coding-system 'euc-japan)))
  )

;;; 実行パスの設定
(defun add-path (dir)
  (when (and (file-exists-p dir) (not (member dir exec-path)))
    (setenv "PATH" (concat dir ":" (getenv "PATH")))
    (setq exec-path (append (list dir) exec-path))))
(add-path (expand-file-name "~/.emacs.d/bin"))
(add-path (expand-file-name "~/lcl/bin"))

;; load-path の設定
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/elisp")

;; elファイルのコンパイル時にエラーがでるので，その対処
(setq warning-suppress-types nil)
(progn
  (require 'init-loader)
  ;; オブション"--debug-init"が指定された場合にはログバッファを表示
  ;; それ以外は，エラーが発生したらログバッファを表示
  (setq init-loader-show-log-after-init (or debug-on-error 'if-error))
  (init-loader-load))

;; サーバーの起動
(progn
  (require 'server)
  (unless (server-running-p)
    (server-start))
  )
