;;; 01_elpa.el ---
;; @see: http://tromey.com/elpa/

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
