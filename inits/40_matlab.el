;;; 40_matlab.el

;; 参考: http://redgecko.jp/d/?date=20070328
(autoload 'matlab-mode "matlab" "Enter MATLAB mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
;; (setq matlab-indent-level 4)
(setq matlab-indent-function-body nil)

;; 参考: http://d.hatena.ne.jp/uhiaha888/20100815/1281888552
(add-hook 'matlab-mode-hook 'hideshowvis-enable)
(add-to-list 'hs-special-modes-alist
             '(matlab-mode
               "if\\|switch\\|case\\|otherwise\\|while\\|for\\|try\\|catch" "end"
               nil (lambda (arg) (matlab-forward-sexp)) nil))
(add-hook 'matlab-mode-hook
          '(lambda ()
             (local-unset-key (kbd "C-j"))
             (local-unset-key (kbd "C-h"))))
