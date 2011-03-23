;;; yatex-patch.el
;; yatex の様々な改良を行う

(defun YaTeX::pagestyle (&optional argp)
  "Read the pagestyle with completion."
  (completing-read
   "Page style: "
   '(("plain") ("empty") ("headings") ("myheadings") ("normal") ("fancy") nil)))

;; /に色を付ける
(defun yatex-mistake (arg)
  "Fontlock serch function for tex"
  (search-forward "/" arg t))
(add-hook 'yatex-mode-hook
          '(lambda ()
             (font-lock-add-keywords
              major-mode
              (list '(yatex-mistake . my-face-b-2) ))))

;; yatex + imenu
;; @see: http://d.hatena.ne.jp/daimatz/20110122
(defun substring-count (sub string)
  (let ( (list (split-string string sub)))
    (- (length list) 1)))
(defun my-yatex-imenu-create-index ()
  (let (index)
    (goto-char (point-min))
    (let ( (chap-num 0)
          (sec-num 0)
          (ssec-num 0))
      (while (re-search-forward
              "\\\\\\(\\(sub\\)*\\)\\(chapter\\|section\\)\\(\\*?\\){\\(.+?\\)}$"
              (point-max) t)
        (let* ( (sub-str (match-string 1))
               (sec-chap (match-string 3))
               (aster-str (match-string 4))
               (sec-str (match-string 5))
               (sec-beg (match-beginning 5))
               (sub-cnt (if (string-match "chapter" sec-chap)
                            -1
                          (if (eq nil sub-str) 0
                               (substring-count "sub" sub-str))
                          ))
               (number-str
                (cond ( (string= "*" aster-str) "")
                      ( (= sub-cnt -1)
                       (progn (setq chap-num (+ chap-num 1))
                              (setq sec-num 0)
                              (setq ssec-num 0)
                              (setq sssec-num 0)
                              (format "%d " chap-num)))
                      ( (= sub-cnt 0)
                       (progn (setq sec-num (+ sec-num 1))
                              (setq ssec-num 0)
                              (setq sssec-num 0)
                              (format "%d.%d " chap-num sec-num)))
                      ( (= sub-cnt 1)
                       (progn (setq ssec-num (+ ssec-num 1))
                              (setq sssec-num 0)
                              (format "%d.%d.%d " chap-num sec-num ssec-num)))
                      ( (= sub-cnt 2)
                       (make-string (string-width (format "%d.%d.%d " chap-num sec-num ssec-num))
                                    (string-to-char " ")))
                      ))
               (pre-str (make-string (* 2 (+ sub-cnt 1)) (string-to-char " ")))
               (add-str (concat pre-str number-str sec-str)))
          (push (cons add-str sec-beg) index)))
      (nreverse index))))
(add-hook 'yatex-mode-hook
          (lambda ()
            (setq imenu-create-index-function 'my-yatex-imenu-create-index)))

;; (progn
;;   ;;yatex数式の文字の色の変更
;;   (make-face 'my-YaTeX-font-lock-formula-face)
;;   (set-face-foreground 'my-YaTeX-font-lock-formula-face "green4")  ;; 色の決定
;;   (set-face-bold-p 'my-YaTeX-font-lock-formula-face t)                 ;; 太字にする
;;   (setq YaTeX-font-lock-formula-face 'my-YaTeX-font-lock-formula-face)
;;   )

;; dviprint-command-format 変数の %s に，
;; ファイルの拡張子".dvi"がつかないように変更．
;; また，%s を複数使えるようにした．
(defadvice YaTeX-lpr (around my-YaTeX-lpr-around activate)
  "dviprint-command-fomat の %s を事前に置き換える"
  (let ((dviprint-command-format
         (replace-regexp-in-string
          "%s"
          (if (get 'dvi2-command 'region)
              (substring YaTeX-texput-file
                         0 (rindex YaTeX-texput-file ?.))
            (YaTeX-get-preview-file-name  ""))
          dviprint-command-format)))
    ad-do-it))

(provide 'yatex-patch)
;;; yatex-patch.el end here
