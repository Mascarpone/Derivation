#lang typed/racket
(require "./Definition.rkt")



; Initialisation du dictionnaire de règles de dérivation
(: dict (HashTable expr (expr * -> expr)))
(define dict (make-hash))

; Ajout d'une règle de dérivation au dictionnaire
(: dict-add ((HashTable expr (expr * -> expr)) expr (expr * -> expr) -> Void))
(define (dict-add hashName fct der)
  (hash-set! hashName fct der))

; Suppression d'une entrée du dictionnaire
(: dict-rm ((HashTable expr (expr * -> expr)) expr -> Void))
(define (dict-rm hashName fct)
  (hash-remove! hashName fct))

; Accès à une entrée du dictionnaire
(: dict-read ((HashTable expr (expr * -> expr)) expr -> (expr * -> expr)))
(define (dict-read hashName fct)
  (hash-ref hashName fct))
  
; Nombre d'entrées dans le dictionnaire
(: dict-nb ((HashTable expr (expr * -> expr)) -> Integer))
(define (dict-nb hashName)
  (hash-count hashName))

; Liste les entrées du dictionnaire
(: dict-ls ((HashTable expr (expr * -> expr)) -> Void))
(define (dict-ls hashName)
  (hash-keys hashName))



;; PROVIDES

(provide dict)
(provide dict-add)
(provide dict-rm)
(provide dict-read)
(provide dict-nb)
(provide dict-ls)
