(load "bootstrap")

(ql:quickload 'slime)

(defvar *swank-port* 4005)

(swank:create-server :port *swank-port* :dont-close t)

(with-open-file (logfile "/var/log/sbcld.log" :direction :output :if-exists :append)
  (format logfile "~%Swank running on port ~a~%" *swank-port*))
