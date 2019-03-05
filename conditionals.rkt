#lang typed/racket

(require typed/racket/unit)

(require "common.rkt")
(require "signatures.rkt")

(provide conditionalsM)

(: conditionalsM (Unit (import language^ top^) (export language^)))
(define conditionalsM
  (unit (import (rename language^
                        (eval-prev eval-lang)
                        (admin-prev admin-lang)
                        (resources-prev resources))
                top^)
        (export language^)
        (: eval-lang (-> Program Context Computation))
        (define (eval-lang exp context)
          (match exp
            [(? boolean? b) (inVal b)]
            [(list 'zero? sub) (handler (eval-top sub context) zero?)]
            [(list 'if cond thn els) (handler (eval-top cond context)
                                              (resolve-if thn els context))]
            [_ (eval-prev exp context)]))
        (: zero? (-> Val Computation))
        (define (zero? val)
          (match val
            [0 true]
            [_ false]))
        (: resolve-if (-> Program Program Context (-> Val Computation)))
        (define (resolve-if thn els context)
          (λ ([val : Val]) : Computation
            (match val
              [#t (eval-top thn context)]
              [#f (eval-top els context)]
              [_ (inExc 'type-error)])))
        (define admin-lang admin-prev)
        (define resources resources-prev)))