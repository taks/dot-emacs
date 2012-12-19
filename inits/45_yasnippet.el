;;; 45_yasnippet.el ---

;; YASnippet, anthing-c-yasnippet
(require 'yasnippet)
;; (require 'anything-c-yasnippet)
;; ;; スペース区切りで絞り込めるようにする デフォルトは nil
;; (setq anything-c-yas-space-match-any-greedy t)
;; ;; C-c yで起動
;; (global-set-key (kbd "C-c y") 'anything-c-yas-complete)

(add-to-list 'yas/root-directory "~/.emacs.d/snippets")
(if (listp yas/root-directory)
    (dolist (directory yas/root-directory)
      (yas/load-directory directory))
  (yas/load-directory yas/root-directory))

(require 'dropdown-list)
(setq yas/prompt-functions '(yas/dropdown-prompt
                             yas/ido-prompt
                             yas/completing-prompt))
