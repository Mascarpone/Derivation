#lang typed/racket

(require "../src/Definition.rkt")

(require "../src/Fonctions.rkt")
(require "../src/Simplification.rkt")
(require "../src/Affichage.rkt")

(require "../src/Bibliotheque.rkt")
(require "../src/Derivation.rkt")

;; Tests Main
(display "\n**Tests Main**\n")

(display "\nTest de derivation (1/10):\n")
(display "Expression:\n(0 + x)\n")
(display "Dérivée proposée:\n")
(deriv-n_aff '(+ x 0) 1)
(display "Dérivée réelle:\n1\n")

(display "\nTest de derivation (2/10):\n")
(display "Expression:\n(2 * x)\n")
(display "Dérivée proposée:\n")
(deriv-n_aff '(* 2 x) 1)
(display "Dérivée réelle:\n2\n")

(display "\nTest de derivation (3/10):\n")
(display "Expression:\n((2 * x) + (3 * x))\n")
(display "Dérivée proposée:\n")
(deriv-n_aff '(+ (* 2 x) (* 3 x)) 1)
(display "Dérivée réelle:\n5\n")

(display "\nTest de derivation (4/10):\n")
(display "Expression:\n(1 / x)\n")
(display "Dérivée proposée:\n")
(deriv-n_aff '(/ 1 x) 1)
(display "Dérivée réelle:\n(-1 * (x ^ -2))\n")

(display "\nTest de derivation (5/10):\n")
(display "Expression:\n(log x)\n")
(display "Dérivée proposée:\n")
(deriv-n_aff '(log x) 1)
(display "Dérivée réelle:\n(1 / x)\n")

(display "\nTest de derivation (6/10):\n")
(display "Expression:\n(exp x)\n")
(display "Dérivée proposée:\n")
(deriv-n_aff '(exp x) 1)
(display "Dérivée réelle:\nexp(x)\n")

(display "\nTest de derivation (7/10):\n")
(display "Expression:\n(cos x)\n")
(display "Dérivée proposée:\n")
(deriv-n_aff '(cos x) 1)
(display "Dérivée réelle:\n(-1 * sin x)\n")

(display "\nTest de derivation (8/10):\n")
(display "Expression:\n(sin x)\n")
(display "Dérivée proposée:\n")
(deriv-n_aff '(sin x) 1)
(display "Dérivée réelle:\n(cos x)\n")

(display "\nTest de derivation (9/10):\n")
(display "Expression:\ntan(x)\n")
(display "Dérivée proposée:\n")
(deriv-n_aff '(tan x) 1)
(display "Dérivée réelle:\n(1 + (tan x) ^ 2)\n")

(display "\nTest de derivation (10/10):\n")
(display "Expression:\n(x ^ 3)\n")
(display "Dérivée proposée:\n")
(deriv-n_aff '(^ x 3) 1)
(display "Dérivée réelle:\n(3 * x ^ 2)\n")
