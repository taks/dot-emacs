;;
;; AUCTeX
;;
(setq TeX-default-mode 'japanese-latex-mode)
(setq japanese-LaTeX-default-style "jsarticle")
(setq TeX-engine-alist
      '((xelatex "XeLaTeX" "xetex" "xelatex" "xelatex")))
(setq TeX-engine 'xelatex)
(setq japanese-LaTeX-command-default "latexmk -xelatex")

(setq preview-image-type 'dvipng)

;; 上付き，下付きの無効化
(setq font-latex-fontify-script nil)

;; synctex
(setq TeX-source-correlate-method 'synctex)
(setq TeX-source-correlate-start-server t)
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
(defun Okular-make-url () (concat
                           "file://"
                           (expand-file-name (funcall file (TeX-output-extension) t)
                                             (file-name-directory (TeX-master-file)))
                           "#src:"
                           (TeX-current-line)
                           (expand-file-name (TeX-master-directory))
                           "./"
                           (TeX-current-file-name-master-relative)))
(add-hook 'LaTeX-mode-hook '(lambda ()
                              (add-to-list 'TeX-expand-list
                                           '("%u" Okular-make-url))))
(setq TeX-view-program-list
      '(("Okular" "okular --unique %u")))
(setq TeX-view-program-selection
      '((output-pdf "Okular")
        (output-dvi "Okular")))

(add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook (function (lambda ()
  (local-unset-key "\n")
  (add-to-list 'TeX-command-list
               '("xelatex" "xelatex %S %t"
                 TeX-run-TeX nil (latex-mode) :help "Run ASCII pLaTeX"))
  (add-to-list 'TeX-command-list
               '("xelatexmk" "latexmk -e '$pdflatex=q/xelatex %S/' -xelatex %t"
                 TeX-run-TeX nil (latex-mode) :help "Run ASCII pLaTeX"))

  ;; change preview background
  (defun preview-get-colors ()
    "Return colors from the current display.
Fetches the current screen colors and makes a vector
of colors as numbers in the range 0..65535.
Pure borderless black-on-white will return triple NIL.
The fourth value is the transparent border thickness."
    (let
        ((bg (color-values (preview-inherited-face-attribute
                            'preview-reference-face :background 'default)))
         (fg (color-values (preview-inherited-face-attribute
                            'preview-reference-face :foreground 'default)))
         (mask (preview-get-heuristic-mask)))
      ;; (if (equal '(65535 65535 65535) bg)
      ;; (setq bg nil))
      (setq bg nil)     ;;;  <- change here
      (if (equal '(0 0 0) fg)
          (setq fg nil))
      (unless (and (numberp preview-transparent-border)
                   (consp mask) (integerp (car mask)))
        (setq mask nil))
      (vector bg fg mask preview-transparent-border))))))

;;; ac-math
(require 'ac-math)
(add-to-list 'ac-modes 'latex-mode)
(defun ac-latex-mode-setup ()
  (setq ac-sources
        (append '(ac-source-math-unicode
                  ac-source-math-latex
                  ac-source-latex-commands)
                ac-sources)))
(add-hook 'latex-mode-hook 'ac-latex-mode-setup)
