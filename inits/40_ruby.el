;;; 40_ruby.el

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ruby-mode
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("[Rr]akefile" . ruby-mode))

(add-hook 'ruby-mode-hook
          '(lambda ()
             (inf-ruby-keys)
             (local-set-key (kbd "RET") 'reindent-then-newline-and-indent)
             (local-unset-key (kbd "C-j"))))

;; (progn
;;   ;; ruby-electric
;;   (require 'ruby-electric)
;;   (add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))
;;   ;; 足りない関数を追加
;;   (defun ruby-insert-end ()
;;     ;; (interactive)
;;     (insert "end")
;;     (ruby-indent-line t)
;;     (end-of-line))
;;   )

;; rubydb
(autoload 'rubydb "rubydb3x"
  "run rubydb on program file in buffer *gud-file*.
the directory containing file becomes the initial working directory
and source-file directory for your debugger." t)

(progn
  ;; ruby-block
  (require 'ruby-block)
  (ruby-block-mode t)
  ;; ミニバッファに表示し, かつ, オーバレイする.
  (setq ruby-block-highlight-toggle t)
  )

(progn
  ;; flymake for ruby
  ;; @see: http://d.hatena.ne.jp/khiker/20070630/emacs_ruby_flymake
  (require 'flymake)
  ;; color
  (set-face-background 'flymake-errline "red4")
  (set-face-background 'flymake-warnline "dark slate blue")
  ;; Invoke ruby with '-c' to get syntax checking
  (defun flymake-ruby-init ()
    (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
           (local-file  (file-relative-name
                         temp-file
                         (file-name-directory buffer-file-name))))
      (list "ruby" (list "-c" local-file))))
  (push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
  (push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)
  (push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)
  )

(add-hook
 'ruby-mode-hook
 '(lambda ()
    ;; Don't want flymake mode for ruby regions in rhtml files
    (if (not (null buffer-file-name)) (flymake-mode))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rinari
;; @see: http://rinari.rubyforge.org/
(add-to-list 'load-path "~/.emacs.d/el-get/rinari-taks")
(add-to-list 'load-path "~/.emacs.d/el-get/rinari-taks/util")
(add-to-list 'load-path "~/.emacs.d/el-get/rinari-taks/util/jump")

;; Interactively Do Things (highly recommended, but not strictly required)
(require 'ido)
(ido-mode t)
(require 'rinari)

;; rhtml-mode
;; @see: http://rinari.rubyforge.org/rhtml_002dMode.html#rhtml_002dMode
(add-to-list 'load-path "~/.emacs.d/el-get/rhtml-mode")
(require 'rhtml-mode)
(add-to-list 'auto-mode-alist '("\\.erb$" . rhtml-mode))
(add-hook 'rhtml-mode-hook
          (lambda () (rinari-launch)))

(require 'anything-refe)
