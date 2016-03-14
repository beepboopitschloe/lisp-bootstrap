(ql:quickload '(drakma
                cl-json))

(defpackage :com.nmuth.rest-client
	(:use :cl :drakma :cl-json))

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

(defun rest/get (url)
  (rest/request url '()))

(defun rest/post (url post-body)
  (let ((post-body-json (json:encode-json post-body)))
    (rest/request url (list
											 :method :post
											 :content post-body-json))))

(defun rest/put (url put-body)
  (let ((put-body-json (json:encode-json put-body)))
    (rest/request url (list
											 :method :put
											 :content put-body-json))))

(defun rest/delete (url delete-body)
  (let ((delete-body-json (json:encode-json delete-body)))
    (rest/request url (list
											 :method :delete
											 :content delete-body-json))))
