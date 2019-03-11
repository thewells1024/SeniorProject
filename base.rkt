#lang typed/racket

(require typed/racket/unit)

(require "common.rkt")
(require "signatures.rkt")

(provide baseM)

(: baseM (Unit (import) (export language^)))
(define baseM
  (unit (import)
        (export language^)
        (: eval-lang (-> Program Context Computation))
        (define (eval-lang exp context)
          (match exp
            [(list 'loop) (eval-lang exp context)]
            [(list 'err) (inExc 'error)]
            [_ (error "Can't interpret expression " exp)]))
        (: admin-lang (-> Computation Resources Result))
        (define (admin-lang comp res)
          (match comp
            ; this cast won't fail, the type checker just doesn't like seeing a cons
            ; as a pair if the second half is a List
            [val (cast (cons val res) Result)]
            [(Fx _ (Exc s)) (error "Error signalled" s)]
            [_ (error "Unknown computation")]))
        (: resources Resources)
        ; This cast won't fail, the type checker just doesn't like thinking of '() as a list
        (define resources (cast (hash) Resources))))