(: handler (-> Computation (-> Val Computation) Computation))
(define (handler computation consumer)
    (match computation
    [(? Val? v) (consumer
                    (cast v Val))]
    [(Fx cont request) (Fx (lambda ([val : Val]) : Computation
                                (handler (cont val) consumer))
                           request)]))))