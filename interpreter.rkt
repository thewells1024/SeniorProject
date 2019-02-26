#lang typed/racket

(require typed/racket/unit)

(require "common.rkt")
(require "signatures.rkt")

(provide interpreter)

(: interpreter (Unit (import top^) (export interpreter^)))
(define interpreter
  (unit (import top^)
        (export interpreter^)
        (: interp (-> Program Result))
        (define (interp prog)
          (admin-top (eval-top prog (hash)) resources-top))))