:- dynamic board/1.

incr(X, X1) :- X1 is X+1.
decr(X,X1):-X1 is X-1.

%Renvoie l'index d'une case à partir de la ligne L et de la colonne C.
indexCase(C,L,Index):- Index is C+L*7.

%Défini si une case est vide : renvoie true si X est vide
caseLibre(X, Board):- nth0(X,Board,Val), var(Val).

%Trouve a quel endroit placer le pion en fonction de la colonne.
% retourne l'indice de la premiere case vide de la colonne

calculPosition(Colonne,LigneActuelle,LigneActuelle,Board):- indexCase(Colonne,LigneActuelle,Index), caseLibre(Index,Board),!.
calculPosition(Colonne,LigneActuelle,BonneLigne,Board):- decr(LigneActuelle,LignePrecedente), calculPosition(Colonne,LignePrecedente,BonneLigne,Board).
playMove(Board,Move,NewBoard,Player) :- Board=NewBoard, nth0(Move,NewBoard,Player).
applyIt(Board,NewBoard) :- retract(board(Board)), assert(board(NewBoard)).

play():-
 board(Board), % instanciate the board from the knowledge base
 displayBoard, % print it
 read(Colonne),
 calculPosition(Colonne,5,BonneLigne,Board),
 indexCase(Colonne,BonneLigne,Index),
 playMove(Board,Index,NewBoard,'x'),
 applyIt(Board,NewBoard),
 play().



%%%% Print the value of the board at index N:
% if its a variable, print  and x or o otherwise.
printVal(N) :- board(B), nth0(N,B,Val), var(Val), write(' '), !.
printVal(N) :- board(B), nth0(N,B,Val), write(Val).


displayBoard:-
 writeln('*-------------*'),
 printVal(0),write('|'), printVal(1),write('|'), printVal(2),write('|'),printVal(3),write('|'), printVal(4),write('|'),printVal(5),write('|'), printVal(6), writeln('|'),
  printVal(7),write('|'), printVal(8),write('|'), printVal(9),write('|'),printVal(10),write('|'), printVal(11),write('|'), printVal(12),write('|'), printVal(13), writeln('|'),
   printVal(14),write('|'), printVal(15),write('|'), printVal(16),write('|'),printVal(17),write('|'), printVal(18),write('|'),printVal(19),write('|'), printVal(20), writeln('|'),
   printVal(21),write('|'), printVal(22),write('|'), printVal(23),write('|'),printVal(24),write('|'), printVal(25),write('|'),printVal(26),write('|'), printVal(27), writeln('|'),
   printVal(28),write('|'), printVal(29),write('|'), printVal(30),write('|'),printVal(31),write('|'), printVal(32),write('|'),printVal(33),write('|'), printVal(34), writeln('|'),
   printVal(35),write('|'), printVal(36),write('|'), printVal(37),write('|'),printVal(38),write('|'), printVal(39),write('|'),printVal(40),write('|'), printVal(41), writeln('|'),

 writeln('*-------------*').


 %%%% Start the game!
init :- length(Board,42), assert(board(Board)), play().
