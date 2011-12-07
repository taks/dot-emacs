;;; 40_yatex.el

(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(add-to-list 'auto-mode-alist '("\\.tex$" . yatex-mode))
(add-to-list 'auto-mode-alist '("\\.sty$" . yatex-mode))

(setq YaTeX-no-begend-shortcut t)  ;;C-c b だけで補完機能

;;;   1=Shift JIS
;;;   2=JIS
;;;   3=EUC
;;;   4=UTF-8
(setq YaTeX-kanji-code 3)

(setq tex-command "platex")
(setq dvi2-command "xdvi -geo +0+0 -s 4")
(setq dviprint-command-format "dvipdfmx %s && evince %s.pdf")
(setq makeindex-command "mendex -r -c -g -s dot.ist -p")

(eval-after-load
    "yatex"
  '(load  "yatex-patch"))
(add-hook 'yatex-mode-hook
          '(lambda ()
             (setq auto-fill-function nil)
             (reftex-mode 1)
             (define-key reftex-mode-map
               (concat YaTeX-prefix ">") 'YaTeX-comment-region)
             (define-key reftex-mode-map
               (concat YaTeX-prefix "<") 'YaTeX-uncomment-region)))


;;; yatex-mode + noweb-minor-mode
(defun Rnw-mode ()
  "Major mode for editing Sweave(R) source.
See `noweb-mode' and `R-mode' for more help."
  (interactive)
  (require 'ess-noweb)
  (noweb-mode 1)
  (noweb-set-doc-mode 'yatex-mode)
  (noweb-set-code-mode 'R-mode))
