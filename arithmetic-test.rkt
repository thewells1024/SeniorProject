#lang typed/racket

(require typed/rackunit)
(require typed/racket/unit)

(require "arithmetic.rkt")
(require "common.rkt")
(require "signatures.rkt")
(require "test-utils.rkt")
(require "top.rkt")

; Any is required in the type signature so that way the type checker doesn't complain
(: arithmetic-test (Unit (import top^) (export) Any))
(define arithmetic-test
  (unit (import top^)
        (export)
        (check-equal? (eval-top 4 (hash)) 4)
        (check-equal? (eval-top '(add1 4) (hash)) 5)
        (check-equal? (eval-top '(sub1 4) (hash)) 3)))

(: arithmetic-test-prog (Unit (import) (export) Any))
(define arithmetic-test-prog
  (compound-unit (import)
                 (export)
                 (link [((B : language^)) test-base]
                       [((A : language^)) arithmeticM B T]
                       [((T : top^)) top A]
                       [() arithmetic-test T])))

(invoke-unit arithmetic-test-prog)