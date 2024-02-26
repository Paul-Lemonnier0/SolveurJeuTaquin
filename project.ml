(*PROJET OCAML*)

(*
J'ai traité toutes les questions.

Le parcours1 fonctionne instantanément pour la grille du niveau 1 et mes un peu plus de temps pour la grille niveau 2
Le parcours2 fait la grille niveau 1 et 2 instantanément et la grille niveau 3 en 12 secondes
Le parcours3 fait la grille niveau 1 2 3 instantanément, et les grilles de taille 4 en 10/12 minutes maximum

Normalement tout fonctionne correctement.
*)

type direction = Haut | Bas | Gauche | Droite;;

let grille = [0;1;2;3;4;9;6;7;8];;
let nbCotes = 3;;
let puzzle = (grille, nbCotes);;

(*
Description méthode valeur grille p

-si ma liste est vide alors je décris l'erreur
- si elle ne l'est pas, alors je la parcours en regardant la tête de la liste à chaque fois.
Si je trouve je renvoie 0 sinon je renvoie 1 + la position de x dans le reste de la liste.
Ainsi, quand j'itère, j'incrémente l'indice à chaque fois que la tête n'est pas égale à la valeur donnée en paramètre.
*)


let rec position grille x =
  match grille with
  [] -> failwith "Valeur introuvable"
  | e::r -> if e = x then 0 else 1 + (position r x);;


(*
Description méthode valeur grille p

-Je parcours ma liste tout en décrémentant mon index décrit ici par p.
-Si p = 0 alors je renvoie l'élément en tête de la liste (liste décrite ici par grille)
-Sinon je relance la fonction sur le reste de ma liste
*)

let rec valeur grille p =
  match (grille, p) with
  ([], _) -> failwith "Grille trop petite"
  | (e::r, 0) -> e
  | (e::r, _) -> (valeur r (p-1));;


(*
Description méthode echange grille v1 v2: 
J'utilise map donc je parcours chaque element de ma liste. Si l'élément est egal à v1 il devient v2 et inversement.
*)

let echange grille v1 v2 =
  List.map (function x -> if x = v1 then v2 else if x = v2 then v1 else x) grille;;
  
(*Description méthode déplacer : 

Je vérifie dans un premier temps que la grille stockée dans mon puzzle n'est pas vide.
Ensuite, je vais faire un cas par cas sur les potentielles directions. 
Je récupère une bonne fois pour toute la position de 0 afin de l'utiliser plus bas.
Ainsi, je dois, pour chaque direction vérifier si :
1) le mouvement est possible ?
2) comment faire le mouvement ?

Ainsi : 

HAUT :
1)

La première ligne d'une grille dans cet exercice est indexée de cette manière :
0, 1, ..., tailleCote-1

Ainsi, si le 0 se trouve sur cette ligne, il ne pourra pas aller plus haut.

2)

Monter une valeur d'une ligne signifie simplement enlever à son index la taille du côté.
Par exemple, dans une grille en 3x3, si le 0 est en position 6 et qu'on veut le faire monter, il passe en position 6-tailleCoté don 6-3 = 3

BAS
1)

Meme principe que pour le haut en soit. Seulement la condition varie un peu.
En effet, sur une grille de ce type, la derniere ligne est indexée de cette manière : 

tailleCote²-tailleCote, tailleCote²-tailleCote + 1, ..., tailleCote²- 1

Ainsi, si x est plus petit que le premier indice de cette ligne, donc plus petit que tailleCote²-tailleCote, alors on sait qu'il n'est pas présent dans cette dernière ligne.
Donc on peut faire le mouvement.

2) Ici, on ajoute tailleCoté à l'indice de 0 afin de lui faire descendre d'une ligne (étape inverse que pour la direction Haut)

GAUCHE

1)

Ici on utilise le reste de la division entière. 
En effet, on se rend compte qu'une telle grille à comme premier éléments de chaque lignes n°i :

totalCoté*i

Donc, si la division de (position(0)+totalCote) par totalCote est égale à 0, alors on sait que la position de 0 est un multiple de totalCote.
Ainsi, il est forcément sur le côté gauche de la grille.

