;;; 40_scheme.el

(add-to-list 'load-path "~/.emacs.d/elisp/gauche-mode")

;; @see: http://www.neilvandyke.org/quack/
;; (auto-install-from-url "http://www.neilvandyke.org/quack/quack.el")
(setq quack-default-program "gosh -i")
(require 'quack)
(set-face-foreground 'quack-pltish-defn-face "DodgerBlue")
(set-face-foreground 'quack-pltish-selfeval-face
                     (face-foreground 'font-lock-string-face))
(set-face-foreground 'quack-pltish-comment-face
                     (face-foreground 'font-lock-comment-face))


;; gauche-mode
;; @see: http://d.hatena.ne.jp/leque/20071024/1193233407
;; @see: http://www.katch.ne.jp/~leque/software/repos/gauche-mode/
(autoload 'gauche-mode "gauche-mode" "Major mode for editing gauche code." t)
(add-to-list 'auto-mode-alist '("\\.scm$" . gauche-mode))

;; @see: http://d.hatena.ne.jp/higepon/20071111/1194759225
(add-to-list 'process-coding-system-alist '("gosh" utf-8 . utf-8))
(defvar scheme-program-name "gosh -i")
(autoload 'run-scheme "cmuscheme" "Run an inferior Scheme process." t)

(progn
  ;; Gauche の info を anything で引く
  ;; @see: http://valvallow.blogspot.com/2010/09/gauche-info-anything.html
  (defvar anything-c-source-info-gauche-refj
    '((info-index . "gauche-refj.info")))
  (defun anything-info-ja-at-point ()
    "Preconfigured `anything' for searching info at point."
    (interactive)
    (anything '(anything-c-source-info-gauche-refj)
              (thing-at-point 'symbol) nil nil nil "*anything info*"))
  (add-hook 'gauche-mode-hook
            '(lambda ()
               (local-set-key (kbd "C-M-;") 'anything-info-ja-at-point)
               (local-set-key (kbd "(")
                              '(lambda () (interactive) (insert "()") (backward-char)))))
  )

;; inferior-gauche
;; @see: http://homepage3.nifty.com/oatu/emacs/ig.html
(autoload 'inferior-gauche-mode "inferior-gauche" "Major mode for editing gauche code." t)

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
;; eldoc-mode を scheme でも使う
;; @see: http://www29.atwiki.jp/sicpstudygroup/pages/45.html
(add-hook 'scheme-mode-hook
          (lambda ()
            (require 'scheme-complete)
            (setq default-scheme-implementation 'gauche)
            (setq *current-scheme-implementation* 'gauche)
            (set (make-local-variable 'eldoc-documentation-function)
                 'scheme-get-current-symbol-info)
            (eldoc-mode t)
            ))
