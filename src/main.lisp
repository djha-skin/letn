;;;; main.lisp -- Tail-call-recursive named lets for Common Lisp. Inspired by
;;;;              Clojure's Loop/Recur.
;;;;
;;;; SPDX-FileCopyrightText: 2024 Daniel Jay Haskin
;;;; SPDX-License-Identifier: MIT
;;;;
;;;;

(in-package #:cl-user)

(defpackage
  #:com.djhaskin.letn (:use #:cl)
  (:documentation
    "
    A loop/recur implementation.
    ")
  (:export #:letn)
  )

(in-package #:com.djhaskin.letn)

(defmacro letn (name bindings &body body)
  (let* ((looptag (gensym (format nil "LETN-~A-LOOPTAG-" (string name))))
         (loopresult (gensym (format nil "LETN-~A-LOOPRESULT-" (string name))))
         (binding-map (loop for (n initial) in bindings
                        collect
                        (list n
                              (gensym (format nil "LETN-~A-OUTER-~A-" (string name) (string n)))
                              (gensym (format nil "LETN-~A-MACRO-~A-" (string name) (string n)))
                              initial))))
    `(let ,(loop for (n o m i) in binding-map
                 collect (list o i))
       (block ,name
              (macrolet ((,name ,(loop for (n o m i) in binding-map
                                       collect m)
                           (list 'progn
                             ,(loop with result = '()
                                   for (n o m i) in binding-map
                                   do
                                   (push (list 'quote o) result)
                                   (push m result)
                                   finally
                                   (return
                                     (cons (quote list)
                                       (cons
                                       (quote 'psetf) (reverse result)))))
                             (list 'go (quote ,looptag)))))
               (let ((,loopresult nil))
                 (tagbody ,looptag
                          (setf ,loopresult
                                (let ,(loop for (n o m i) in binding-map
                                            collect
                                            (list n o))
                                  ,@body)))
                 ,loopresult))))))

#+(or)
(letn farforshire ((a `((,(+ 1 2) ,(+ 3 4)) (,(+ 5 6) ,(+ 7 8) ) (,(+ 9 10) nil)))
                   (s 0))
      (if (null a)
          s
          (let ((thisone
                  (letn stinkystinks ((x (first a))
                                      (s 0))
                (if (null x)
                    s
                    (let ((mine (first x)))
                      (when (null mine)
                          (return-from farforshire "what even"))
                    (stinkystinks (rest x) (+ s (first x))))))))
            (farforshire (rest a) (+ s thisone)))))
