;;; 40_scheme.el

(add-hook 'scheme-mode-hook 'rainbow-delimiters-mode)

;; scheme-complete.el を auto-complete.el で使う
;; @see: http://d.hatena.ne.jp/kobapan/20091205/1259972925
;; @see: http://synthcode.com/emacs/
(progn
  (defvar ac-source-scheme
    '((candidates
       . (lambda ()
           (require 'scheme-complete)
           (all-completions ac-target (car (scheme-current-env))))))
    "Source for scheme keywords.")
  (add-hook 'scheme-mode-hook
            '(lambda ()
               (make-local-variable 'ac-sources)
               (setq ac-sources (append ac-sources '(ac-source-scheme)))))
  )