2) Si 0 n'est pas sur le côté gauche, alors on le décale simplement vers la gauche en enlevant 1 à son index.


DROITE

1)
Même principe que la gauche mais dans l'autre sens. Chaque index de fin de ligne n°i est de la forme :

totalCoté*i + totalCoté-1

Donc, si la division de (position(0)+totalCote) par totalCote est égale à tailleCote-1, alors on sait que la position de 0 est celle d'avant celle qui est un multiple de totalCote.
Ainsi, il est forcément sur le côté droit de la grille (en bout de ligne).

2) Si 0 n'est pas sur le côté droit, alors on le décale simplement vers la droite en ajoutant 1 à son index.

Pour les directions gauches et droites on ajoute totalCote à la position de 0 dans les comparaisons pour pouvoir intégrer la première ligne à nos tests.
Cela ne change rien car totalCote mod totalCote = 0. Par contre : 0 mod totalCote = totalCote donc on aurait un soucis si on ne l'ajoutait pas.

Pour chacune des directions, on echange la position de 0 avec la future position de 0.
*)

let deplacer puzzle direction =
  match (puzzle) with
   (([], _)) -> failwith "Erreur, puzzle vide"
  |((puzzle_grille, puzzle_tailleCote)) -> 

    let position_Z = (position puzzle_grille 0) in
   
      match direction with
        Haut -> if position_Z >= puzzle_tailleCote
                then echange puzzle_grille (valeur puzzle_grille (position_Z-puzzle_tailleCote)) 0  
              else puzzle_grille 
    
      | Bas -> if position_Z < puzzle_tailleCote*(puzzle_tailleCote-1) 
                then echange puzzle_grille (valeur puzzle_grille (position_Z+puzzle_tailleCote)) 0
              else puzzle_grille 

      | Gauche -> if ((position_Z + puzzle_tailleCote) mod puzzle_tailleCote) <> 0
                    then echange puzzle_grille (valeur puzzle_grille (position_Z-1)) 0
                  else puzzle_grille 

      | Droite -> if ((position_Z + puzzle_tailleCote) mod puzzle_tailleCote) <> (puzzle_tailleCote-1) 
                    then echange puzzle_grille (valeur puzzle_grille (position_Z+1)) 0
                  else puzzle_grille ;;


let directions = [Gauche; Droite; Haut; Bas];;

Random.self_init();;  (*J'initialise la seed de mon random sinon j'ai toujours le même chiffre qui est pioché par lancement de programme*)
let getRandomInt () = Random.int 4;;

(*Ici, on vérifie que la grille n'est pas vide avant tout.
  Ensuite, si le nombre de mouvement à faire est de 0 alors pas besoin de bouger la grille, on la renvoie tel quel (c'est mon cas d'arrêt)
   Ensuite, on choisit un entier entre 1 et 4 afin de choisir une direction aléatoirement.
   On créer le déplacement sur la grille avec la direction piochée.
   Si le résultat est la même grille qu'avant le déplacement, on relance une direction sans mettre à jour le compteur de mouvements.
   Sinon, on relance le melange avec la grille obtenue et en mettant à jour le compteur (-1)*)

let rec melanger puzzle iterations =
  match (puzzle, iterations) with
  (([], _), _) -> failwith "Grille vide, aucun mélange possible"
  |((puzzle_grille, _), 0) -> puzzle_grille
  |((puzzle_grille, puzzle_tailleCote), n) -> 
    let randomInt = getRandomInt() in 
      let newDirection = (valeur directions randomInt) in
          let newGrille = deplacer puzzle newDirection in
            if newGrille = puzzle_grille then melanger puzzle n 
            else melanger (newGrille, puzzle_tailleCote) (n-1);;


(*
Pour tester une grille c'est simple, on parcours un chemin en fold_right (car c'est mon sens d'ajout) et on applique la direction a la grille qui se construit dans le fold.
La grille initiale est celle du puzzle passé en paramètre
*)

let testerChemin puzzle chemin = 
  match puzzle with
  (puzzle_grid, taille_grid) -> List.fold_right(fun direction n -> (deplacer (n, taille_grid) direction)) chemin puzzle_grid;;


(*PARCOURS 1*)

