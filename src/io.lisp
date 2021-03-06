;;; io.lisp

(in-package :cm)

(defun set-receiver! (hook stream &rest args)
  (let ((data (rt-stream-receive-data stream)))
    (if (and (not (null data)) (first data))
        (error "set-receiver!: ~s already receiving." stream)
        (let ((type (getf args ':receive-type)))
          (if type (setf (rt-stream-receive-type stream) type)
              (if (and (not (rt-stream-receive-type stream))
                       (not (equal (type-of stream) 'jackmidi:input-stream)))
                  (setf (rt-stream-receive-type stream)
                          *receive-type*)))
          (stream-receive-init stream hook args)
          (cond
           ((stream-receive-start stream args)
            (format t "~%; ~a receiving!" stream))
           (t (stream-receive-deinit stream)
            (error
             "set-receiver!: ~s does not support :receive-type ~s."
             stream (rt-stream-receive-type stream))))
          (values)))))
