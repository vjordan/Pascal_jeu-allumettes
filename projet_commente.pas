program projet_allumettes;

uses crt;
const M=20;
type tab=array[1..M] of integer;
var nom,rep,niv,prem,tour,vainqueur,reponse:string;
	nb_allumettes,nbtours,nb_allumettes_initial,i,n:integer;
	abandon,okrep,okreponse,rejouer:boolean;
	T:tab;	

// début de la sous-tâche 1 (saisie des paramètres de la partie)

procedure saisie (var nom:string; var niv:string; var nb_allumettes:integer; var prem:string);
					// décision de mettre niv et prem de type string pour un contrôle optimal de leur saisie ( exemple: si niv de type char et le joueur entre "eabcd",
var okniv,oknb_allumettes,okprem:boolean;																	// le programme considère que le joueur veut jouer contre			
																											// un ordinateur en mode expert, ce qui est imprécis)
begin

writeln('Bonjour, quel est votre nom?');
readln(nom); // lecture du nom du joueur
writeln('Salut ',nom,'. Bienvenue pour jouer au jeu des allumettes!'); // message de bienvenue
writeln;
writeln('Il suffit d''enlever 1,2 ou 3 allumette(s) a chaque tour. Le joueur qui retire laderniere allumette a perdu.'); // pas d'espace entre "la" et "dernière" pour
writeln('Vous pouvez abandonner en cours de partie en enlevant 0 allumette.');											 // un meilleur affichage en jeu
writeln; // petit rappel des règles du jeu des allumettes
repeat // boucle "répéter ... jusqu'à" pour contrôler la bonne saisie du niveau de l'ordinateur
	writeln('A quel niveau voulez-vous programmer Ordi? expert(e) ou naif(n)'); 
	readln(niv); // saisie du niveau de l'ordinateur
	if niv='e' then
	begin
		okniv:=true;
		writeln('Vous voulez jouer dans la cour des grands!');
		writeln; // si le joueur veut jouer contre l'ordinateur en expert, c'est ok 
	end;	
	if niv='n' then
	begin
		okniv:=true;
		writeln('Vous etes un petit joueur!');
		writeln; // si le joueur veut jouer contre l'ordinateur en naïf, c'est ok
	end;
	if (niv<>'e') and (niv<>'n') then			
	begin 
		okniv:=false;
		writeln('Vous devez repondre ''e'' ou ''n''!'); // message d'erreur en cas de mauvaise saisie du niveau de l'ordinateur voulu
	end;	
until (okniv); // fin de la boucle de contrôle du niveau de l'ordinateur

repeat // contrôle du nombre d'allumettes initial rentré par le joueur
	writeln('Avec combien d''allumettes voulez-vous jouer? entre 10 et 20');
	readln(nb_allumettes); // lecture du nombre d'allumettes au départ souhaité par le joueur
	if (nb_allumettes>9) and (nb_allumettes<21) then
	begin
		oknb_allumettes:=true;
		writeln('C''est parti pour ',nb_allumettes,' allumettes!');
		writeln; // si le joueur veut jouer avec un nombre d'allumettes compris entre 10 et 20, c'est ok
	end			 // on a souhaité mettre au minimum 10 allumettes pour que l'on puisse faire au moins une petite partie	
	else		 // le minimum 0 demandé à l'énoncé nous semblait un peu illogique
	begin
		oknb_allumettes:=false;
		writeln('Vous devez donner un nombre d''allumettes compris entre 10 et 20!'); // message d'erreur révélé en cas de réponse incorrect
	end;
until (oknb_allumettes); // fin de la boucle de contrôle du nombre d'allumettes

