;;; 40_org.el

(require 'org-install)
(require 'org-remember)
(setq org-startup-truncated nil)
(setq org-return-follows-link t)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(org-remember-insinuate)
(setq org-directory "~/memo/")
(setq org-default-notes-file (concat org-directory "agenda.org"))
(setq org-remember-templates
      '(("Todo" ?t "** TODO %?\n   %i\n   %a\n   %t" nil "Inbox")
        ("Bug" ?b "** TODO %?   :bug:\n   %i\n   %a\n   %t" nil "Inbox")
        ("Idea" ?i "** %?\n   %i\n   %a\n   %t" nil "New Ideas")
        ))

;; @see: http://julien.danjou.info/blog/2011.html#Code_fontification_with_Gnus_and_Org-mode
(setq org-src-fontify-natively t)

(add-hook 'org-mode-hook
          '(lambda ()
             (local-unset-key (kbd "C-k"))
             (local-unset-key (kbd "C-j"))))

;;; plantuml
(org-babel-do-load-languages
 'org-babel-load-languages
 '((plantuml . t)))
(setq org-plantuml-jar-path
      (expand-file-name "~/local/plantuml/plantuml.jar"))


;; "latex" ではなく tex-command変数 を使うために関数を上書き
;; ( org.elの 12750行 で宣言されていた )
;; This function borrows from Ganesh Swami's latex2png.el
(eval-after-load "org"
  '(defun org-create-formula-image (string tofile options buffer)
     (let* ((tmpdir (if (featurep 'xemacs)
                        (temp-directory)
                      temporary-file-directory))
            (texfilebase (make-temp-name
                          (expand-file-name "orgtex" tmpdir)))
            (texfile (concat texfilebase ".tex"))
            (dvifile (concat texfilebase ".dvi"))
            (pngfile (concat texfilebase ".png"))
            (fnh (if (featurep 'xemacs)
                     (font-height (get-face-font 'default))
                   (face-attribute 'default :height nil)))
            (scale (or (plist-get options (if buffer :scale :html-scale)) 1.0))
            (dpi (number-to-string (* scale (floor (* 0.9 (if buffer fnh 140.))))))
            (fg (or (plist-get options (if buffer :foreground :html-foreground))
                    "Black"))
            (bg (or (plist-get options (if buffer :background :html-background))
                    "Transparent")))
       (if (eq fg 'default) (setq fg (org-dvipng-color :foreground)))
       (if (eq bg 'default) (setq bg (org-dvipng-color :background)))
       (with-temp-file texfile
         (insert org-format-latex-header
                 "\n\\begin{document}\n" string "\n\\end{document}\n"))
       (let ((dir default-directory))
         (condition-case nil
             (progn
               (cd tmpdir)
               ;; (call-process "latex" nil nil nil texfile))
               (call-process tex-command nil nil nil texfile)) ; <- ここを書き換えた
           (error nil))
         (cd dir))
       (if (not (file-exists-p dvifile))
           (progn (message "Failed to create dvi file from %s" texfile) nil)
         (condition-case nil
             (call-process "dvipng" nil nil nil
                           "-E" "-fg" fg "-bg" bg
                           "-D" dpi
                           ;;"-x" scale "-y" scale
                           "-T" "tight"
                           "-o" pngfile
                           dvifile)
           (error nil))
         (if (not (file-exists-p pngfile))
             (progn (message "Failed to create png file from %s" texfile) nil)
           ;; Use the requested file name and clean up
           (copy-file pngfile tofile 'replace)
           (loop for e in '(".dvi" ".tex" ".aux" ".log" ".png") do
                 (delete-file (concat texfilebase e)))
           pngfile)))))
