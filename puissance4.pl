:- dynamic board/1.

%Méthodes générales
incr(X, X1) :- X1 is X+1.
decr(X,X1):- X1 is X-1.

%Renvoie l'index d'une case à partir de la ligne L et de la colonne C.
indexCase(C,L,Index):- Index is C+(5-L)*7.

%Défini si une case X est vide : renvoie true si X est vide
caseLibre(Colonne,Ligne, Board):- nth0(Colonne,Board,Liste), nth0(Ligne,Liste,Val), var(Val).

%Vérifie si la Colonne est valide:
%1-  0<Colonne<6
%2-  La Colonne n'est pas remplie
possible(Colonne,Board):- Colonne@>=0,Colonne@=<6, caseLibre(Colonne,6,Board).
possible(Colonne,Board):-  writeln('Coup invalide, Veuillez rentrer une nouvelle colonne'), play().

%Trouve a quel endroit placer le pion en fonction de la colonne.
% retourne l'indice de la premiere case vide de la colonne
calculPosition(Colonne,LigneActuelle,LigneActuelle,Board):- caseLibre(Colonne,LigneActuelle,Board),!.
calculPosition(Colonne,LigneActuelle,BonneLigne,Board):- incr(LigneActuelle,LignePrecedente), calculPosition(Colonne,LignePrecedente,BonneLigne,Board).

%Jouer un pion a l'emplacement Move
playMove(Board,Colonne,Ligne,NewBoard,Player) :- nth0(Colonne,Board,Liste), nth0(Ligne,Liste,Player),Board=NewBoard, nth0(Colonne,NewBoard,Liste).

%Actualiser le plateau
applyIt(Board,NewBoard) :- retract(board(Board)), assert(board(NewBoard)).

play():-
 board(Board), % instanciate the board from the knowledge base
 displayBoard, % print it
 read(Colonne),
 possible(Colonne,Board),
 calculPosition(Colonne,0,BonneLigne,Board),
 playMove(Board,Colonne,BonneLigne,NewBoard,'x'),
 applyIt(Board,NewBoard),
 play().


%Retourne la Nème liste
getList(N,L):- board(B), nth0(N,B,L).

%%%% Print the value of the board at index N:
% if iths a variable, print  and x or o otherwise.
printVal(N,L) :-  nth0(N,L,Val), var(Val), write(' '), !.
printVal(N,L) :- nth0(N,L,Val), write(Val).

%%%% Implements MinMax Algorithm

choseBestMove(CurrentConfig,Computer,Move):-
	set_of(M,movePossible(CurrentConfig,M),Moves),
	chooseMove(Moves,CurrentConfig,1,1,(nil,-1000),(Move,Value)).

chooseMove([Move|Moves],CurrentConfig,Depth,Flag,Record,Best):-
	movePossible(Move,CurrentConfig,NewConfig),
	minmax(Depth,NewConfig,Flag,Move,Value).
	update(Move,Value,Record,Record1),
	chooseMove(Moves,CurrentConfig,Depth,Flag,Record1,Best).
chooseMove([],CurrentConfig,Depth,Flag,Record,Record).

minmax(0,CurrentConfig,Flag,Move,Value):-
	value(CurrentConfig,C),%% We are returning the final value 
	Value:=C * Flag.

minmax(Depth,CurrentConfig,Flag,Move,Value):-
	set_of(M,movePossible(CurrentConfig,M),Moves),
	FlagBis:=-Flag,
	DepthBis:=Depth-1,
	chooseMove(Moves,CurrentConfig,DepthBis,FlagBis,(nil,-1000),(Move,Value)).
	
update(Move,Value,(MoveBis,ValueBis),(MoveBis,ValueBis)):-
	Value <= ValueBis.

update(Move,Value,(MoveBis,ValueBis),(Move,Value)):-
	Value > ValueBis.	
	

displayBoard:-
 writeln('*-------------*'),

 getList(0,L),printVal(6,L),write('|'),getList(1,L1), printVal(6,L1),write('|'),getList(2,L2), printVal(6,L2),write('|'),getList(3,L3), printVal(6,L3),write('|'),getList(4,L4), printVal(6,L4),write('|'),getList(5,L5), printVal(6,L5),write('|'), getList(6,L6), printVal(6,L6), writeln('|'),

 getList(0,L),printVal(5,L),write('|'),getList(1,L1), printVal(5,L1),write('|'),getList(2,L2), printVal(5,L2),write('|'),getList(3,L3), printVal(5,L3),write('|'),getList(4,L4), printVal(5,L4),write('|'),getList(5,L5), printVal(5,L5),write('|'), getList(6,L6), printVal(5,L6), writeln('|'),

getList(0,L),printVal(4,L),write('|'),getList(1,L1), printVal(4,L1),write('|'),getList(2,L2), printVal(4,L2),write('|'),getList(3,L3), printVal(4,L3),write('|'),getList(4,L4), printVal(4,L4),write('|'),getList(5,L5), printVal(4,L5),write('|'), getList(6,L6), printVal(4,L6), writeln('|'),

 getList(0,L),printVal(3,L),write('|'),getList(1,L1), printVal(3,L1),write('|'),getList(2,L2), printVal(3,L2),write('|'),getList(3,L3), printVal(3,L3),write('|'),getList(4,L4), printVal(3,L4),write('|'),getList(5,L5), printVal(3,L5),write('|'), getList(6,L6), printVal(3,L6), writeln('|'),
 getList(0,L),printVal(2,L),write('|'),getList(1,L1), printVal(2,L1),write('|'),getList(2,L2), printVal(2,L2),write('|'),getList(3,L3), printVal(2,L3),write('|'),getList(4,L4), printVal(2,L4),write('|'),getList(5,L5), printVal(2,L5),write('|'), getList(6,L6), printVal(2,L6), writeln('|'),
 getList(0,L),printVal(1,L),write('|'),getList(1,L1), printVal(1,L1),write('|'),getList(2,L2), printVal(1,L2),write('|'),getList(3,L3), printVal(1,L3),write('|'),getList(4,L4), printVal(1,L4),write('|'),getList(5,L5), printVal(1,L5),write('|'), getList(6,L6), printVal(1,L6), writeln('|'),


 getList(0,L),printVal(0,L),write('|'),getList(1,L1), printVal(0,L1),write('|'),getList(2,L2), printVal(0,L2),write('|'),getList(3,L3), printVal(0,L3),write('|'),getList(4,L4), printVal(0,L4),write('|'),getList(5,L5), printVal(0,L5),write('|'), getList(6,L6), printVal(0,L6), writeln('|'),

 writeln('*-------------*').


 %%%% Start the game!
init :- length(Board,7), assert(board(Board)), play().

% Calculate the score of each player
scoreColunm4([],_,0,[]).
scoreColunm4([P|L],P,S,[V|Val]):-scoreColunm4(L,P,S1,Val),S is S1+V.
scoreColunm4([H|L],P,S,[V|Val]):-H\=P,scoreColunm4(L,P,S,Val).

score([],_,0,[]).
score([H|L],P,S,[V|Val]):-score(L,P,S1,Val),scoreColunm4(H,P,S2,V),S is S1+S2.
