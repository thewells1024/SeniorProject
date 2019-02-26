#lang typed/racket

(require typed/rackunit)
(require typed/racket/unit)

(require "base.rkt")
(require "common.rkt")
(require "signatures.rkt")

; Any is required in the type signature so that way the type checker doesn't complain
(: base-test (Unit (import language^) (export) Any))
(define base-test
  (unit (import language^)
        (export)
        (check-equal? (admin-lang 7 resources) (cons 7 resources))
        (check-equal? (eval-lang '(err) (hash)) (Fx inVal (Exc 'error)))
        (check-exn (regexp "Can't interpret expression .+")
                   (λ () (eval-lang '(foo) (hash))))))

; Any is required in the type signature so that way the type checker doesn't complain
(: base-test-prog (Unit (import) (export) Any))
(define base-test-prog
  (compound-unit (import)
                 (export)
                 (link [((B : language^)) baseM]
                       [() base-test B])))

(invoke-unit base-test-prog)