;;; anything-refe.el
;; @see: http://d.hatena.ne.jp/kitokitoki/20101105/p1

(defvar anything-c-source-refe
      `((name . "refe")
        (candidates-file . "~/.emacs.d/data/rubyrefm/bitclust/refe.index")
        (action ("Show" . anything-refe-action))))

(defun anything-refe-action (word)
  (let ((buf-name (concat "*refe:" word "*")))
    (with-current-buffer (get-buffer-create buf-name)
      (call-process "refe" nil t t word)
      (goto-char (point-min))
      (my-view-buffer-other-window buf-name t
                                (lambda (dummy)
                                  (kill-buffer-and-window))))))

(defun anything-refe ()
  (interactive)
  (anything anything-c-source-refe))

;; view-buffer-other-window の switch-to-buffer-other-window を switch-to-buffer にしたもの. letf でもよい.
(defun my-view-buffer-other-window (buffer &optional not-return exit-action)
  (let* ((win				; This window will be selected by
	  (get-lru-window))		; switch-to-buffer-other-window below.
	 (return-to
	  (and (not not-return)
	       (cons (selected-window)
		     (if (eq win (selected-window))
			 t			; Has to make new window.
		       (list
			(window-buffer win)	; Other windows old buffer.
			(window-start win)
			(window-point win)))))))
    (switch-to-buffer buffer) ;変更
    (view-mode-enter (and return-to (cons (selected-window) return-to))
		     exit-action)))

(add-hook 'ruby-mode-hook
  (lambda()
    (define-key ruby-mode-map [f1] 'anything-refe)))

(provide 'anything-refe)
;;; anything-refe.el ends here
