;;; rake-command.el ---
;; 参考: http://d.hatena.ne.jp/takkkun/20101012/1286885329

(defvar rake:output-buffer "*rake output*")

(defun rake:invoke ()
  (interactive)
  (let ((task-suggestions (rake:task-suggestions)))
    (if task-suggestions
      (rake:run (completing-read "rake " task-suggestions))
      (message "Not found target"))))

(defmacro rake:deftask (task)
  (list 'defun (prog1 (intern (concat "rake:run-" task))) '()
        '(interactive)
        (list 'rake:run task)))

(defmacro rake:task (task)
  (list 'lambda '()
        '(interactive)
        (list 'rake:run task)))

(defun rake:task-suggestions ()
  (reverse (reduce #'(lambda (suggestions line)
                       (if (string-match "rake \\([^ ]+\\)" line)
                           (cons (match-string 1 line) suggestions)
                         suggestions))
                   (split-string (shell-command-to-string "rake -T") "[\r\n]+")
                   :initial-value nil)))

(defun rake:run (task)
  (call-process-shell-command (format "rake %s" task) nil rake:output-buffer))

(provide 'rake-command)
;;; rake-command.el ends here
