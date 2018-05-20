# DERIVATION

~achan ~ffichant ~flevern ~sgruchet


## Sommaire

  I. Contenu du dépot
  II. Utiliser le programme


## I. Contenu du dépot

  - dossier *src/* : contient les fichiers sources du projet

  - dossier *test/* : contient les fichiers de tests du projet


## II. Utiliser le programme

  - Pour utiliser les fichiers, on peut se rendre dans Main.rkt, le compiler, puis pour dériver une expression, taper une commande de la forme : 
    ```
    (deriv-n_aff expression ordre)
    ```
    où expression est l'expression à dériver (syntaxe Scheme) et ordre est l'ordre auquel on veut dériver cette expression. 
    **Exemple de dérivation : (deriv-n_aff (cos x) 1)**

  - Pour ajouter une règle de dérivation dans la bibliothèque, il faut taper :
    ```
    (: regle_de_derivation (expr * -> expr)) 
    (define (regle_de_derivation . l)
    (expression))

    (dict-add dict symbole regle_de_derivation)
    ```
    où regle_de_derivation est le nom à donner à cette règle, expression est l'expression à associer à cette règle (syntaxe oper), symbole est le symbole à associer à cette règle.
    **Exemple de règle de dérivation (somme) :
    (: d_sum (expr * -> expr))
    (define (d_sum . l)   
    (oper '+ (list (derivee (car l)) (derivee (cadr l)))))
    (dict-add dict '+ d_sum)**