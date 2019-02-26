#lang typed/racket

(require typed/racket/unit)

(require "common.rkt")
(require "signatures.rkt")

(provide top)

(: top (Unit (import language^) (export top^)))
(define top
  (unit (import language^)
        (export top^)
        (define eval-top eval-lang)
        (define admin-top admin-lang)
        (define resources-top resources)
        (: handler (-> Computation (-> Val Computation) Computation))
        (define (handler computation consumer)
          (match computation
            [(? Val? v) (consumer
                         ; This cast won't fail, the typechecker is just weird
                         (cast v Val))]
            [(Fx cont request) (Fx (λ ([val : Val]) : Computation
                                     (handler (cont val) consumer)) request)]))))