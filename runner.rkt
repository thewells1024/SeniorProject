#lang typed/racket

(require typed/racket/unit)

(require "common.rkt")
(require "signatures.rkt")

(provide runner)

(: runner (Unit (import program^ interpreter^) (export) Result))
(define runner
  (unit (import program^ interpreter^)
        (export)
        (interp prog)))