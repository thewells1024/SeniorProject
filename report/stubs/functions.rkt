(: functionsM (Unit
                (import language^ top^)
                (export language^)))
(define functionsM
  (unit (import (rename language^
                        (eval-prev eval-lang)
                        (admin-prev admin-lang)
                        (resources-prev resources))
                top^)
        (export language^)
        (: eval-lang (-> Program Context Computation))
        (define (eval-lang exp context)
          (match exp
            [(list 'var (? symbol? v))
             (ref-context context v)]
            [(list 'lambda (? symbol? x) y)
             (Lambda (lambda ([v : Val]) : Computation
                       (eval-top y (extend-context context
                                                   x
                                                   v))))]
            [(list 'app f a)
             (handler (eval-top f context)
                      (lambda ([val : Val]) : Computation
                        (match val
                          [(Lambda lam)
                           (handler (eval-top a context) lam)]
                          [_ (inExc 'call-error)])))]
            [_ (eval-prev exp context)]))
        (define admin-lang admin-prev)
        (define resources resources-prev)))