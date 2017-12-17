#|
  This file is a part of r99 project.
|#

(defsystem "r99"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ("cl-dbi"
               "cl-who"
               "hunchentoot")
  :components ((:module "src"
                :components
                ((:file "r99"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "r99-test"))))
