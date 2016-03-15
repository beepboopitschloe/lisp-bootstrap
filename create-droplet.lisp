(load "rest-client")

(defpackage :com.nmuth.create-droplet
	(:use :cl :rest)
	(:nicknames :create-droplet))

(in-package :create-droplet)

(defvar *api-token* "INSERT_DO_API_TOKEN")
(defvar *url-base* "https://api.digitalocean.com/v2")

(defun path (&rest args)
	(loop for arg in args
				with result = *url-base*
				do (let ((arg-str (if (stringp arg) arg (write-to-string arg))))
						 (setf result (concatenate 'string result "/" arg-str)))
				finally (return result)))

(defun auth-header ()
	(let ((header-value (concatenate 'string "BEARER " *api-token*)))
		(cons "Authorization" header-value)))

(defun get-droplets ()
	(let ((url (path "droplets")))
		(rest:get-json url :headers (list (auth-header)))))

(defun create-droplet (name)
	(let* ((url (path "droplets"))
				 (region "nyc2")
				 (size "512mb")
				 (image "ubuntu-14-04-x64")
				 (body (pairlis '(:region
													:size
													:image
													:name)
												(list region
															size
															image
															name))))
		(rest:post-json url body :headers (list (auth-header)))))
