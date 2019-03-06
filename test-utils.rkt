#lang typed/racket

(require typed/racket/unit)

(require "common.rkt")
(require "signatures.rkt")

(provide test-base)

(: test-base (Unit (import) (export language^)))
(define test-base
  (unit (import)
        (export language^)
        (: eval-lang (-> Program Context Computation))
        (define (eval-lang exp context)
          (match exp
            ; This won't fail, the type-checker just deosn't know that Val? enforces a Val
            [(? Val? val) (cast val Val)]
            [_ (error "Bad Program")]))
        (: admin-lang (-> Computation Resources (Pairof Val Resources)))
        (define (admin-lang comp resources)
          (error "Bad Admin"))
        (define resources (cast '() Resources))))