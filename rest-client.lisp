(ql:quickload '(drakma
								cl-json))

(defpackage :com.nmuth.rest-client (:use :cl :drakma :cl-json))

(defparameter *test-headers* nil)
(defparameter *test-body* nil)

(defclass response ()
	((body :initarg :body :accessor body)
	 (status :initarg :status :accessor status)
	 (resolved-from :initarg :from :accessor resolved-from)))

(defmethod print-object ((object response) stream)
	(print-unreadable-object (object stream :type t)
		(with-slots (body status) object
			(format stream "status: ~d, body: ~a" status body))))

(defun new-response (body status uri)
	(make-instance 'response
								 :body body
								 :status status
								 :from uri))

(defun request (url)
	(multiple-value-bind
				(raw-body status headers uri response-stream must-close)
			(drakma:http-request url :want-stream t)
		(let* ((content-type (cdr (assoc :content-type headers)))
					 (body (if (search "application/json" content-type)
										 (json:decode-json-strict response-stream)
										 raw-body))
					 (response (new-response body status uri)))
			(progn
				(when must-close
					(close response-stream))
				response))))
