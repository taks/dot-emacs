;;; key-context-menu.el ---

(defun key-context-menu (event)
  "Pop up a contextual menu."
  (interactive "e")

  (let ((editable (not buffer-read-only))
        (pt (save-excursion (mouse-set-point last-nonmenu-event)))
        beg end
        )

    ;; getting word boundaries
    (if (and mark-active
             (<= (region-beginning) pt) (<= pt (region-end)) )
        (setq beg (region-beginning)
              end (region-end))
      (save-excursion
        (goto-char pt)
        (setq end (progn (forward-word) (point)))
        (setq beg (progn (backward-word) (point)))
        ))

    ;; popup menu
    (popup-menu
     '(nil
;       ["Search in Spotlight"
;        (mac-spotlight-search (buffer-substring-no-properties beg end))
;        :active (fboundp 'mac-spotlight-search)
;        :help "Do a Spotlight search of word at cursor"]
       ["Search in Google"
        (browse-url
         (concat "http://www.google.com/search?q="
                 (url-hexify-string (buffer-substring-no-properties beg end))))
        :help "Ask a WWW browser to do a Google search"]
       ["Search in alc"
        (browse-url
         (concat "http://eow.alc.co.jp/"
                 (url-hexify-string (buffer-substring-no-properties beg end))
                 "/UTF-8/"))
        :help "Ask a WWW browser to do a alc"]
       ["--" nil]
;     ["Look Up in Dictionary"
;      (browse-url
;       (concat "dict:///"
;               (url-hexify-string (buffer-substring-no-properties beg end))))
;      :active t
;      :help "Look up word at cursor in Dictionary.app"]
;     ["--" nil]
       ["Cut"   (clipboard-kill-region beg end) :active (and editable mark-active)
        :help "Delete text in region and copy it to the clipboard"]
       ["Copy"  (clipboard-kill-ring-save beg end) :active mark-active
        :help "Copy text in region to the clipboard"]
       ["Paste" (clipboard-yank) :active editable
        :help "Paste text from clipboard"]
;     ["--" nil]
;     ("Spelling"
;      ["Spelling..."
;       (progn (goto-char end)(ispell-word)) :active editable
;       :help "Spell-check word at cursor"]
;      ["Check Spelling" (ispell-buffer) :active editable
;       :help "Check spelling of the current buffer"]
;      ["Check Spelling as You Type"
;       (flyspell-mode)
;       :style toggle :selected flyspell-mode :active editable
;       :help "Check spelling while you edit the text"]
;     )
;     ("Font"
;      ["Show Fonts" (ignore) :active nil]
;      ["Bold"       (ignore) :active nil]
;      ["Italic"     (ignore) :active nil]
;      ["Underline"  (ignore) :active nil]
;      ["Outline"    (ignore) :active nil]
;      ["Styles..."  (ignore) :active nil]
;      ["--" nil]
;      ["Show Colors" (ignore) :active nil]
;     )
;     ("Speech"
;      ["Start Speaking"
;       (if (and mark-active
;                (<= (region-beginning) pt) (<= pt (region-end)) )
;           (mac-key-speak-region beg end)
;         (mac-key-speak-buffer) )
;       :help "Speak text through the sound output"]
;      ["Stop Speaking" (mac-key-stop-speaking)
;       :active (and mac-key-speech-process
;                    (eq (process-status mac-key-speech-process) 'run))
;       :help "Stop speaking"]
;     )
;     ["--" nil]
;     ["Buffers" mouse-buffer-menu
;       :help "Pop up a menu of buffers for selection with the mouse"]
       ))))

;;; key-context-menu.el ends here
