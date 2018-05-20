#lang typed/racket
(require "./Definition.rkt")
(require "./Bibliotheque.rkt")
(require "./Fonctions.rkt")



;; FONCTIONS DE DERIVATION

; dérivée d'une somme
(: d_sum (expr * -> expr))
(define (d_sum . l)
   (oper '+ (list (derivee (car l)) (derivee (cadr l)))))

(dict-add dict '+ d_sum)

; dérivée d'un produit
(: d_product (expr * -> expr))
(define (d_product . l)
  (oper '+ (list (oper '* (list (derivee (car l)) (cadr l))) (oper '* (list (derivee (cadr l)) (car l))))))

(dict-add dict '* d_product)

; dérivée d'un quotient
(: d_quotient (expr * -> expr))
(define (d_quotient . l)
  (oper '+ (list (oper '* (list (derivee (car l)) (oper '^ (list (cadr l) -1)))) (oper '* (list -1 (derivee (cadr l)) (car l) (oper '^ (list (cadr l) -2)))))))
 
(dict-add dict '/ d_quotient)

; dérivée du log
(: d_log (expr * -> expr))
(define (d_log . l)
  (oper '/ (list (derivee (car l)) (car l))))

(dict-add dict 'log d_log)

; dérivée de exp
(: d_exp (expr * -> expr))
(define (d_exp . l)
  (oper '* (list (derivee (car l)) (oper 'exp (list (car l))))))

(dict-add dict 'exp d_exp)

; dérivée de cos
(: d_cos (expr * -> expr))
(define (d_cos . l) 
  (oper '* (list (derivee (car l)) (oper 'sin (list (car l))))))

(dict-add dict 'cos d_cos)

; dérivée de sin
(: d_sin (expr * -> expr))
(define (d_sin . l)
  (oper '* (list (derivee (car l)) (oper '* (list -1 (oper 'cos (list (car l))))))))

(dict-add dict 'sin d_sin)

; dérivée de tan
(: d_tan (expr * -> expr))
(define (d_tan . l)
  (oper '* (list (derivee (car l)) (oper '+ (list 1 (oper '^ (list (oper 'tan (list (car l))) 2)))))))

(dict-add dict 'tan d_tan)

; derivée d'une puissance, notee ^ avec en cadr l'exposant
; derive les puissance constantes de fonction u(x)^n (attention ne dérive pas u(x)^v(x))
(: d_pow (expr * -> expr))
(define (d_pow . l)
  (oper '* (list (cadr l)
                 (derivee (car l))
                 (oper '^ (list (car l) (match (cadr l)
                                          [(? number? nb) (sub1 nb) ]
                                          [else (oper '- (list (cadr l) 1))]))))))

(dict-add dict '^ d_pow)


;(dict-ls dict)