(*
Pour le parcours1, on regarde si la grille en tete de la liste est la grille finale, auquel cas on renvoie son chemin.
   Sinon, on va générer les différentes prochaines grilles possibles en parcourant le tableau des directions et en ajoutant la grille résultante de la combinaison de la grille_en_tete et de la direction
   seulement si cette dernière n'est pas la même que la grille_en_tete. (=> si le mouvement a réussi.)
   Auquel cas on ajoute cette grille en mettant son chemin à jour.
   On rappel la fonction parcours1 sur les nouvelles prochaines grilles ajoutée aux prochaines grilles jusqu'à trouver une solution. 
*)

let rec parcours1 grille_finale taille prochaines_grilles = 
  match prochaines_grilles with
  (grille_en_tete, chemin_en_tete)::reste_prochaines_grilles -> if grille_en_tete = grille_finale then chemin_en_tete 
    else let nouvelles_prochaines_grilles = List.fold_left (fun listeGrilles direction-> 
        let nouvelle_grille = deplacer (grille_en_tete, taille) direction in
          if nouvelle_grille = grille_en_tete then listeGrilles
          else listeGrilles@[nouvelle_grille, (direction::chemin_en_tete)]) reste_prochaines_grilles directions in

          parcours1 grille_finale taille nouvelles_prochaines_grilles;;

(*FIN PARCOURS 1*)

(*PARCOURS 2*)

(*Fonction qui vérifie simplement une liste de paire a un element qui a comme premier element de sa paire la meme grille que celle donnee en parametre.*)

let grille_deja_parcourue grille listeDeGrillesChemins =
  List.exists (fun g -> (fst g) = grille) listeDeGrillesChemins;;

