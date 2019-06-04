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
(require "state.rkt")
(require "control.rkt")

(: control-interpreter (Unit (import) (export interpreter^)))
(define control-interpreter
  (compound-unit (import)
                 (export I)
                 (link [((B : language^)) baseM]
                       [((A : language^)) arithmeticM B T]
                       [((C : language^)) conditionalsM A T]
                       [((F : language^)) functionsM C T]
                       [((S : language^)) stateM F T]
                       [((Ctrl : language^)) controlM S T]
                       [((T : top^)) top Ctrl]
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
                              (link [((I : interpreter^)) control-interpreter]
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
                              (link [((I : interpreter^)) control-interpreter]
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
                              (link [((I : interpreter^)) control-interpreter]
                                    [((P : program^)) example-prog3]
                                    [() runner I P])))

(: example-prog4 (Unit (import) (export program^)))
(define example-prog4
  (unit (import)
        (export program^)
        (: prog Program)
        (define prog '(app (λ add1-boxed (unbox (app (var add1-boxed)
                                                     (box 3))))
                           (λ b (<- (var b)
                                    (add1 (unbox (var b)))))))))

; uncomment the following line to run example-prog4
#;(invoke-unit (compound-unit (import)
                              (export)
                              (link [((I : interpreter^)) control-interpreter]
                                    [((P : program^)) example-prog4]
                                    [() runner I P])))

(: example-prog5 (Unit (import) (export program^)))
(define example-prog5
  (unit (import)
        (export program^)
        (: prog Program)
        (define prog '(app (λ x (catch exc (add1 (if (zero? (var x))
                                                     (throw exc (sub1 (var x)))
                                                     (sub1 (var x)))))) 0))))

; uncomment the following line to run example-prog5
(invoke-unit (compound-unit (import)
                              (export)
                              (link [((I : interpreter^)) control-interpreter]
                                    [((P : program^)) example-prog5]
                                    [() runner I P])))

(: control-interpreter-1 (Unit (import) (export interpreter^)))
(define control-interpreter-1
  (compound-unit (import)
                 (export I)
                 (link [((B : language^)) baseM]
                       [((C : language^)) conditionalsM B T]
                       [((A : language^)) arithmeticM C T]
                       [((F : language^)) functionsM A T]
                       [((S : language^)) stateM F T]
                       [((Ctrl : language^)) controlM S T]
                       [((T : top^)) top Ctrl]
                       [((I : interpreter^)) interpreter T])))

(invoke-unit (compound-unit (import)
                              (export)
                              (link [((I : interpreter^)) control-interpreter-1]
                                    [((P : program^)) example-prog5]
                                    [() runner I P])))

(: control-interpreter-2 (Unit (import) (export interpreter^)))
(define control-interpreter-2
  (compound-unit (import)
                 (export I)
                 (link [((B : language^)) baseM]
                       [((F : language^)) functionsM B T]
                       [((C : language^)) conditionalsM F T]
                       [((A : language^)) arithmeticM C T]
                       [((S : language^)) stateM A T]
                       [((Ctrl : language^)) controlM S T]
                       [((T : top^)) top Ctrl]
                       [((I : interpreter^)) interpreter T])))

(invoke-unit (compound-unit (import)
                              (export)
                              (link [((I : interpreter^)) control-interpreter-2]
                                    [((P : program^)) example-prog5]
                                    [() runner I P])))

(: control-interpreter-3 (Unit (import) (export interpreter^)))
(define control-interpreter-3
  (compound-unit (import)
                 (export I)
                 (link [((B : language^)) baseM]
                       [((S : language^)) stateM B T]
                       [((F : language^)) functionsM S T]
                       [((C : language^)) conditionalsM F T]
                       [((A : language^)) arithmeticM C T]
                       [((Ctrl : language^)) controlM A T]
                       [((T : top^)) top Ctrl]
                       [((I : interpreter^)) interpreter T])))

(invoke-unit (compound-unit (import)
                              (export)
                              (link [((I : interpreter^)) control-interpreter-3]
                                    [((P : program^)) example-prog5]
                                    [() runner I P])))

(: control-interpreter-4 (Unit (import) (export interpreter^)))
(define control-interpreter-4
  (compound-unit (import)
                 (export I)
                 (link [((B : language^)) baseM]
                       [((Ctrl : language^)) controlM B T]
                       [((S : language^)) stateM Ctrl T]
                       [((F : language^)) functionsM S T]
                       [((C : language^)) conditionalsM F T]
                       [((A : language^)) arithmeticM C T]
                       [((T : top^)) top A]
                       [((I : interpreter^)) interpreter T])))

(invoke-unit (compound-unit (import)
                              (export)
                              (link [((I : interpreter^)) control-interpreter-4]
                                    [((P : program^)) example-prog5]
                                    [() runner I P])))