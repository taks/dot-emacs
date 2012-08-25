;;; 40_scheme.el

(add-hook 'scheme-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook 'rainbow-delimiters-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-complete
;; @see: https://github.com/sonelliot/sonelliot-dotemacs/blob/master/config/init-racket.el
(defun ac-racket-symbols ()
  "Retrieve completion candidates for the current `auto-complete' prefix"
  (geiser-completion--symbol-list ac-prefix))

(defvar ac-source-racket
  '((candidates . ac-racket-symbols))
  "Source of completion candidates for Racket")

(defun init-racket-setup-ac-sources ()
  "Setup the `auto-complete' sources"
  (add-to-list 'ac-sources 'ac-source-racket))

(defun init-racket-mode-hook ()
  "Apply customisations when Scheme mode is launched."
  (auto-complete-mode t)
  (init-racket-setup-ac-sources))

(add-hook 'scheme-mode-hook 'init-racket-mode-hook)
