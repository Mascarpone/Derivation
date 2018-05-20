#lang typed/racket


(require "../src/Definition.rkt")

(require "../src/Fonctions.rkt")
(require "../src/Simplification.rkt")
(require "../src/Affichage.rkt")

(require "../src/Bibliotheque.rkt")
(require "../src/Derivation.rkt")


;; Tests Affichage
(display "\n**Tests de Affichage.rkt**\n")

(display "\nTest de print_expr (1/3): oper seul\n")
(display "Print_expr:\n")
(print_expr (oper '* '(3 x x)))
(display "Attendu:\n(3 * x * x)\n")

(display "Test de print_expr (2/3): oper imbriqués\n")
(display "Print_expr:\n")
(print_expr (oper '* (cons 'x (cons (oper '+ '(5 y)) '(x x)))))
(display "Attendu:\n(x * (5 + y) * x * x)\n")

(display "Test de print_expr (3/3): oper avec symbole non trivial\n")
(display "Print_expr:\n")
(print_expr (oper 'log (list (oper '+ '(3 x)))))
(display "Attendu:\n(log (3 + x))\n")
