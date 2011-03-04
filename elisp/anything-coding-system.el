;;; anything-coding-system.el ---
;;; 参考: http://d.hatena.ne.jp/kitokitoki/20101120/p1

(require 'anything)
(require 'anything-config)

(defvar anything-c-source-coding-system
  '((name . "文字コードと改行コードを変換する")
    (candidates . anything-coding-system-candidates)
    (action .
      (("バッファの文字コード/改行コードを指定したものに変換して読込みなおす" .
        revert-buffer-with-coding-system)
       ("ファイルの文字コード/改行コードを指定したものに変換する(保存はしない)" .
        set-buffer-file-coding-system)))))

(defvar anything-coding-system-candidates
      '(("UTF-8  LF" . utf-8-unix)
        ("UTF-8  CR" . utf-8-mac)
        ("UTF-8  CRLF" . utf-8-dos)
        ("EUC-JP LF" . euc-jp-unix)
        ("EUC-JP CR" . euc-jp-mac)
        ("EUC-JP CRLF" . euc-jp-dos)
        ("sjis   CRLF" . sjis-dos)
        ("sjis   CR" . sjis-mac)
        ("sjis   LF" . sjis-unix)))

(defun anything-coding-system ()
  (interactive)
  (anything-other-buffer
   '(anything-c-source-coding-system)
      "*anything-coding-system*"))

(defalias 'coding 'anything-coding-system)

(provide 'anything-coding-system)
;;; anything-coding-system.el ends here
