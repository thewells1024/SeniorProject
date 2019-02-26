#lang typed/racket

(provide Context Program Resources Val Val? inVal Exc inExc Fx Computation Request Result)

; transparent struct
(define-syntax tstruct
  (syntax-rules ()
    [(_ name fields)
     (struct name fields #:transparent)]))

(define-type Context (Immutable-HashTable Symbol Val))
(define-type Program Sexp)

(define-type Resources (Listof Any))

(define-type Val (U Integer Boolean))

(: Val? (-> Any Boolean))
(define Val? (make-predicate Val))

(: inVal (-> Val Val))
(define (inVal val)
  val)

(tstruct Exc ([val : Symbol]))

(: inExc (-> Symbol Fx))
(define (inExc val)
  (Fx inVal (Exc val)))

(tstruct Fx ([cont : (Val -> Computation)] [Request : Request]))
(define-type Computation (U Fx Val))
(define-type Request Exc)

(define-type Result (Pairof Val Resources))