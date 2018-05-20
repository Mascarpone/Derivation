#lang typed/racket
(require "Definition.rkt")



;; AFFICHAGE
 
(: print_expr_f (expr -> Void))
(define (print_expr_f expr) 
  (match expr
    [(oper s l) (begin 
                  (cond
                    [(or (eq? s '+) (eq? s '-) (eq? s '*) (eq? s '/)(eq? s '^))
                         (begin
                           (when (is_oper? (car l))
                             (display #\())
                           (print_expr_f (car l))  
                           (cond 
                             [(null? (cdr l)) (display #\))]
                             [else (begin 
                                     (display #\ )
                                     (display s)
                                     (display #\ )
                                     (print_expr_f (oper s (cdr l))))]))]
                    [else (begin
                            (display s)
                            (display #\ )
                            (when (is_oper? (car l))
                              (display #\())
                            (print_expr_f (car l))
                            (cond 
                             [(null? (cdr l)) (display #\))]
                             [else (begin
                                     (print_expr_f (oper s (cdr l)))
                                     (display #\)))]))]))]
    [else (display expr)]))

; affiche une expression en infixe
(: print_expr (expr -> Void))
(define (print_expr expr)
  (begin (display #\()
         (print_expr_f expr)
         (display #\newline)))
                

;; PROVIDE
(provide print_expr)
