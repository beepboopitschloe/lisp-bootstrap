(defun quicklisp-dir ()
	(let ((ql-dirname (make-pathname :directory '(:relative "quicklisp"))))
		(merge-pathnames ql-dirname (user-homedir-pathname))))

(defun quicklisp-setup-file ()
	(let* ((setup-filename (make-pathname :name "setup" :type "lisp"))
				 (setup-file (merge-pathnames setup-filename (quicklisp-dir))))
		(namestring setup-file)))

(defun quicklisp-installed ()
	"Determine if Quicklisp is installed."
	(directory (quicklisp-dir)))

(defun string->function (str)
	"Get the function with the given name."
	(symbol-function (find-symbol (string-upcase str))))

(if (not (quicklisp-installed))
		(progn
      (if (find-package :quicklisp-quickstart)
          (quicklisp-quickstart:install)
          (error "package quicklisp-quickstart not available"))))

(if (and (quicklisp-installed) (not (find-package :ql)))
		;; quicklisp is installed but not loaded, need to load it
		(load (quicklisp-setup-file)))
