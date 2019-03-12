#lang typed/racket

(require typed/rackunit)
(require typed/racket/unit)

(require "common.rkt")
(require "state.rkt")
(require "signatures.rkt")
(require "test-utils.rkt")
(require "top.rkt")

; Any is required in the type signature so that way the type checker doesn't complain
(: state-test (Unit (import top^) (export) Any))
(define state-test
  (unit (import top^)
        (export)
        (check-equal? (admin-top (eval-top
                                  '(box 3)
                                  (cast (hash) Context))
                                 resources-top) (cons (Location 0) (hash 'store (hash 0 3))))))

(: state-test-prog (Unit (import) (export) Any))
(define state-test-prog
  (compound-unit (import)
                 (export)
                 (link [((B : language^)) test-base]
                       [((C : language^)) stateM B T]
                       [((T : top^)) top C]
                       [() state-test T])))

(invoke-unit state-test-prog)