repeat // contrôle de la saisie du choix par rapport au participant qui va débuter la partie
	writeln('Quel sera le premier joueur? vous le joueur(j) ou Ordi(o)');
	readln(prem); // lecture du concurrent qui va commencer la partie, décidé par le joueur
	if prem='j' then
	begin
		okprem:=true;
		writeln('Vous aimez bien prendre les devants!');
		writeln; // si le joueur veut commencer en premier, c'est ok
	end;
	if prem='o' then
	begin
		okprem:=true;
		writeln('Vous etes trop galant!');
		writeln; // si le joueur veut laisser sa place pour débuter la partie, c'est ok
	end;
	if (prem<>'j') and (prem<>'o') then
	begin
		okprem:=false;
		writeln('Vous devez repondre ''j'' ou ''o''!'); // message d'erreur si nécessaire
	end;
until (okprem);	// fin de la boucle de contrôle du premier joueur

end;

// fin de la sous-tâche 1

// début de la sous-tâche 2 ( affichage des allumettes au cours de la partie)

procedure affiche (nb_allumettes:integer);

var i:integer;

begin // choix personnel pour la forme des allumettes ( implique 3 boucles "for" )

for i := 1 to nb_allumettes do
begin
	write('0 ');
	if i mod 5 = 0 then // on met chaque caractère composant les allumettes en groupe de 5
		write('   ');
end;
writeln;

for i := 1 to nb_allumettes do
begin
	write('| ');
	if i mod 5 = 0 then // idem
		write('   ');
end;
writeln;

for i := 1 to nb_allumettes do
begin
	write('| ');
	if i mod 5 = 0 then // idem
		write('   ');
end;
writeln;
writeln;	

end;

// fin de la sous-tâche 2

// début de la sous-tâche 4 ( permet de faire jouer l'ordinateur)

function joueOrdi (niv:string) :integer;

var k,nb_ordi:integer;

begin

k:=0;
textcolor(12); // apport de couleur pour distinguer les différentes phases de jeu

writeln('Ordi joue ...'); // indication que l'ordinateur est en train de jouer
if niv='n' then // si l'ordinateur est en mode naïf ...
begin
	if nb_allumettes>4 then // ... il génère un nombre aléatoire d'allumettes à retirer
		nb_ordi:=random(3)+1;
	if (nb_allumettes>1) and (nb_allumettes<5) then // ... ou il gagne de l'intelligence et de la logique en toute fin de partie pour éviter des situations absurdes
		nb_ordi:=nb_allumettes-1;					//     ( par exemple : un retrait de 3 allumettes alors qu'il n'en reste que trois)
	if nb_allumettes=1 then // ... s'il reste 1 allumette, on oblige l'ordinateur à la prendre
		nb_ordi:=1;
end
else // si l'ordinateur est en mode expert ...
begin
	repeat
		nb_ordi:=nb_allumettes-(4*k+1); // ... l'ordinateur joue le complément à 4 de telle façon qu'il laisse un nombre d'allumettes de la forme  
		k:=k+1;						    //     4*k+1 ( k étant un entier positif ou nul ) afin qu'il gagne à tous les coups
	until (nb_ordi>=0) and (nb_ordi<4);
	if nb_ordi=0 then // s'il n'est pas possible d'enlever un nombre suffisant d'allumettes afin d'avoir la combinaison gagnante ...
	begin
		repeat
			nb_ordi:=random(3)+1; // ... il génère un nombre aléatoire
		until nb_ordi<=nb_allumettes;
	end;		
end;					
writeln('Ordi a retire ',nb_ordi,' allumette(s).'); // indication du nombre d'allumettes retirées par l'ordinateur
writeln;
		
joueOrdi:=nb_ordi;

end;

// fin de la sous-tâche 4

// début de la sous-tâche 5 ( permet de faire jouer le joueur)

function joueJoueur (nom:string) :integer;

var nb_joueur:integer;
	okjoueur:boolean;

begin

abandon:=false;
textcolor(9); // apport de couleur pour distinguer les différentes phases de jeu

