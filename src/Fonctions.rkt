#lang typed/racket
(require "./Definition.rkt")
(require "./Affichage.rkt")
(require "./Bibliotheque.rkt")
(require "./Simplification.rkt")


;; FONCTIONS DE CALCUL

; simplification d'une expression
(: simplifie (expr -> expr))
(define (simplifie expr)
  (parentheses (fact_suppr (factorise (factorise (conc_s* (conc_s* (developpe (diff-somme expr)) '+) '*))))))

; calcul d'une dérivée par rapport à la variable 'x uniquement
(: derivee (expr -> expr))
(define (derivee expr)
  (match expr
    [(? number?) 0]
    [(? symbol? x) (if (equal? x 'x)
                       1
                       0)]
    [(oper s l) (apply (dict-read dict s) l)]))

; calcul d'une dérivée n-ième
(: deriv-n ((Listof Any) Integer -> (Listof Any)))
(define (deriv-n l n)
  (if (< n 1)
      l
      (deriv-n (trad_inv (simplifie (derivee (precond (trad l))))) (sub1 n))))

; affiche la dérivée n-ième en infixe
(: deriv-n_aff ((Listof Any) Integer -> Void))
(define (deriv-n_aff l n)
  (print_expr (simplifie (trad (deriv-n l n)))))

;; TRADUCTION
; traduit une fonction en langage scheme en une expression utilisable par notre implémentation
(: trad ((Listof Any) -> expr))
(define (trad l)
  (match (car l)
    [(? symbol? s) (if (equal? 'quote s)
                       (oper '+ (filter expr? (cons 0 (cdr l))))
                       (let ([pairs (filter (lambda(x) (list? x)) (cdr l))]
                             [npairs (filter (lambda(x) (not (list? x))) (cdr l))])
                         (oper s (filter expr? (append (map trad pairs) npairs)))))]
    [else (raise "votre expression est mal écrite")]))

; traduit une expression selon notre implémentation en une liste interprétable en langage scheme
(: trad_inv (expr -> (Listof Any)))
(define (trad_inv expr1)
  (match expr1 
    [(oper s l) (cons s 
                      (append 
                       (map trad_inv (filter (lambda ([x : expr]) (is_oper? x)) l)) 
                       (filter (lambda ([x : expr]) (not (is_oper? x))) l)))]
    [else (list expr1)]))



;; PRECONDITIONNEMENT
; organise les opérations de telle sorte qu'elles prennent 2 arguments ou moins
(: precond (expr -> expr))
(define (precond expr)
  (match expr 
    [(oper s l) (if (< 2 (length l))
                    (oper s (list (precond (car l)) (precond (oper s (cdr l)))))
                    expr)]
    [else expr]))



;; PROVIDES

(provide derivee)
(provide deriv-n)
(provide deriv-n_aff)
(provide compose)
(provide precond)
(provide trad)
(provide trad_inv)
(provide simplifie)