;;; 40_sql.el
;; @see: http://www.sixnine.net/roadside/sqlmode.html

;; (auto-install-from-emacswiki "sql-indent.el")
;; (auto-install-from-emacswiki "sql-complete.el")
;; (auto-install-from-emacswiki "sql-transform.el")

;; SQL mode に入った時点で sql-indent / sql-complete を読み込む
(eval-after-load "sql"
  '(progn
     (load-library "sql-indent")
     (load-library "sql-complete")
     (load-library "sql-transform")
     ))

;; SQL モードの雑多な設定
(add-hook 'sql-mode-hook
    (function (lambda ()
                (setq sql-indent-offset 4)
                (setq sql-indent-maybe-tab t)
                (local-set-key "\C-cu" 'sql-to-update) ; sql-transform
                ;; SQLi の自動ポップアップ
                (setq sql-pop-to-buffer-after-send-region t)
                )))
(add-hook 'sql-interactive-mode-hook
          #'(lambda ()
              (setq show-trailing-whitespace nil)
              (setq comint-input-autoexpand t)
              (setq comint-output-filter-functions
                    'comint-truncate-buffer)
              (define-key sql-interactive-mode-map (kbd "C-j") nil)))
