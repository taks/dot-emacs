;;; 10_face.el ---
;; 見た目に関する設定

(transient-mark-mode t)  ; 選択されたリージョンを色付きにしてわかりやすくする設定
(setq show-paren-style 'mixed) ; 対応する括弧が外にある時は全体を色付きに

;; EOF を分かり易くする
;; @see: http://d.hatena.ne.jp/khiker/20100114/emacs_eof
(setq-default indicate-empty-lines t)
(set-face-foreground 'fringe "white")

;;色の設定
(color-theme-calm-forest)

;; タブ, 全角スペース、改行直前の半角スペースを表示する
;; 参考: http://openlab.dino.co.jp/2008/08/29/230500336.html
(when (require 'jaspace nil t)
  (when (boundp 'jaspace-modes)
    (setq jaspace-modes (append jaspace-modes
                                (list 'yatex-mode
                                      'php-mode
                                      'yaml-mode
                                      'javascript-mode
                                      'ruby-mode
                                      'text-mode
                                      'fundamental-mode))))
  (when (boundp 'jaspace-alternate-jaspace-string)
    (setq jaspace-alternate-jaspace-string "□"))
  (when (boundp 'jaspace-highlight-tabs)
    (setq jaspace-highlight-tabs ?^))
  (add-hook 'jaspace-mode-off-hook
            (lambda()
              (when (boundp 'show-trailing-whitespace)
                (setq show-trailing-whitespace nil))))
  (add-hook 'jaspace-mode-hook
            (lambda()
              (progn
                (when (boundp 'show-trailing-whitespace)
                  (setq show-trailing-whitespace t))
                (face-spec-set 'jaspace-highlight-jaspace-face
                               '((((class color) (background light))
                                  (:foreground "blue"))
                                 (t (:foreground "red"))))
                (face-spec-set 'jaspace-highlight-tab-face
                               '((((class color) (background light))
                                  (:foreground "red"
                                   :background "unspecified"
                                   :strike-through nil
                                   :underline t))
                                 (t (:foreground "purple"
                                     :background "unspecified"
                                     :strike-through nil
                                     :underline t))))
                (face-spec-set 'trailing-whitespace
                               '((((class color) (background light))
                                  (:foreground "red"
                                   :background "unspecified"
                                   :strike-through nil
                                   :underline t))
                                 (t (:foreground "purple"
                                     :background "unspecified"
                                     :strike-through nil
                                     :underline t))))))))

(when window-system
    (if linux-p (add-to-list 'default-frame-alist '(alpha . 90))) ; 透明化
    ;; フォントの設定
    (add-to-list 'default-frame-alist '(font . "Ricty for Powerline-16.5")))
