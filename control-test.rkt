#lang typed/racket

(require typed/rackunit)
(require typed/racket/unit)

(require "common.rkt")
(require "control.rkt")
(require "signatures.rkt")
(require "test-utils.rkt")
(require "top.rkt")

; Any is required in the type signature so that way the type checker doesn't complain
(: control-test (Unit (import top^) (export) Any))
(define control-test
  (unit (import top^)
        (export)
        (check-equal? (admin-top (eval-top '(catch k 3) (hash)) (hash))
                      (cons 3 (hash)))
        (check-equal? (admin-top (eval-top '(catch k (throw k 3)) (hash)) (hash))
                      (cons 3 (hash)))))

(: control-test-prog (Unit (import) (export) Any))
(define control-test-prog
  (compound-unit (import)
                 (export)
                 (link [((B : language^)) test-base]
                       [((C : language^)) controlM B T]
                       [((T : top^)) top C]
                       [() control-test T])))

(invoke-unit control-test-prog)