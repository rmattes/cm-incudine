;;; **********************************************************************
;;; Copyright (C) 2009 Heinrich Taube, <taube (at) uiuc (dot) edu>
;;;
;;; This program is free software; you can redistribute it and/or
;;; modify it under the terms of the Lisp Lesser Gnu Public License.
;;; See http://www.cliki.net/LLGPL for the text of this agreement.
;;; **********************************************************************

;;; generated by scheme->cltl from plt.scm on 19-Mar-2009 14:43:22

(in-package :cm)

(progn
 (defclass gnuplot-file (event-file)
           ((objects :initform '() :accessor gnuplot-file-objects))
           #+metaclasses  (:metaclass io-class))
 (defparameter <gnuplot-file> (find-class 'gnuplot-file))
 (finalize-class <gnuplot-file>)
 (setf (io-class-file-types <gnuplot-file>) '("*.plt"))
 (values))

(defmethod open-io ((io gnuplot-file) dir &rest args) dir args
           (setf (gnuplot-file-objects io) (list)) io)

(defmethod close-io ((io gnuplot-file) &rest mode)
           (if (not (eq mode ':force))
               (let ((data (gnuplot-file-objects io))
                     (path nil)
                     (comm nil))
                 (if (not (null data))
                     (progn
                      (bump-version io)
                      (setf path (file-output-filename io))
                      (setf comm
                              (format nil "# ~a output on ~a~%"
                                      (cm-version) (date-and-time)))
                      (apply #'gnuplot path :comment comm
                             (append (event-stream-args io)
                                     (list (nreverse data))))
                      io)))))

(defmethod write-event ((obj event) (io gnuplot-file) time)
           (setf (object-time obj) time)
           (setf (gnuplot-file-objects io)
                   (cons obj (gnuplot-file-objects io))))
