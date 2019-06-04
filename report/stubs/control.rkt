(: controlM (Unit (import language^ top^)
                  (export language^)))
(define controlM
  (unit (import
          (rename language^
                  (eval-prev eval-lang)
                  (admin-prev admin-lang)
                  (resources-prev resources))
                top^)
        (export language^)
        (: eval-lang (-> Program Context Computation))
        (define (eval-lang exp context)
          (match exp
            [(list 'catch (? symbol? s) e)
             (Fx inVal
                 (Continuation (lambda ([v : Val]) : Computation
                   (match v
                     [(Continuation k)
                      (handler 
                        (eval-top e
                                  (extend-context context s v))
                                  k)]
                     [_ (inExc 'not-continuation)]))))]
            [(list 'throw (? symbol? s) e)
             (handler (eval-top e context)
                      (lambda ([v : Val]) : Computation
                        (match (ref-context context s)
                          [(Continuation cont)
                           (Fx inVal
                               (Continuation (lambda (kp) (cont v))))]
                          [_ (inExc 'not-continuation)])))]
            [_ (eval-prev exp context)]))
        (: admin-lang (-> Computation Resources Result))
        (define (admin-lang comp resources)
          (match comp
            [(Fx kont (Continuation cont))
             (admin-top (cont (Continuation kont)) resources)]
            [_ (admin-prev comp resources)]))
        (: resources Resources)
        (define resources resources-prev)))