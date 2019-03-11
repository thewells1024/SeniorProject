#lang typed/racket

(provide Context extend-context ref-context Program Resources add-resource find-resource Val Lambda Val? inVal Exc inExc Fx Computation Request Result)

; transparent struct
(define-syntax tstruct
  (syntax-rules ()
    [(_ name fields)
     (struct name fields #:transparent)]))

(define-type Context (Immutable-HashTable Symbol Val))

(: extend-context (-> Context Symbol Val Context))
(define extend-context hash-set)

(: ref-context (-> Context Symbol Computation))
(define (ref-context context var)
  (hash-ref context var (λ () (inExc 'unknown-var))))

(define-type Program Sexp)

(define-type Resources (Immutable-HashTable Symbol Any))

(: add-resource (-> Resources Symbol Any Resources))
(define (add-resource resources name resource)
  (if (hash-has-key? resources name)
      (error "Name collision")
      (hash-set resources name resource)))

(define find-resource hash-ref)

(define-type Val (U Integer Boolean Lambda))
(tstruct Lambda ([cont : (-> Val Computation)]))

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