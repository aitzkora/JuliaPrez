Julia comme logiciel de calcul
==============================

Syntax 
--------
 - differences avec _malab_
 - aspects fonctionnels :
    - lists definies en comprehension
    - map, reduce, filter
 - de-vectoriser le code 
 - fortran indicage pour le code
parallelisme 
--------------
- iteration peu couteuse -> utiliser une reduction 

    s = @parallel (+) for i=1:10000
        f(i)
    end

- iteration coûteuse -> utiliser pmap

    M = { rand(1000,1000) for i=1:100};
    @time sum(pmap(x->max(svd(x)[2]),M));

- penser à comparer avec _malab_


Fonctions
----------
- tuples(astuces du `...`)
- arguments variables 
- arguments nommés
- point d'exclamation

bibliothèques externes
-----------------------


Principes de Julia
==================
 -expliquer briévement le système de *selection de méthodes* 
 

Types :
-------
Faire une chaine de types 

    None <:  ... <: Number <:   Any
  
les *fonctions* sont définies par morceaux. Une _méthode_ est un comportemnt
possible d'une fonction : Quand une fonction est appliqué a un argument, la méthode la plus
spécifique est appliqué à cet argument :

     f(x,y) = x + y 
     f(x::Float64,y::Float64) = x*y

Ainsi `f(2,3)` renvoies 5, mais `f(2.,3.)` renvoies 6. Que renvoies 

la selection de la _méthode_ s'appelle la _répartition_ ('dispatch'), et contrairement
aux langages objets celle si s'effectue sur tous les arguments.
Pas de conversions automatiques. Les opérateurs arithmetiques sont fournis avec
des répartitions pré-définies

