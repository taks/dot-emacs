;;; helm-coding-system.el ---
;;; 参考: http://d.hatena.ne.jp/kitokitoki/20101120/p1

(defvar helm-c-source-coding-system
  '((name . "文字コードと改行コードを変換する")
    (candidates . helm-coding-system-candidates)
    (action .
      (("バッファの文字コード/改行コードを指定したものに変換して読込みなおす" .
        revert-buffer-with-coding-system)
       ("ファイルの文字コード/改行コードを指定したものに変換する(保存はしない)" .
        set-buffer-file-coding-system)))))

(defvar helm-coding-system-candidates
      '(("UTF-8  LF" . utf-8-unix)
        ("UTF-8  CR" . utf-8-mac)
        ("UTF-8  CRLF" . utf-8-dos)
        ("EUC-JP LF" . euc-jp-unix)
        ("EUC-JP CR" . euc-jp-mac)
        ("EUC-JP CRLF" . euc-jp-dos)
        ("sjis   CRLF" . sjis-dos)
        ("sjis   CR" . sjis-mac)
        ("sjis   LF" . sjis-unix)))

(defun helm-coding-system ()
  (interactive)
  (helm-other-buffer
   '(helm-c-source-coding-system)
      "*helm-coding-system*"))

(defalias 'coding 'helm-coding-system)

(provide 'helm-coding-system)
