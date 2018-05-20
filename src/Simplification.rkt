#lang typed/racket
(require "./Definition.rkt")
(require "./Affichage.rkt")


;; FONCTIONS DE SIMPLIFICATION

; transformation différence -> somme
(: diff-somme (expr -> expr))
(define (diff-somme expr1)
  (match expr1
    [(oper '- l) (oper '+ (cons (car l)
                                  (map 
                                   (lambda ([x : expr]) (match x
                                                          [(? number? y) (* -1 y)]
                                                          [else (oper '* (list -1 x))]))
                                   (map diff-somme (cdr l)))))]
    [(oper s l) (oper s (map diff-somme l))]
    [else expr1]))


; POLYNOMES

; CONCATENATIONS
(: conc_s_l* ((Listof expr) Symbol -> (Listof expr)))
(define (conc_s_l* l s)
  (if (null? l)
      '()
      (match (car l)
        [(oper s2 l2) (if (equal? s s2)
                          (append l2 (conc_s_l* (cdr l) s))
                          (cons (conc_s* (car l) s2) (conc_s_l* (cdr l) s)))]
        [else (cons (car l) (conc_s_l* (cdr l) s))])))
          
(: conc_s* (expr Symbol -> expr))
(define (conc_s* expr1 s)
  (match expr1
    [(oper s2 l2) (if (equal? s s2)
                      (oper s (conc_s_l* l2 s))
                      (oper s2 (map (lambda([x : expr]) (conc_s* x s)) l2)))]
    [else expr1]))


; DEVELOPPEMENT
(: somme-pdt ((Listof expr) (Listof (Listof expr)) Number -> (Listof expr)))
(define (somme-pdt fact1 fact2 n)
    (cond 
      [(null? fact2) (if (zero? n)
                         (list (oper '* fact1) 0)
                         fact1)]
      [else 
       (let ([fact_car (map (lambda ([x : expr]) (oper '* (cons x fact1))) (car fact2))])
         (somme-pdt fact_car (cdr fact2) n))]))
  

(: developpe_l ((Listof expr) (Listof expr) (Listof (Listof expr)) -> (Listof expr)))
(define (developpe_l l f1 f2)
  (let* ([fact1 f1]
         [fact2 f2])
    (cond
      [(null? l) (if (null? fact2)
                     (somme-pdt fact1 fact2 0)
                     (somme-pdt fact1 fact2 1))]
      [else (match (car l)
              [(oper '+ l2) (set! fact2 (cons l2 fact2))
                            (developpe_l (cdr l) fact1 fact2)]
              [else (set! fact1 (cons (car l) fact1))
                    (developpe_l (cdr l) fact1 fact2)])])))

(: developpe (expr -> expr))
(define (developpe expr)
  (match expr
    [(oper '* l) (oper '+ (developpe_l l '(1) '()))]
    [(oper s l) (oper s (map developpe l))]
    [else expr]))


; FACTORISATION
; supprime un entier d'une liste d'expressions
(: list_suppr ((Listof expr) Integer -> (Listof expr)))
(define (list_suppr l n)
  (cond
    [(null? l) '()]
    [else (match (car l)
            [(? number? x) (if (equal? x n)
                               (list_suppr (cdr l) n)
                               (cons (car l) (list_suppr (cdr l) n)))]
            [else (cons (car l) (list_suppr (cdr l) n))])]))

; supprime les neutres 1 et 0 pour le produit et la somme
(: fact_suppr (expr -> expr))
(define (fact_suppr expr)
  (match expr
    [(oper '* l) (oper '* (map fact_suppr (list_suppr l 1)))]
    [(oper '+ l) (oper '+ (map fact_suppr (list_suppr l 0)))]
    [(oper s l) (oper s (map fact_suppr l))]
    [else expr]))

; simplifie les produits par 0
(: fact_neutre (expr -> expr))
(define (fact_neutre expr)
  (match expr
    [(oper '* l1) (if (null? (filter zero? (filter number? l1)))
                      expr
                      0)]
    [(oper s2 l2) (oper s2 (map fact_neutre l2))]
    [else expr]))

; supprime les opérations + et * a un seul argument pour ne laisser que le résultat
(: parentheses_l ((Listof expr) -> (Listof expr)))
(define (parentheses_l l)
  (if (null? l)
      '()
      (match (car l)
        [(oper s1 l1) (if (and (or (eq? s1 '*) (eq? s1 '+)) (equal? (length l1) 1))
                          (cons (car l1) (parentheses_l (cdr l)))
                          (cons (car l) (parentheses_l (cdr l))))]
        [else (cons (car l) (parentheses_l (cdr l)))])))

(: parentheses (expr -> expr))
(define (parentheses expr)
  (match expr
    [(oper s l) (oper s (parentheses_l l))]
    [else expr]))

; affecte l'opération sur les nombres de la liste 
(: factorise_l ((Listof expr) (Number * -> Number) Number -> (Listof expr)))
(define (factorise_l l op neutre)
  (let* ([reste neutre])
    (if (null? l)
        (list reste)
        (match (car l)
          [(? number? n) (set! reste (op reste n))
                         (factorise_l (cdr l) op reste)]
          [(? is_oper?) (cons (factorise (car l)) (factorise_l (cdr l) op reste))]
          [else (cons (car l) (factorise_l (cdr l) op reste))]))))  

(: factorise (expr -> expr))
(define (factorise expr)
    (match expr
      [(oper '+ l)  (fact_neutre (oper '+ (parentheses_l (factorise_l l + 0))))]
      [(oper '* l)  (fact_neutre (oper '* (parentheses_l (factorise_l l * 1))))]
      [(oper s l)   (fact_neutre (oper s (parentheses_l l)))]
      [else expr]))



    

;; EXEMPLES

;(define test_conc_somme (oper '+ (list 3 'x (oper '* (list 6 'x (oper '+ (list 7 'x (oper '+ (list 8 'x)))))) 'x (oper '+ (list 4 5)))))
;(print_expr test_conc_somme)
;(print_expr (conc_somme* test_conc_somme))
;(print_expr (conc_s* test_conc_somme '+))
;(print_expr (factorise (conc_somme* (developpe (conc_somme* test_conc_somme)))))

;(define test_diff-somme (oper '- (list 1 (oper '- '(2 3)) 'x)))
;(print_expr test_diff-somme)
;(print_expr (diff-somme test_diff-somme))
;(print_expr (factorise (factorise (conc_somme* (developpe (diff-somme test_diff-somme))))))

;(define test_simp (oper '* (list 1 'x (oper '+ (list (oper '* (list 'x 1)) (oper '* (list 'x 1)) 0)))))
;(print_expr test_simp)
;(print_expr (factorise (developpe test_simp)))

;(define test_suppr (oper '* (list 'x (oper '+ (list 'x 1)) 0)))
;(print_expr test_suppr)
;(print_expr (factorise test_suppr))


;; PROVIDES
(provide factorise)
(provide parentheses)
(provide fact_neutre)
(provide fact_suppr)
(provide conc_s*)
(provide developpe)
(provide diff-somme)

