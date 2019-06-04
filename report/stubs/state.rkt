(: stateM (Unit (import language^ top^)
                (export language^)))
(define stateM
  (unit (import
          (rename language^
                  (eval-prev eval-lang)
                  (admin-prev admin-lang)
                  (resources-prev resources))
                top^)
        (export language^)
        (define-type Store
                     (Immutable-HashTable Integer Val))
        (: Store? (-> Any Boolean))
        (define Store? (make-predicate Store))
        (: eval-lang (-> Program Context Computation))
        (define (eval-lang exp context)
          (match exp
            [(list 'box exp)
             (handler (eval-top exp context)
                      (lambda ([v : Val]) : Computation
                        (Fx inVal (Box v))))]
            [(list 'unbox exp)
             (handler (eval-top exp context)
                      (lambda ([v : Val]) : Computation
                        (match v
                          [(? Location? loc)
                           (Fx inVal
                               (Unbox (cast loc Location)))]
                          [_ (Fx inVal (Exc 'box-error))])))]
            [(list '<- exp1 exp2)
             (handler (eval-top exp1 context)
                      (lambda ([val : Val]) : Computation
                        (match val
                          [(? Location? loc)
                           (handler
                             (eval-top exp2 context)
                             (lambda ([val : Val]) : Computation
                               (Fx inVal
                                   (Rebox (cast loc Location)
                                          val))))]
                          [_ (inExc 'box-error)])))]
            [_ (eval-prev exp context)]))
        (: admin-lang (-> Computation Resources Result))
        (define (admin-lang comp resources)
          (match (hash-ref resources 'store)
            [(? Store? s)
             (let ([store (cast s Store)])
               (match comp
                 [(Fx cont (Box v))
                  (letrec ([loc (hash-count store)]
                           [new-resources
                            (hash-set resources
                                      'store
                                      (hash-set store loc v))])
                    (admin-top (cont (Location loc))
                               new-resources))]
                 [(Fx cont (Unbox ptr))
                  (match ptr
                    [(Location loc)
                     (admin-top
                       (cont
                         (hash-ref store
                                   loc
                                   (lambda () (error 'unallocated))))
                                resources)]
                    [_ (error 'unbox)])]
                 [(Fx cont (Rebox ptr val))
                  (match ptr
                    [(Location loc)
                     (let [(new-resources
                           (hash-set resources
                                     'store
                                     (hash-set store loc val)))]
                       (admin-top (cont ptr) new-resources))]
                    [_ (error 'rebox)])]
                 [_ (admin-prev comp resources)]))]
            [_ (error 'no-store)]))
        (: resources Resources)
        (define resources (add-resource resources-prev
                                        'store
                                        (cast (hash) Store)))))