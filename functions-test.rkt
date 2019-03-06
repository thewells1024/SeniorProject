#lang typed/racket

(require typed/rackunit)
(require typed/racket/unit)

(require "common.rkt")
(require "functions.rkt")
(require "signatures.rkt")
(require "test-utils.rkt")
(require "top.rkt")

; Any is required in the type signature so that way the type checker doesn't complain
(: functions-test (Unit (import top^) (export) Any))
(define functions-test
  (unit (import top^)
        (export)
        (check-equal? (eval-top '(var x) (hash 'x 3)) 3)
        (check-equal? (eval-top '(app (λ x (var x)) 3) (hash)) 3)))

(: functions-test-prog (Unit (import) (export) Any))
(define functions-test-prog
  (compound-unit (import)
                 (export)
                 (link [((B : language^)) test-base]
                       [((C : language^)) functionsM B T]
                       [((T : top^)) top C]
                       [() functions-test T])))

(invoke-unit functions-test-prog)