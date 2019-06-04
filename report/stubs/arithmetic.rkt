(: arithmeticM (Unit (import language^ top^) (export language^)))
(define arithmeticM
  (unit (import (rename language^
                        (eval-prev eval-lang)
                        (admin-prev admin-lang)
                        (resources-prev resources))
                top^)
        (export language^)
        (: eval-lang (-> Program Context Computation))
        (define (eval-lang exp context)
          (match exp
            [(? exact-integer? v) (inVal v)]
            [(list 'add1 exp) (handler (eval-top exp context) add1)]
            [(list 'sub1 exp) (handler (eval-top exp context) sub1)]
            [exp (eval-prev exp context)]))
        (: add1 (-> Val Computation))
        (define (add1 num)
          (if (integer? num)
              (+ num 1)
              (inExc 'error)))
        (: sub1 (-> Val Computation))
        (define (sub1 num)
          (if (integer? num)
              (- num 1)
              (inExc 'error)))
        (define admin-lang admin-prev)
        (define resources resources-prev)))