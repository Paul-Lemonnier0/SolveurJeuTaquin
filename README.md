# Solveur variante du jeu de taquin en Ocaml

Implémentation de plusieurs parcours permettant la résolution d'un variante du jeu de taquin en utilisant les principes de la programmation fonctionnelles (Ocaml).

## Description

Ce solveur trouve des solutions pour une variante du jeu du taquin. Ici, le joueur doit réorganiser les nombres dans une grille carrée pour les aligner dans l'ordre croissant. La particularité de ce jeu est que seule la pièce "0" peut être déplacée, et cette pièce peut être échangée avec l'une de ses pièces adjacentes dans les quatre directions possibles : haut, bas, gauche et droite. Il n'y a pas de case vide ici.

### Exemple d'une grille initiale

| 4 | 3 | 2 |
|---|---|---|
| **1** | **0** | **5** |
| **6** | **7** | **8** |

### Grille objectif

| 0 | 1 | 2 |
|---|---|---|
| **3** | **4** | **5** |
| **7** | **8** | **9** |

## Fonctionnalité :

- Génération de grille aléatoire
- Résolution de grilles 3x3 et 4x4 par différents parcours (efficacité croissante)

## Utilisation :

```
cat project.ml | ocaml
```

## Description des parcours :

Il y a trois parcours différents : 

- Parcours 1 :
  - Parcours naïf (lent)

- Parcours 2 :
  - Parcours naïf en mémorisant les grilles parcourues (rapide sur certains exemple, plus rapide que le parcours 1 dans tout les cas)

- Parcours 3 :
  - Parcours en mémorisant les grilles parcourues et en choisissant la prochaine grille de manière intelligente grâe à la fonction distance qui calcul la distance par rapport à l'objectif (nombre de coups). (permet de résoudre les grilles de taille 3 quasiment instantenémment et le grilles de taille 4 en un temps raisonnable)

Une variable **"parcoursChoisi"** permet de choisir quel parcours utiliser.
    
Il y a 3 grilles de taille 3 dans l'ordre croissant de difficultée de résolution.    
Des grilles de taille 4 sont aussi disponibles.

## Description des résultats

Dans le terminal, **chemin1**, **chemin2**, **chemin3** représente les solutions pour résoudre les grilles 1, 2, 3 avec le **parcoursChoisi**. Une résolution d'une grille prise au hasard de taille 3 avec 1000 mouvements est aussi présente.   
    
Il y a ensuite une résolution de grille de taille 4 (la grille est tirée au hasard, issue de 20 mouvements)

## Auteur

Paul Lemonnier     
paul.lemonnier49070@gmail.com  
