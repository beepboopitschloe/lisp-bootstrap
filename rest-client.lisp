(ql:quickload '(drakma
								cl-json))

(defpackage :com.nmuth.rest-client
	(:use :cl :drakma :cl-json)
	(:nicknames :rest)
	(:export :get-json :post-json :put-json :delete-json))

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

(defun lisp->json (data)
	"Convert a Lisp structure to json."
	(let ((json-stream (make-string-output-stream)))
		(progn
			(json:encode-json data json-stream)
			(get-output-stream-string json-stream))))

(defun rest/request (url drakma-args)
	(let ((drakma-arg-list (concatenate 'list (list url :want-stream t) drakma-args)))
		(multiple-value-bind (raw-body status headers uri response-stream must-close)
				(apply #'drakma:http-request drakma-arg-list)
			(let* ((content-type (cdr (assoc :content-type headers)))
						 (body (if (search "application/json" content-type)
											 (json:decode-json-strict response-stream)
											 raw-body))
						 (response (new-response body status uri)))
				(progn
					(when must-close
						(close response-stream))
					response)))))

(defun get-json (url &key headers)
	(rest/request url (list :additional-headers headers)))

(defun post-json (url post-body &key headers)
	(let ((post-body-json (lisp->json post-body)))
		(rest/request url (list
											 :method :post
											 :content post-body-json
											 :content-type "application/json"
											 :additional-headers headers))))

(defun put-json (url put-body &key headers)
	(let ((put-body-json (lisp->json put-body)))
		(rest/request url (list
											 :method :put
											 :content put-body-json
											 :content-type "application/json"
											 :additional-headers headers))))

(defun delete-json (url delete-body &key headers)
	(let ((delete-body-json (lisp->json delete-body)))
		(rest/request url (list
											 :method :delete
											 :content delete-body-json
											 :content-type "application/json"
											 :additional-headers headers))))
