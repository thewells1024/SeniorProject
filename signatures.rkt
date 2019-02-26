#lang typed/racket

(provide language^ top^ interpreter^ program^)

(require "common.rkt")

(define-signature language^
  ([eval-lang : (-> Program Context Computation)]
   [admin-lang : (-> Computation Resources Result)]
   [resources : Resources]))

(define-signature top^
  ([eval-top : (-> Program Context Computation)]
   [admin-top : (-> Computation Resources Result)]
   [resources-top : Resources]
   [handler : (-> Computation (-> Val Computation) Computation)]))

(define-signature interpreter^
  ([interp : (-> Program Result)]))

(define-signature program^
  ([prog : Program]))