(:name cl-test-more :type http
       :url "https://raw.github.com/netpyoung/emacs-config/master/cl-test-more/cl-test-more.el"
       :after (lambda ()
                (add-hook 'slime-load-hook (lambda () (require 'cl-test-more)))))
