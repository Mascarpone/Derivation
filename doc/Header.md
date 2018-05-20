# DESCRTIONS DES FONCTIONS IMPLEMENTEES

## Sommaire

    I. Definition.rkt
    II. Affichage.rkt
    III. Bibliotheque.rkt
    IV. Derivation.rkt
    V. Simplification.rkt
    VI. Fonctions.rkt
    VII. Main.rkt

NB : Tous les fichiers sources sont écrits en #lang typed/racket ce qui implique certains cast qui n'auraient pas été nécessaires en #lang racket


## I. Definition.rkt

Définition du type utilisé pour tous les traitements des fonctions du programme
Une expression est représentée par un nombre, un symbole ou une opération
Une opération est une structure dans laquelle se trouve l'opérateur ainsi qu'un liste d'expressions correspondant à ses arguments

Définition des prédicats expr? et is_oper?


## II. Affichage.rkt

Affichage d'une expression, en infixe pour les opérateurs binaires (i.e. de la forme (x + y) et non (+ x y))
(: print_expr_f (expr -> Void)) // fonction nécessaire pour la construction de print_expr
(: print_expr (expr -> Void)) 


## III. Bibliotheque.rkt

API dictionnaire utilisant une table de hachage pour stocker les techniques de dérivation en fonction de l'opétrateur


Le dictionnaire dict
(: dict (HashTable expr (expr * -> expr)))

Ajoute une règle de dérivation dans le dictionnaire
Prend en arguments : dict, l'opérateur, la fonction représentant la technique de dérivation
(: dict-add ((HashTable expr (expr * -> expr)) expr (expr * -> expr) -> Void))

Retire une entrée du dictionnaire
Prend en arguments : dict, l'opérateur
(: dict-rm ((HashTable expr (expr * -> expr)) expr -> Void))

Accès à une entrée du dictionnaire
Prend en arguments : dict, l'opérateur
Retourne : la technique de dérivation
(: dict-read ((HashTable expr (expr * -> expr)) expr -> (expr * -> expr)))

Nombre d'entrées dans le dictionnaire
(: dict-nb ((HashTable expr (expr * -> expr)) -> Integer))

Liste les entrées du dictionnaire
(: dict-ls ((HashTable expr (expr * -> expr)) -> Void))


## IV. Derivation.rkt

Liste de toutes les techniques de dérivations ajoutées dans le dictionnaire


La norme pour ajouter une technique de dérivation supplémentaire au dictionnaire est la suivante :
Elle prend en argument une liste d'expressions de taille 2 ou moins représentant les arguments de la fonction à dériver -> de la forme (operateur u v)
Elle retourne une expression expr qui est la dérivée par rapport à l'opérateur en considérant que les arguments u et v sont elles mêmes des fonctions à dériver. Ainsi, chaque technique fera appel à la fonction derivee.
Enfin, la technique est ajoutée au dictionnaire à l'aide de la fonction dict-add et du symbole représentant l'opérateur.

Un exemple est plus parlant : 
Technique de dérivation pour la somme de deux expressions
(: d_sum (expr * -> expr))
(define (d_sum . l)
    (oper '+ (list (derivee (car l)) (derivee (cadr l)))))

(dict-add dict '+ d_sum)


Les techniques qui ont été implémentées sont :
somme, produit, quotient, logarithme, exponentielle, cosinus, sinus, tangeante, puissance constante.
NB : la composition n'a donc pas d'intéret ici puisque la manière de rajouter une règle la prend en compte


## V. Simplification.rkt

Les simplifications implémentées sont orientées pour les polynômes


Fonction qui permet de retirer tous les opérateurs '- de l'expression pour considérer cela comme un opérateur '+ avec des arguments négatifs
(: diff-somme (expr -> expr))

Fonctions qui permettent de concaténer des opérations ayant le même opérateur en une seule
Par exemple (+ 2 3 (+ 'x 4)) deviendra (+ 2 3 'x 4) 
(: conc_s_l* ((Listof expr) Symbol -> (Listof expr)))
(: conc_s* (expr Symbol -> expr))

Fonctions qui permettent de développer une expression polynomiale (d'un produit de somme vers une somme de produits)
(: somme-pdt ((Listof expr) (Listof (Listof expr)) Number -> (Listof expr)))
(: developpe_l ((Listof expr) (Listof expr) (Listof (Listof expr)) -> (Listof expr)))
(: developpe (expr -> expr))

Fonction qui permet de supprimer un entier d'une liste d'expressions
(: list_suppr ((Listof expr) Integer -> (Listof expr)))

Fonction qui élimine les neutres pour le produit et la somme (1 et 0) dans toute l'expression
Par exemple, (+ 'x (* 2 1 'x) 0) deviendra (+ 'x (* 2 'x))
(: fact_suppr (expr -> expr))

Fonction qui s'implifie les produit par 0
(: fact_neutre (expr -> expr))

Fonctions qui retirent les les produits ou sommes à un seul élément pour ne laisser que le résultat
Par exemple (+ 1 2 (* 'x)) deviendra (+ 1 2 'x)
(: parentheses_l ((Listof expr) -> (Listof expr)))
(: parentheses (expr -> expr))

Fonctions qui rassemblent les entiers d'une expression en leur appliquant l'opérateur
Par exemple, (+ 2 3 4 (* 2 'x 'x 3)) deviendra (+ 9 (* 6 'x 'x))
(: factorise_l ((Listof expr) (Number * -> Number) Number -> (Listof expr)))
(: factorise (expr -> expr))


## VI. Fonctions.rkt

Fonction qui applique les fonctions de simplification dans le bon ordre pour retourner une expression la plus simplifiée possible (selon nos règles de simplification)
(: simplifie (expr -> expr))

Fonction de dérivation qui recherche les règles de dérivation dans le dictionnaire pour les appliquer aux opérateurs
Cette fonction effectue la dérivée première des expressions à la variable 'x uniquement
(: derivee (expr -> expr)

Fonction qui calcule la dérivée n-ième de l'expression écrite avec la synthaxe Scheme
Elle retourne l'expression dérivée en sythaxe Scheme
(: deriv-n ((Listof Any) Integer -> (Listof Any)))

Fonction qui calcule la dérivée n-ième de l'expression écrite avec la synthaxe Scheme et affiche le résultat en infixe
(: deriv-n_aff ((Listof Any) Integer -> Void))

Fonction qui traduit une expression écrite en synthaxe Scheme vers une expression utilisée par le programme (sous la forme (oper s l) ou symbole ou number)
(: trad ((Listof Any) -> expr))

Fonction réciproque de trad() qui traduit une expression utilisée par le programme en une liste représentant l'expression en synthaxe Scheme
(: trad_inv (expr -> (Listof Any)))

Fonction qui organise les opérations de telle sorte qu'elles prennent 2 arguments ou moins
C'est un préconditionnement nécessaire pour calculer une dérivée puisque la norme fixée pour le dictionnaire est que l'expression prenne au plus 2 arguments
(: precond (expr -> expr))


## VII. Main.rkt

C'est le fichier dans lequel l'utilisateur peut faire ses calculs en utilisant la fonction deriv-n ou deriv-n_aff sur une expression écrite en Scheme.












