;;; 45_moccur.el ---
;; moccur 関連の設定

;; 複数の検索語や、特定のフェイスのみマッチ等の機能を有効にする
;; 詳細は http://www.bookshelf.jp/soft/meadow_50.html#SEC751
(setq moccur-split-word t)
;; ;; migemoがrequireできる環境ならmigemoを使う
;; (when (require 'migemo nil t) ;第三引数がnon-nilだとloadできなかった場合にエラーではなくnilを返す
;;   (setq moccur-use-migemo t))

;; moccur-grep-find で 無視するファイル
(add-to-list 'dmoccur-exclusion-mask "\\.bzr/.+")

(progn
  ;; キーバインドの変更
  (defun my-moccur-mode-edit-set-key ()
    (define-key moccur-mode-map (kbd "C-k") nil)
    )
  (if moccur-mode-map
      (my-moccur-mode-edit-set-key))
  (defadvice moccur-mode (after moccur-edit-set-key activate)
    (my-moccur-mode-edit-set-key))
  (defadvice moccur-grep-mode (after moccur-edit-set-key activate)
    (my-moccur-mode-edit-set-key))
  )
;; ;; anything-c-moccur
;; ;; (auto-install-from-url "http://svn.coderepos.org/share/lang/elisp/anything-c-moccur/trunk/anything-c-moccur.el")
;;   ;;; anything-c-moccurの設定
;; (require 'anything-c-moccur)
;; ;; カスタマイズ可能変数の設定(M-x customize-group anything-c-moccur でも設定可能)
;; (setq anything-c-moccur-anything-idle-delay 0.2 ;`anything-idle-delay'
;;       anything-c-moccur-higligt-info-line-flag t ; `anything-c-moccur-dmoccur'などのコマンドでバッファの情報をハイライトする
;;       anything-c-moccur-enable-auto-look-flag t ; 現在選択中の候補の位置を他のwindowに表示する
;;       anything-c-moccur-enable-initial-pattern t) ; `anything-c-moccur-occur-by-moccur'の起動時にポイントの位置の単語を初期パターンにする
;; ;; キーバインド
;; ;; (global-set-key (kbd "M-o") 'anything-c-moccur-occur-by-moccur) ;バッファ内検索
;; ;; (global-set-key (kbd "C-M-o") 'anything-c-moccur-dmoccur) ;ディレクトリ
;; ;; (add-hook 'dired-mode-hook
;; ;;           '(lambda () (local-set-key (kbd "O") 'anything-c-moccur-dired-do-moccur-by-moccur)))
