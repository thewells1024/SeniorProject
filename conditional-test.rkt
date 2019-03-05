#lang typed/racket

(require typed/rackunit)
(require typed/racket/unit)

(require "common.rkt")
(require "conditionals.rkt")
(require "signatures.rkt")
(require "test-utils.rkt")
(require "top.rkt")

; Any is required in the type signature so that way the type checker doesn't complain
(: conditional-test (Unit (import top^) (export) Any))
(define conditional-test
  (unit (import top^)
        (export)
        (check-equal? (eval-top #t (hash)) #t)
        (check-equal? (eval-top '(if #t #t (err)) (hash)) #t)
        (check-equal? (eval-top '(if #f (err) #t) (hash)) #t)))

(: conditional-test-prog (Unit (import) (export) Any))
(define conditional-test-prog
  (compound-unit (import)
                 (export)
                 (link [((B : language^)) test-base]
                       [((C : language^)) conditionalsM B T]
                       [((T : top^)) top C]
                       [() conditional-test T])))

(invoke-unit conditional-test-prog)