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
(require "conditionals.rkt")
(require "functions.rkt")

(: arithmetic-interpreter (Unit (import) (export interpreter^)))
(define arithmetic-interpreter
  (compound-unit (import)
                 (export I)
                 (link [((B : language^)) baseM]
                       [((A : language^)) arithmeticM B T]
                       [((C : language^)) conditionalsM A T]
                       [((F : language^)) functionsM C T]
                       [((T : top^)) top F]
                       [((I : interpreter^)) interpreter T])))

(: example-prog1 (Unit (import) (export program^)))
(define example-prog1
  (unit (import)
        (export program^)
        (: prog Program)
        (define prog '(add1 (sub1 (sub1 (sub1 4)))))))

; uncomment the following line to run example-prog1
#;(invoke-unit (compound-unit (import)
                              (export)
                              (link [((I : interpreter^)) arithmetic-interpreter]
                                    [((P : program^)) example-prog1]
                                    [() runner I P])))

(: example-prog2 (Unit (import) (export program^)))
(define example-prog2
  (unit (import)
        (export program^)
        (: prog Program)
        (define prog '(if (zero? 7)
                          (err)
                          (add1 (sub1 (sub1 4)))))))

; uncomment the following line to run example-prog2
#;(invoke-unit (compound-unit (import)
                              (export)
                              (link [((I : interpreter^)) arithmetic-interpreter]
                                    [((P : program^)) example-prog2]
                                    [() runner I P])))

(: example-prog3 (Unit (import) (export program^)))
(define example-prog3
  (unit (import)
        (export program^)
        (: prog Program)
        (define prog '(app (λ z (app (app (λ x
                                            (λ y
                                              (if (zero? (var z))
                                                  (app (var x) (var z))
                                                  (app (var y) (var z)))))
                                          (λ v (add1 (var v))))
                                     (λ w (sub1 (var w))))) 11))))

; uncomment the following line to run example-prog3
#;(invoke-unit (compound-unit (import)
                              (export)
                              (link [((I : interpreter^)) arithmetic-interpreter]
                                    [((P : program^)) example-prog3]
                                    [() runner I P])))