writeln(nom,' joue ...'); // indication que le joueur est en train de jouer
repeat // boucle de contrôle de la saisie du nombre d'allumettes à retirer en cours de partie
	writeln('Combien d''allumettes voulez-vous retirer?');
	readln(nb_joueur); // lecture du nombre d'allumettes à retirer souhaité par le joueur
	if (nb_joueur>3) or (nb_joueur<0) then
	begin
		okjoueur:=false; // correction obligatoire en cas de saisie absurde
		writeln('Erreur! Veuillez saisir un chiffre entre 1 et 3 pour retirer les allumettes!');
	end;	
	if (nb_joueur>nb_allumettes) and (nb_joueur>0) and (nb_joueur<4) then
	begin
		okjoueur:=false; // correction obligatoire si le joueur souhaite retirer plus d'allumettes qu'il n'en reste
		writeln('Erreur! Il reste moins d''allumettes!'); 
	end;	
	if nb_joueur=0 then
	begin
		abandon:=true; // retrait de 0 allumette correct : signification que le joueur souhaite abandonner
		textcolor(10); // encore un peu de couleur ...
		writeln;
		writeln('Vous avez decide d''abandonner!'); // indication que le joueur a pris la décision d'abandonner
	end;		
	if (nb_joueur<4) and (nb_joueur>0) and (nb_joueur<=nb_allumettes) then
		okjoueur:=true; // si le retrait voulu est correct, c'est ok
until (okjoueur) or (abandon); // fin de la boucle de contrôle
writeln;
					
joueJoueur:=nb_joueur;	

end;

// fin de la sous-tâche 5

// début de la seconde partie de la sous-tâche 3 ( mise à jour du nombre d'allumettes en jeu )

procedure miseAjour (var nb_allumettes:integer; nb:integer);

begin

nb_allumettes:=nb_allumettes-nb; // on met à jour le nombre d'allumettes présentes en jeu à chaque tour
T[i]:=nb; // remplissage successif du tableau de l'historique
i:=i+1;

end;

// fin de la seconde partie de la sous-tâche 3

// début de la première partie de la sous-tâche 3 ( pour faire jouer les deux opposants chacun leur tour)

procedure jeualterne (var tour:string);

var tourjoueur,tourordi:integer;

begin

if tour='o' then // si c'est au tour de l'ordinateur de jouer ...
begin
	tourordi:=joueOrdi(niv); // ... on fait appel à la fonction qui fait jouer l'ordinateur
	miseAjour(nb_allumettes,tourordi); // ... on met à jour le nombre d'allumettes qu'il reste après le coup joué
	tour:='j'; // ... on laisse la place à l'autre joueur
end	
else // si c'est au tour du joueur de jouer ...
begin
	tourjoueur:=joueJoueur(nom); // ... on fait appel à la fonction qui fait jouer le joueur
	miseAjour(nb_allumettes,tourjoueur); // ... on met à jour le nombre d'allumettes qu'il reste après le coup joué 
	tour:='o'; // ... on change de joueur
end;

end;

// fin de la première partie de la sous-tâche 3

// début de la procédure pour afficher un historique en fin de partie

procedure historique (nbtours:integer; nb_allumettes_initial:integer; vainqueur:string);

var i:integer;

begin

writeln('Il y avait ',nb_allumettes_initial,' allumettes au depart.'); // affichage du nombre d'allumettes présentes au tout début de la partie
writeln;
writeln;
writeln('numero tour          joueur    allumettes retirees'); // en-tête du tableau
writeln;
writeln;
for i:=1 to nbtours do // gestion du nombre de tours qui a été joué
begin
	if prem='j' then // si le joueur a joué en premier
	begin
		if n mod 2=0 then // gestion de l'affichage des concurrents qui ont joué à chaque tour
			writeln(n:7,'Ordi':20,T[i]:14) // on alloue à chaque valeur du tableau un certain volume pour un alignement parfait entre elles	
		else
			writeln(n:7,nom:20,T[i]:14);	
	end;
	if prem='o' then // si l'ordinateur a joué en premier
	begin
		if n mod 2=0 then // gestion de l'affichage des concurrents qui ont joué à chaque tour
			writeln(n:7,nom:20,T[i]:14)	
		else
			writeln(n:7,'Ordi':20,T[i]:14);	
	end;
n:=n+1;
end;
writeln;
writeln;
writeln('Le vainqueur est ',vainqueur,'.'); // affichage de l'identité du vainqueur
	
