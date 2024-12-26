(defsystem "com.djhaskin.letn"
  :version "0.1.0"
  :author "Daniel Jay Haskin"
  :license "MIT"
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description "Library implementing tail-call recursive iterating construct `letn`")
