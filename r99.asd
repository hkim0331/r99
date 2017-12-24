#|
  This file is a part of r99 project.
|#

(defsystem "r99"
:version "0.5.4"
  :author "Hiroshi Kimura"
  :license ""
  :depends-on ("cl-dbi"
               "cl-who"
               "cl-fad"
               "cl-ppcre"
               "hunchentoot")
  :components ((:module "src"
                :components
                ((:file "r99"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.md"))
  :in-order-to ((test-op (test-op "r99-test"))))
