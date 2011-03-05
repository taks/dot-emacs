;;; 01_elpa.el ---
;; @see: http://tromey.com/elpa/

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when (not (load (expand-file-name "~/.emacs.d/elpa/package.el") t))
  (error "Please bootstrap elpa using the instructions here: http://tromey.com/elpa/install.html, then restart Emacs"))

(package-initialize)
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/")
                         ("gnu"  . "http://elpa.gnu.org/packages/")
                         ("SC"   . "http://joseito.republika.pl/sunrise-commander/")))