end;

// fin de la procédure pour afficher un historique en fin de partie

// début de la tâche principale

BEGIN

repeat // boucle permettant de rejouer une partie
	clrscr;
	abandon:=false;
	nbtours:=0; // initialisation des variables pour l'historique
	i:=1;
	n:=1;

	saisie(nom,niv,nb_allumettes,prem); 		// appel de la procédure de saisie des paramètres de la partie
	tour:=prem; 								// on initialise le premier tour selon le concurrent qui a été choisi pour jouer en premier
	nb_allumettes_initial:=nb_allumettes; 		// on enregistre le nombre d'allumettes au départ pour l'historique
	repeat 										// exécution à chaque tour
		affiche(nb_allumettes); 				// appel de la procédure d'affichage du nombre d'allumettes restantes
		jeualterne(tour); 						// appel de la procédure permettant de changer de joueur à chaque tour
		nbtours:=nbtours+1; 					// à chaque tour, on ajoute 1 tour au compteur de tours
	until (nb_allumettes=0) or (abandon); 		// arrêt de la boucle faisant jouer les participants jusqu'à la défaite ou l'abandon d'un joueur
	textcolor(10); // apport de couleur
	if tour='j' then // si le dernier tour a été joué par l'ordinateur ...
	begin
		writeln('Vous etes le meilleur!'); // ... indication que le joueur l'a emporté
		vainqueur:=nom; // on enregistre le vainqueur pour l'historique
	end	
	else // si le dernier tour a été joué par le joueur ...
	begin
		writeln('Ordi vous a battu!'); // ... indication de la défaite pour le joueur
		vainqueur:='Ordi'; // on enregistre le vainqueur pour l'historique
	end;	
	writeln;

	textcolor(15); // apport de couleur
	repeat // boucle de contrôle de la réponse concernant le voeu d'afficher l'historique	
		writeln('Voulez-vous voir l''historique de la partie? oui ou non');
		readln(rep); // lecture de la réponse du joueur
		if rep='non' then // si le joueur ne souhaite pas afficher l'historique ... 
		begin
			okrep:=true;
			writeln('D''accord!'); // ... on a compris
		end;
		if rep='oui' then // si le joueur veut connaître l'historique de la partie ...
		begin
			okrep:=true;
			clrscr; // ... on "nettoie" l'écran
			historique(nbtours,nb_allumettes_initial,vainqueur); // ... on fait appel à la procédure d'affichage de l'historique
		end;
		if (rep<>'oui') and (rep<>'non') then // si la réponse est inappropriée ...
		begin
			okrep:=false;
			writeln('Veuillez donner une reponse appropriee!'); // ... on le fait savoir au joueur
		end;
	until (okrep); // fin de la boucle de contrôle	
	writeln;
	
	repeat // boucle de contrôle de la réponse concernant le souhait de recommencer une partie	
		writeln('Voulez-vous rejouer? oui ou non');
		readln(reponse); // lecture de la réponse du joueur
		if reponse='non' then // si le joueur ne veut pas rejouer ... 
		begin
			okreponse:=true; // ... c'est ok
			writeln('Je vous souhaite une bonne continuation!'); // ... petit message poli
			writeln('Merci d''avoir joue au jeu des allumettes!');
			rejouer:=false; // ... on ne refait pas de partie
		end;
		if reponse='oui' then // si le joueur souhaite rejouer ...  
		begin
			okreponse:=true; // ... c'est d'accord
			rejouer:=true; // ... on relance une partie
		end;
		if (reponse<>'oui') and (reponse<>'non') then // si la réponse donnée n'est pas attendu ... 
		begin
			okreponse:=false; // demande de nouvelle réponse
			writeln('Veuillez donner une reponse correcte! Repondez ''oui'' ou ''non'' s''il vous plait!'); 
		end;
	until (okreponse); // fin de la boucle de contrôle de la réponse 
until (rejouer=false); // fin de la boucle permettant de rejouer
readln;		

END.

// fin de la tâche principale
