#|
  This file is a part of r99 project.
|#

(defsystem "r99-test"
  :defsystem-depends-on ("prove-asdf")
  :author ""
  :license ""
  :depends-on ("r99"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "r99"))))
  :description "Test system for r99"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
