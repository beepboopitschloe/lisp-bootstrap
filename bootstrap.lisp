;; load quicklisp if not already installed
(unless (fboundp 'ql:quickload)
  (progn
    (load "vendor/quicklisp")
    (quicklisp-quickstart:install)
    (ql:add-to-init-file)))
