(: baseM (Unit (import) (export language^)))
(define baseM
  (unit (import)
        (export language^)
        (: eval-lang (-> Program Context Computation))
        (define (eval-lang exp context)
          (match exp
            [(list 'loop) (eval-lang exp context)]
            [(list 'err) (inExc 'error)]
            [_ (error "Can't interpret expression " exp)]))
        (: admin-lang (-> Computation Resources Result))
        (define (admin-lang comp res)
          (match comp
            [val (cast (cons val res) Result)]
            [(Fx _ (Exc s)) (error "Error signalled" s)]
            [_ (error "Unknown computation")]))
        (: resources Resources)
        (define resources (cast (hash) Resources))))