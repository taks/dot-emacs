;;;  -*- coding: utf-8; mode: emacs-lisp; -*-
;;; init-loader.el ---

;; Author: IMAKADO <ken.imakado@gmail.com>
;; Author's blog: http://d.hatena.ne.jp/IMAKADO (japanese)
;; Prefix: init-loader-

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; 使い方
;; load-pathの通った場所に置いて
;; (require 'init-loader)
;; (init-loader-load "/path/to/init-directory")

;;  デフォルト設定の場合,以下の順序で引数に渡したディレクトリ以下のファイルをロードする.
;; 引数が省略された場合は,変数`init-loader-directory'の値を使用する.デフォルトは"~/.emacs.d/inits".

;; 1. ソートされた,二桁の数字から始まるファイル. e.x, "00_utils.el" "01_ik-cmd.el" "21_javascript.el" "99_global-keys.el"
;; 2. meadowの場合, meadow から始まる名前のファイル. e.x, "meadow-cmd.el" "meadow-config.el"
;; 3. carbon-emacsの場合, carbon-emacs から始まる名前のファイル. e.x, "carbon-emacs-config.el" "carbon-emacs-migemo.el"
;; 4. windowシステム以外の場合(terminal), nw から始まる名前のファイル e.x, "nw-config.el"

;; ファイルロード後,変数`init-loader-show-log-after-init'の値がtなら,ログバッファを表示する関数を`after-init-hook'へ追加する.
;; また，'if-error ならば，エラー発生時のみ表示する．
;; ログの表示は, M-x init-loader-show-log でも可能.

(eval-when-compile (require 'cl))
(require 'benchmark)

;;; customize-variables
(defgroup init-loader nil
  "init loader"
  :group 'init-loader)

(defcustom init-loader-directory (expand-file-name "~/.emacs.d/inits")
  "inits directory"
  :type 'directory
  :group 'init-loader)

(defcustom init-loader-show-log-after-init t
  "tだと起動時にログバッファを表示する，'if-errorだとエラー発生時のみ表示"
  :type symbol
  :group 'init-loader)

(defcustom init-loader-default-regexp "\\(?:^[[:digit:]]\\{2\\}\\)"
  "起動時に読み込まれる設定ファイルにマッチする正規表現.
デフォルトは二桁の数字から始まるファイルにマッチする正規表現.
e.x, 00_hoge.el, 01_huga.el ... 99_keybind.el"
  :type 'regexp
  :group 'init-loader )

(defcustom init-loader-meadow-regexp "^meadow-"
  "meadow 使用時に読み込まれる設定ファイルにマッチする正規表現"
  :group 'init-loader
  :type 'regexp)

(defcustom init-loader-carbon-emacs-regexp "^carbon-emacs-"
  "carbon-emacs 使用時に読み込まれる設定ファイルにマッチする正規表現"
  :group 'init-loader
  :type 'regexp)

(defcustom init-loader-cocoa-emacs-regexp "^cocoa-emacs-"
  "cocoa-emacs 使用時に読み込まれる設定ファイルにマッチする正規表現"
  :group 'init-loader
  :type 'regexp)

(defcustom init-loader-nw-regexp "^nw-"
  "no-window環境での起動時に読み込まれる設定ファイルにマッチする正規表現"
  :group 'init-loader
  :type 'regexp)

;;; Code
(defun* init-loader-load (&optional (init-dir init-loader-directory))
  (let ((init-dir (init-loader-follow-symlink init-dir)))
    (add-to-list 'load-path init-dir)
    (assert (and (stringp init-dir) (file-directory-p init-dir)))
    (init-loader-re-load init-loader-default-regexp init-dir t)
    ;; meadow
    (and (featurep 'meadow)
         (init-loader-re-load init-loader-meadow-regexp init-dir))
    ;; carbon emacs
    (and (featurep 'carbon-emacs-package)
         (init-loader-re-load init-loader-carbon-emacs-regexp init-dir))
    ;; cocoa emacs
    (and (equal window-system 'ns)
         (init-loader-re-load init-loader-cocoa-emacs-regexp init-dir))
    ;; no window
    (and (null window-system)
         (init-loader-re-load init-loader-nw-regexp init-dir))

    (when (or (eql init-loader-show-log-after-init t)
              (and (eql init-loader-show-log-after-init 'if-error)
                   (not (eql (init-loader-error-log) ""))))
      (add-hook 'after-init-hook 'init-loader-show-log))))

(defun init-loader-follow-symlink (dir)
  (cond ((file-symlink-p dir)
         (expand-file-name (file-symlink-p dir)))
        (t (expand-file-name dir))))

(lexical-let (logs)
  (defun init-loader-log (&optional s)
    (if s (and (stringp s) (push s logs)) (mapconcat 'identity (reverse logs) "\n"))))

(lexical-let (err-logs)
  (defun init-loader-error-log (&optional s)
    (if s (and (stringp s) (push s err-logs)) (mapconcat 'identity (reverse err-logs) "\n"))))

(defun init-loader-re-load (re dir &optional sort)
  (dolist (el (init-loader--re-load-files re dir sort))
    (condition-case e
        (let ((time (car (benchmark-run (load (file-name-sans-extension el))))))
          (init-loader-log (format "loaded %s. %s" (locate-library el) time)))
      (error
       (init-loader-error-log (format "%s. %s" (locate-library el) (error-message-string e)))))))

(defun init-loader--re-load-files (re dir &optional sort)
    (loop for el in (directory-files dir t)
          when (and (string-match re (file-name-nondirectory el))
                    (string-match "\\.el\\'" el))
          collect (file-name-nondirectory el) into ret
          finally return (if sort (sort ret 'string<) ret)))

(defun init-loader-show-log ()
  "return buffer"
  (interactive)
  (let ((b (get-buffer-create "*init log*")))
    (with-current-buffer b
      (erase-buffer)
      (insert "------- error log -------\n\n"
              (init-loader-error-log)
              "\n\n")
      (insert "------- init log -------\n\n"
              (init-loader-log)
              "\n\n")
      ;; load-path
      (insert "------- load path -------\n\n"
              (mapconcat 'identity load-path "\n"))
      (goto-char (point-min)))
    (switch-to-buffer b)))

(provide 'init-loader)

