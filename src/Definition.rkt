#lang typed/racket


;; DEFINITION D'UNE EXPRESSION

(define-type expr (U Number Symbol oper))
(struct: oper ([s : Symbol] [l : (Listof expr)]))

(: is_oper? (expr -> Boolean))
(define (is_oper? expr)
  (oper? expr))

(define-predicate expr? expr)

;; CONSTANTES

(define e (exp 1))
(define Pi pi)
  
;; PROVIDES
(provide expr)
(provide oper)
(provide is_oper?)
(provide expr?)
