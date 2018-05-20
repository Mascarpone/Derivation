#lang typed/racket

(require "../src/Definition.rkt")

(require "../src/Fonctions.rkt")
(require "../src/Simplification.rkt")
(require "../src/Affichage.rkt")

(require "../src/Bibliotheque.rkt")
(require "../src/Derivation.rkt")

;; Tests Fonctions
(display "\n**Tests de Fonctions.rkt**\n")

(display "\nTest de simplifie (1/4):\n")
(display "Original:\n(3 + x + (6 * x * (7 + x + (8 + x))) + x + (4 + 5)\n")
(display "simplifie:\n")
(define test_conc_somme (oper '+ (list 3 'x (oper '* (list 6 'x (oper '+ (list 7 'x (oper '+ (list 8 'x)))))) 'x (oper '+ (list 4 5)))))
(print_expr (simplifie test_conc_somme))
(display "Attendu:\n(12 * x * x + 92 * x + 12)\n")
(display "Test de simplifie (2/4):\n")
(display "Original:\n(1 - (2 - 3) - x)\n")
(display "simplifie:\n")
(define test_diff-somme (oper '- (list 1 (oper '- '(2 3)) 'x)))
(print_expr (simplifie test_diff-somme))
(display "Attendu:\n(-x + 2)\n")
(display "Test de simplifie (3/4):\n")
(display "Original:\n(1 * x * ((x * 1) + (x * 1) + 0))\n")
(display "simplifie:\n")
(define test_simp (oper '* (list 1 'x (oper '+ (list (oper '* (list 'x 1)) (oper '* (list 'x 1)) 0)))))
(print_expr (simplifie test_simp))
(display "Attendu:\n(2 * x * x)\n")
(display "Test de simplifie (4/4):\n")
(display "Original:\n(x * (x + 1) * 0)\n")
(display "simplifie:\n")
(define test_suppr (oper '* (list 'x (oper '+ (list 'x 1)) 0)))
(print_expr (factorise test_suppr))
(display "Attendu:\n0\n")

(display "\nTest de precond\n")
(display "Original:\n(2 + 3 + 4 + 6 + 7)\n")
(display "precond:\n")
(print_expr (precond (oper '+ (list 2 3 4 6 7))))
