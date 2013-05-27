;;; 40_verilog.el

(add-hook 'verilog-mode-hook
          '(lambda ()
             (local-unset-key (kbd ";"))
             (local-unset-key (kbd "C-;"))
             (flymake-mode t)))

(setq verilog-compiler "verilator")
(setq verilog-linter "verilator --lint-only")


(defun flymake-verilog-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "verilator" (list "--lint-only" local-file))))
(add-to-list 'flymake-allowed-file-name-masks
             '(".+\\.v$" flymake-verilog-init))
(add-to-list 'flymake-err-line-patterns
             '("^%Error: \\([^:]+\\):\\([0-9]+\\):\\(.*\\)$" 1 2 nil 3))
(defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
  (setq flymake-check-was-interrupted t))
(ad-activate 'flymake-post-syntax-check)
