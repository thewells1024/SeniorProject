#lang typed/racket

(require typed/racket/unit)

(require "common.rkt")
(require "interpreter.rkt")
(require "signatures.rkt")
(require "runner.rkt")
(require "top.rkt")

; language units
(require "base.rkt")
(require "arithmetic.rkt")

(: arithmetic-interpreter (Unit (import) (export interpreter^)))
(define arithmetic-interpreter
  (compound-unit (import)
                 (export I)
                 (link [((B : language^)) baseM]
                       [((A : language^)) arithmeticM B T]
                       [((T : top^)) top A]
                       [((I : interpreter^)) interpreter T])))

(: example-prog1 (Unit (import) (export program^)))
(define example-prog1
  (unit (import)
        (export program^)
        (: prog Program)
        (define prog '(add1 (sub1 (sub1 (sub1 4)))))))