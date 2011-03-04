;;---------------------- Vz 風　物理行単位でのカーソル移動 ---------------------
(defvar vz-goal-column nil)

;(defun vz-next-line ()
;  "Vz:↓"
;  (interactive)
;  (if truncate-lines
;      (next-line 1)
;    (or (eq last-command 'vz-next-line)
;        (setq vz-goal-column (% (current-column) (1- (window-width)))))
;    (if (eolp)
;        (progn
;          (forward-char 1)
;          (move-to-column vz-goal-column))
;      (vertical-motion 1)
;      (move-to-column (+ vz-goal-column (current-column))))))
;
;(defun vz-previous-line ()
;  "Vz:↑"
;  (interactive)
;  (if truncate-lines
;      (previous-line 1)
;    (or (eq last-command 'vz-next-line)
;        (setq vz-goal-column (% (current-column) (1- (window-width)))))
;    (let ((ncol (- vz-goal-column (window-width) -1)))
;      (vertical-motion -1)
;      (if (<= 0 ncol)
;          (move-to-column ncol)
;        (move-to-column (+ vz-goal-column (current-column))))))
;  (setq this-command 'vz-next-line))    ;fake

(defun vz-right-of-screen ()
  "Vz 画面の右端"
  (interactive)
  (vertical-motion 1)
  (if (not (eobp))
      (backward-char 1))
  (if (= (point) (point-max))
      (if (= (char-before) ?\n)
          (backward-char))))


(defun vz-left-of-screen ()
  "Vz 画面の左端"
  (interactive)
  (vertical-motion 0))