(*Dans le parcours2, on prends le même principe que le parcours1 : si la grille en tete de liste est la meme que la grille finale on renvoie son chemin,
  sinon on parcours la liste de direction et créer les 4 grilles naissant de grille_en_tete et des directions parcourues.
  Si cette grille est la même que la grille_en_tete alors pas besoin d'aller plus loin, le mouvement n'a pas eu lieu
  Sinon, on regarde si cette grille existe dans le tableau des grilles parcourues, si oui alors on ne l'ajoute pas, sinon on l'ajoute au reste des nouvelles grilles.
  On relance notre parcours2 jusqu'à trouver une solution.*)

let rec parcours2 grille_finale taille prochaines_grilles grilles_parcourues = 
  match prochaines_grilles with
  [] -> []
  |(grille_en_tete, chemin_en_tete)::reste_prochaines_grilles -> if grille_en_tete = grille_finale then chemin_en_tete 

    else let nouvelles_prochaines_grilles = List.fold_left (fun listeGrilles direction -> 
      let nouvelle_grille = (deplacer (grille_en_tete, taille) direction) in 
        if(nouvelle_grille = grille_en_tete) then listeGrilles (*cette ligne peut sembler inutile mais elle m'évite d'office de rentrer dans une itération sur toute la liste*)
        else 
          if (grille_deja_parcourue nouvelle_grille grilles_parcourues) then listeGrilles (*On vérifie si la grille a déjà été parcourue*)
          else listeGrilles@[nouvelle_grille, (direction::chemin_en_tete)]) reste_prochaines_grilles directions in
        
    parcours2 grille_finale taille nouvelles_prochaines_grilles ((grille_en_tete, chemin_en_tete)::nouvelles_prochaines_grilles);;

(*FIN PARCOURS 2*)

(*PARCOURS 3*)
(*je ne savais pas si j'avais le droit d'utiliser abs*)

let valeurAbsolue x = if x >= 0 then x else -x;;

(*On parcours simplement toutes les grilles de la liste passée en paramètre et on renvoie true si la grille est contenue dans cette liste.*)
(*J'ai refais une fonction car sur un triplet on ne peut pas utiliser fst*)

let grille_deja_parcourue_Parcours3 grille grilles_parcourues =
  List.exists (fun (g,_,_) -> g = grille) grilles_parcourues;;


(*Pour la fonction distance je suis parti du principe que les décalages horizontaux valent soit 0 soit 1 soit ... soit n-1 avec n la taille de la grille

Ainsi, pour calculer la distance entre l'élément à la position a et l'élément à la position b, on fait la différence de ces deux valeurs donc : a - b.
Seulement, si a est en position 0 et b en position 2 alors la distance n'est pas de 0-2=-2 mais bien de |0-2|=|-2|=2
Dans la formule que j'ai décrite dans la fonction, le modulo me permet de mettre toutes les positions sur une même ligne. En effet, si je fais simplement 8-2 = 6 alors que les mouvements horizontaux pour aller de 8 à 6 sont égaux à 0 (ils sont tous deux tout à droites si n=3)

Ensuite, pour la distance verticale : (on par du principe qu'ils sont strictement l'un en dessous de l'autre)

Une valeur b est en dessous d'une valeur a dans une grille si position(b) = position(a) + n avec n la taille de la grille.

Idem, une valeur a est au dessus d'une valeur b dans une grille si position(a) = position(b) - n avec n la taille de la grille.
Alors, pour calculer la distance verticale de deux valeurs a et b il faut diviser la différence des deux positions par la taille de la grille.
En effet, si la valeur en position b est 2 crans en dessous de la valeur en position a , alors on position(a) = position(b) - n - n = position(b) - 2n
Ainsi, pour calculer le nombre de mouvements nécéssaires, on a : |position(a) - position(b)| / n = nbMouvementsVerticaux
(les valeurs absolues sont la pour ignorer qui est dessus et qui est dessous)*)


let distance grille_initial grille_finale taille =
  List.fold_left(fun dist element -> 
                    let positionVisee = position grille_finale element in 
                      let currentPosition = position grille_initial element in
                        let mouvementsVerticaux = valeurAbsolue (currentPosition - positionVisee) / taille in
                          let mouvementsHorizontaux = valeurAbsolue (currentPosition - positionVisee) mod taille in 
                            (dist + mouvementsHorizontaux + mouvementsVerticaux)) 0 grille_initial;;
  


(*
On parcours la liste récursivement. On part du principe que la liste est déjà triée et qu'on veut faire une sorte de tri par insertion, donc on veut ajouter la valeur à sa bonne place dans la liste.
En effet, comme on ajoute au fur et à mesure des éléments dans la grille, il semble pertinent d'ajouter de manière croissante au lieu de tout trier à chaque insertion.

Ainsi, si la grille est vide, on renvoie une grille qui a pour seul élément l'élément qu'on souhaite ajouter.
Sinon, si le premier élément de la liste a une distance plus grande que l'élément qu'on souhaite ajouter, alors on ajoute cet élément en tête de liste.
Sinon, on relance la fonction sur le reste de la grille en ajoutant la valeur en tête à cette déclaration pour ne pas la perdre dans le processus.
Si la valeur doit s'ajouter à la toute fin, la première condition d'arrêt s'en occuperra.*)

let rec ajouterCroissant listeGrilles element =
  match (element, listeGrilles) with
  ((grille, chemin, distance), []) -> [element]
  |((grille, chemin, distance), ((grille_x, chemin_x, distance_x)::r)) -> if distance<distance_x then (element::listeGrilles)
                                            else ((grille_x, chemin_x, distance_x)::(ajouterCroissant r element));;

(* 
Meme principe que pour parcours2 mais en stockant les prochaines_grilles dans l'ordre croissant de leurs distances respectives.
Ainsi, le déroulé est le même :
-Si la grille en tete de la liste prochaines_grilles est égale à la grille finale, dans ce cas on retourne le chemin pour y arriver.
-Sinon : on parcours la liste des directions possibles (Gauche, Haut, Bas, Droite) et on vérifie que la grille obtenue en appliquant la direction courante à la grille en tete n'a pas déjà été traitée.
                                            Si la grille a déjà été traitée, on n'ajoute pas la grille aux nouvelles grilles obtenues
                                            Sinon, on l'ajoute.
-Ensuite, on parcours ces nouvelles grilles trouvées avec un List.fold (left ou right pour le coup car on ajoute selon une comparaison donc pas d'importance) qui a pour base le reste des prochaines grilles.
On ajoute ces nouvelles grilles à la bonne place dans la liste puis on relance parcours3 avec les prochaines_grilles qui deviennent nouvelles_prochaines_grilles et les grilles_parcourues qui deviennent :
grilles_parcourues concaténée avec les nouvelles grilles. D'ailleurs, je n'initialise pas grille_parcourues à vide dans la fonction résoudre simplement car comme ça je suis sur que la grille initiale est stockée dans cette
liste dès le début. En effet, si sur une grille 3x3 on entame avec un 0 qui est pile au milieu de la grille (1,1), alors je ne stock pas la grille initiale des le 1er coup.
*)


let rec parcours3 grille_finale taille prochaines_grilles grilles_parcourues = 
  match prochaines_grilles with
  [] -> []
  |(grille_en_tete, chemin_en_tete, _)::reste_prochaines_grilles -> if grille_en_tete = grille_finale then chemin_en_tete 
    
    else let nouvelles_grilles = List.fold_left (fun listeNouvellesGrilles direction -> 

            let nouvelle_grille = (deplacer (grille_en_tete, taille) direction) in 
                if(nouvelle_grille = grille_en_tete) then listeNouvellesGrilles 
                else
                  if (grille_deja_parcourue_Parcours3 nouvelle_grille grilles_parcourues)
                    then listeNouvellesGrilles
                  
                  else let distance_nouvelle_grille = (distance nouvelle_grille grille_finale taille) in
                        (nouvelle_grille, (direction::chemin_en_tete), distance_nouvelle_grille)::listeNouvellesGrilles

            ) [] directions in 

          let nouvelles_prochaines_grilles = List.fold_left (fun nouvelleListe nouvelleGrille -> ajouterCroissant nouvelleListe nouvelleGrille) reste_prochaines_grilles nouvelles_grilles in       
    parcours3 grille_finale taille nouvelles_prochaines_grilles (grilles_parcourues@nouvelles_grilles)
;;
              
                                 
(*FIN PARCOURS 3*)

(*Simple match avec le parcours désiré. J'initialise ensuite les premières valeurs avec la grille initiale.*)


let rec resoudre grille_init grille_finale taille parcours =
  let prochainesGrilleInit = [(grille_init, [])] in
  match parcours with
  1 -> parcours1 grille_finale taille prochainesGrilleInit
  |2 -> parcours2 grille_finale taille prochainesGrilleInit prochainesGrilleInit
  |3 -> let grilleInitParcours3 = [(grille_init, [], (distance grille_init grille_finale taille))] in parcours3 grille_finale taille grilleInitParcours3 grilleInitParcours3
  |_ -> failwith "Parcours inconnu.";;


(*Test du programme : *)

let parcoursChoisi = 3;;

let finalGrid = [0;1;2;3;4;5;6;7;8];;
let grille_lvl_1 = [3;1;2;4;7;5;0;6;8];;
let grille_lvl_2 = [6;3;1;4;0;2;7;8;5];;
let grille_lvl_3 = [1;4;3;6;2;8;7;5;0];;
let grilleShuffled = (melanger (finalGrid, 3) 1000);;

let puzzle_test = (grille_lvl_3, 3);;

let chemin1 = resoudre grille_lvl_1 finalGrid 3 parcoursChoisi;;
testerChemin (grille_lvl_1, 3) chemin1;;

let chemin2 = resoudre grille_lvl_2 finalGrid 3 parcoursChoisi;;
testerChemin (grille_lvl_2, 3) chemin2;;


let chemin3 = resoudre grille_lvl_3 finalGrid 3 parcoursChoisi;;
testerChemin (grille_lvl_3, 3) chemin3;;

let cheminShuffled = resoudre grilleShuffled finalGrid 3 parcoursChoisi;;
testerChemin (grilleShuffled, 3) cheminShuffled;;

let finalGrid_x4 = [0;1;2;3;4;5;6;7;8;9;10;11;12;13;14;15]
let grille_lvl_1_x4 =  [10;12;4;5;9;14;8;3;0;11;6;15;13;7;2;1]
let grilleShuffled = (melanger (finalGrid_x4, 4) 20);;

let chemin4 = resoudre grille_lvl_1_x4 finalGrid_x4 4 parcoursChoisi;;
testerChemin (grille_lvl_1_x4, 4) chemin4;;
