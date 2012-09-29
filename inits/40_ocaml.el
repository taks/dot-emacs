;;; 40_ocaml.el

(add-to-list 'load-path "~/ocamlbrew/ocaml-4.00.0/share/emacs/site-lisp")

(autoload 'utop "utop" "Toplevel for OCaml" t)
(autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
(add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)

(setq utop-edit-command nil)

;;; auto-complet
(setq utop-completion-output nil)
(setq utop-complete-prefix nil)
(setq utop-complete-command nil)

;; overwrite
(defun utop2 ()
  "A universal toplevel for OCaml.

url: https://forge.ocamlcore.org/projects/utop/

utop is a enhanced toplevel for OCaml with many features,
including context sensitive completion.

This is the emacs frontend for utop. You can use the utop buffer
as a standard OCaml toplevel.

To complete an identifier, simply press TAB.

Special keys for utop:
\\{utop-mode-map}"
  (interactive)
  (let ((buf (get-buffer utop-buffer-name)))
    (cond
     (buf
      ;; Restart utop if it exited
      (when (eq utop-state 'done) (utop-restart)))
     (t
      ;; The buffer does not exist, read the command line before
      ;; creating it so if the user quit it won't be created
      (utop-query-arguments)
      ;; Create the buffer
      (setq buf (get-buffer-create utop-buffer-name))
      ;; Put it in utop mode
      (with-current-buffer buf (utop-mode))))
  buf))
(defun utop-process-line2 (line)
  "Process one line from the utop sub-process."
  ;; Extract the command and its argument
  (string-match "\\`\\([a-z-]*\\):\\(.*\\)\\'" line)
    (let ((command (match-string 1 line)) (argument (match-string 2 line)))
      (setq utop-complete-command command)
      (cond
       ;; Output on stdout
       ((string= command "stdout")
        (utop-insert-output argument 'utop-stdout))
       ;; Output on stderr
       ((string= command "stderr")
        (utop-insert-output argument 'utop-stderr))
       ;; Synchronisation of the phrase terminator
       ((string= command "phrase-terminator")
        (setq utop-phrase-terminator argument))
       ;; A new prompt
       ((string= command "prompt")
        (let ((prompt (apply utop-prompt ())))
          ;; Insert the new prompt
          (utop-insert-prompt prompt)
          ;; Increment the command number
          (setq utop-command-number (+ utop-command-number 1))
          ;; Send the initial command if any
          (when utop-initial-command
            (goto-char (point-max))
            (insert utop-initial-command)
            (setq utop-initial-command nil)
            (utop-eval-input nil t nil))))
       ;; Input has been accepted
       ((string= command "accept")
        ;; Add a newline character at the end of the buffer
        (goto-char (point-max))
        (insert "\n")
        ;; Make input frozen
        (add-text-properties utop-prompt-max (point-max) '(face utop-frozen))
        ;; Highlight errors
        (let ((offsets (split-string argument "," t)))
          (while offsets
            (let ((a (string-to-number (car offsets)))
                  (b (string-to-number (car (cdr offsets)))))
              (add-text-properties (+ utop-prompt-max a) (+ utop-prompt-max b) '(face utop-error))
              (setq offsets (cdr (cdr offsets))))))
        ;; Make everything read-only
        (add-text-properties (point-min) (point-max) utop-non-editable-properties)
        ;; Advance the prompt
        (setq utop-prompt-min (point-max))
        (setq utop-prompt-max (point-max)))
       ;; Continue editiong
       ((string= command "continue")
        ;; Add a newline character at the position where the user
        ;; pressed enter
        (when utop-pending-position
          (goto-char (+ utop-prompt-max utop-pending-position))
          (insert "\n"))
        ;; Reset the state
        (utop-set-state 'edit))
       ;; Part of a history entry
       ((string= command "history-data")
        (cond
         (utop-pending-entry
          (setq utop-pending-entry (concat utop-pending-entry "\n" argument)))
         (t
          (setq utop-pending-entry argument))))
       ;; End of history data
       ((string= command "history-end")
        (progn
          (cond
           ((eq utop-state 'copy)
            (kill-new utop-pending-entry))
           (t
            (goto-char utop-prompt-max)
            ;; Delete current input
            (delete-region utop-prompt-max (point-max))
            ;; Insert entry
            (insert utop-pending-entry)))
          ;; Resume edition
          (utop-set-state 'edit)))
       ;; We are at a bound of history
       ((string= command "history-bound")
        ;; Just resume edition
        (utop-set-state 'edit))
       ;; Complete with a word
       ((string= command "completion-word")
        (utop-set-state 'edit)
        (setq utop-completion-output (list (concat utop-complete-prefix argument)))
        ;; (with-current-buffer utop-complete-buffer (insert argument))
        ;; Hide completion
        (minibuffer-hide-completions))
       ;; Start of completion
       ((string= command "completion-start")
        (setq utop-completion nil))
       ;; A new possible completion
       ((string= command "completion")
        (push argument utop-completion))
       ;; End of completion
       ((string= command "completion-stop")
        (utop-set-state 'edit)
        (setq utop-completion-output
              (mapcar (function (lambda (x) (concat (replace-regexp-in-string "\[^\.]+$" ""  utop-complete-prefix) x)))
                      (nreverse utop-completion)))
        ;; (with-current-buffer utop-complete-buffer
        ;;   (with-output-to-temp-buffer "*Completions*"
        ;;     (display-completion-list (nreverse utop-completion))))
        (setq utop-completion nil)))))
(eval-after-load "utop"
  '(progn
     (defun utop ()
       (utop2))
     (defun utop-process-line (line)
       (utop-process-line2 line))))

(defun ac-utop-symbols ()
  ""
  (setf utop-complete-prefix ac-prefix)
  (utop-edit-complete)
  utop-completion-output)

(defvar ac-source-utop
  '((candidates . ac-utop-symbols))
  "Source of completion candidates for ocaml")

(defun init-utop-setup-ac-sources ()
  "Setup the `auto-complete' sources"
  (add-to-list 'ac-sources 'ac-source-utop))

(defun init-tuareg-mode-hook-for-ac ()
  "Apply customisations when  mode is launched."
  (require 'utop)
  (utop2)
  (auto-complete-mode t)
  (init-utop-setup-ac-sources))

(add-hook 'tuareg-mode-hook 'init-tuareg-mode-hook-for-ac)
