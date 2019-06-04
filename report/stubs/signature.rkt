(define-signature language^
  ([eval-lang : (-> Program Context Computation)]
   [admin-lang : (-> Computation Resources Result)]
   [resources : Resources]))

(define-signature top^
  ([eval-top : (-> Program Context Computation)]
   [admin-top : (-> Computation Resources Result)]
   [resources-top : Resources]
   [handler : (-> Computation (-> Val Computation) Computation)]))