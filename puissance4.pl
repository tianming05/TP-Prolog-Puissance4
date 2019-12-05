:- dynamic board/1.

%Mhodes gales
incr(X, X1) :- X1 is X+1.
decr(X,X1):- X1 is X-1.

%Renvoie l'index d'une case �partir de la ligne L et de la colonne C.
indexCase(C,L,Index):- Index is C+(5-L)*7.

%Dini si une case X est vide : renvoie true si X est vide
caseLibre(Colonne,Ligne, Board):- nth0(Colonne,Board,Liste), nth0(Ligne,Liste,Val), var(Val).

%Vifie si la Colonne est valide:
%1-  0<Colonne<6
%2-  La Colonne n'est pas remplie
possible(Colonne,Board):- Colonne@>=0,Colonne@=<6, caseLibre(Colonne,5,Board).
possible(Colonne,Board):-  writeln('Coup invalide, Veuillez rentrer une nouvelle colonne'),play().

findGoodColonne([],[],_).

findGoodColonne([H|Q],[H|A],Board):-
 caseLibre(H,5,Board),
 findGoodColonne(Q,A,Board).

%Trouve a quel endroit placer le pion en fonction de la colonne.
% retourne l'indice de la premiere case vide de la colonne
calculPosition(Colonne,LigneActuelle,LigneActuelle,Board):- caseLibre(Colonne,LigneActuelle,Board),!.
calculPosition(Colonne,LigneActuelle,BonneLigne,Board):- incr(LigneActuelle,LignePrecedente), calculPosition(Colonne,LignePrecedente,BonneLigne,Board).

%Jouer un pion a l'emplacement Colonne,Ligne
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
 playIA().

playIA():-
 board(Board),
 displayBoard,
 copy_term(Board,CurrentBoard),
 choseBestMove(CurrentBoard,Colonne),
 calculPosition(Colonne,0,BonneLigne,Board),
 playMove(Board,Colonne,BonneLigne,NewBoard,'o'),
 applyIt(Board,NewBoard),
 play().


%Retourne la Ne liste
getList(N,L):- board(B), nth0(N,B,L).

%%%% Print the value of the board at index N:
% if iths a variable, print  and x or o otherwise.
printVal(N,L) :-  nth0(N,L,Val), var(Val), write(' '), !.
printVal(N,L) :- nth0(N,L,Val), write(Val).

%%%% Implements MinMax Algorithm
choseBestMove(CurrentBoard,BestColonne):-
        findGoodColonne([0,1,2,3,4,5,6],Colonnes,CurrentBoard),
	evaluate_and_choose(Colonnes,CurrentBoard,1,-1000,1000,BestCurrentColonne,BestColonne,1).

evaluate_and_choose([Colonne|Colonnes],CurrentBoard,Depth,Alpha,Beta,BestCurrentColonne,BestColonne,Flag) :-
	colonnePossible(Colonne,CurrentBoard,NewBoard,Flag),
	alpha_beta(Depth,NewBoard,Alpha,Beta,Colonne,Value,Flag),
	Value1 is -Value,
	cutoff(Colonne,Value1,D,Alpha,Beta,Colonnes,CurrentBoard,BestCurrentColonne,BestColonne,Flag).

evaluate_and_choose([],CurrentBoard,Depth,Alpha,Beta,Move,(Move,Alpha),Flag).

alpha_beta(0,Position,Alpha,Beta,_,Flag,Value):-
	V = [[3,4,5,5,4,3],[4,6,8,8,6,4],[5,8,11,11,8,5],[7,10,13,13,10,7],[5,8,11,11,8,5],[4,6,8,8,6,4],[3,4,5,5,4,3]],
	player(Flag,P),
	score(Position,P,C,V),%% We are returning the final value
	Value is C*Flag.

alpha_beta(D,Position,Alpha,Beta,Move,Flag,Value):-
	findGoodColonne([0,1,2,3,4,5,6],Moves,Position),
	Alphal is -Beta,
	Betal is -Alpha,
    Flagl is -Flag,
	D1 is D-1,
	evaluate_and_choose(Moves,Position,D1,Alpha1,Beta1,nil,(Move,Value),Flagl).

colonnePossible(Colonne,CurrentBoard,NewBoard,Flag):-
        Flag=(-1),
	calculPosition(Colonne,0,BonneLigne,CurrentBoard),
	playMove(CurrentBoard,Colonne,BonneLigne,NewBoard,'x').

colonnePossible(Colonne,CurrentBoard,NewBoard,Flag):-
        calculPosition(Colonne,0,BonneLigne,CurrentBoard),
	playMove(CurrentBoard,Colonne,BonneLigne,NewBoard,'o').

player(Flag,'o'):-
	Flag==1.

player(Flag,'x'):-
	Flag==(-1).

cutoff(Colonne,Value,D,Alpha,Beta,Colonnes,Position,Colonne1,(Colonne,Value),Flag):-
	Value > Beta.
cutoff(Colonne,Value,D,Alpha,Beta,Colonnes,Position,Colonne1,BestColonne,Flag) :-
	Alpha < Value, Value < Beta,
	evaluate_and_choose(Colonnes,Position,D,Value,Beta,Colonne,BestColonne,Flag).
cutoff(Colonne, Value,D,Alpha,Beta,Colonnes,Position,Colonne1,BestColonne,Flag):-
	Value <Alpha,
	evaluate_and_choose(Colonnes,Position,D,Alpha,Beta,Colonne1,BestColonne,Flag).

displayBoard:-
 writeln('*-------------*'),


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

%Horizontal
caseHorizontalWin(X,[[X|_],[X|_],[X|_],[X|_],_,_,_]).
caseHorizontalWin(X,[_,[X|_],[X|_],[X|_],[X|_],_,_]).
caseHorizontalWin(X,[_,_,[X|_],[X|_],[X|_],[X|_],_]).
caseHorizontalWin(X,[_,_,_,[X|_],[X|_],[X|_],[X|_]]).
caseHorizontalWin(J,[[X|A],[Y|B],[W|C],[Z|D],E,F,G]):-(X\==Y;Y\==W;W\==Z),caseHorizontalWin(J,[A,B,C,D,E,F,G]).
caseHorizontalWin(J,[A,[X|B],[Y|C],[W|D],[Z|E],F,G]):-(X\==Y;Y\==W;W\==Z),caseHorizontalWin(J,[A,B,C,D,E,F,G]).
caseHorizontalWin(J,[A,B,[X|C],[Y|D],[W|E],[Z|F],G]):-(X\==Y;Y\==W;W\==Z),caseHorizontalWin(J,[A,B,C,D,E,F,G]).
caseHorizontalWin(J,[A,B,C,[X|D],[Y|E],[W|F],[Z|G]]):-(X\==Y;Y\==W;W\==Z),caseHorizontalWin(J,[A,B,C,D,E,F,G]).
winH(P,L):-caseHorizontalWin(P,L).


%%%% Print the value of the board at index N:
% if its a variable, print ? and x or o otherwise.
printVal(N) :- board(B), nth0(N,B,Val), var(Val), write('?'), !.
printVal(N) :- board(B), nth0(N,B,Val), write(Val).
%Winning configuration
caseWinV(X,[X,X,X,X,_,_]).
caseWinV(X,[_,X,X,X,X,_]).
caseWinV(X,[_,_,X,X,X,X]).
winV(P,[H|L]):-caseWinV(P,H).
winV(P,[H|L]):-winV(L,P).


%Diag
caseDiagWin(X,[[X,_,_,_,_,_],[_,X,_,_,_,_],[_,_,X,_,_,_],[_,_,_,X,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]]).
caseDiagWin(X,[[_,_,_,_,_,_],[_,X,_,_,_,_],[_,_,X,_,_,_],[_,_,_,X,_,_],[_,_,_,_,X,_],[_,_,_,_,_,_],[_,_,_,_,_,_]]).
caseDiagWin(X,[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,X,_,_,_],[_,_,_,X,_,_],[_,_,_,_,X,_],[_,_,_,_,_,X],[_,_,_,_,_,_]]).
caseDiagWin(X,[[_,_,_,_,_,_],[X,_,_,_,_,_],[_,X,_,_,_,_],[_,_,X,_,_,_],[_,_,_,X,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]]).
caseDiagWin(X,[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,X,_,_,_,_],[_,_,X,_,_,_],[_,_,_,X,_,_],[_,_,_,_,X,_],[_,_,_,_,_,_]]).
caseDiagWin(X,[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,X,_,_,_],[_,_,_,X,_,_],[_,_,_,_,X,_],[_,_,_,_,_,X]]).

caseDiagWin(X,[[_,_,_,_,_,_],[_,_,_,_,_,_],[X,_,_,_,_,_],[_,X,_,_,_,_],[_,_,X,_,_,_],[_,_,_,X,_,_],[_,_,_,_,_,_]]).
caseDiagWin(X,[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,X,_,_,_,_],[_,_,X,_,_,_],[_,_,_,X,_,_],[_,_,_,_,X,_]]).
caseDiagWin(X,[[_,X,_,_,_,_],[_,_,X,_,_,_],[_,_,_,X,_,_],[_,_,_,_,X,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]]).
caseDiagWin(X,[[_,_,_,_,_,_],[_,_,X,_,_,_],[_,_,_,X,_,_],[_,_,_,_,X,_],[_,_,_,_,_,X],[_,_,_,_,_,_],[_,_,_,_,_,_]]).

caseDiagWin(X,[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,X,_,_,_],[_,_,_,X,_,_],[_,_,_,_,X,_],[_,_,_,_,_,X]]).
caseDiagWin(X,[[_,_,X,_,_,_],[_,_,_,X,_,_],[_,_,_,_,X,_],[_,_,_,_,_,X],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]]).

caseDiagWin(X,[[_,_,_,_,_,X],[_,_,_,_,X,_],[_,_,_,X,_,_],[_,_,X,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]]).
caseDiagWin(X,[[_,_,_,_,_,_],[_,_,_,_,X,_],[_,_,_,X,_,_],[_,_,X,_,_,_],[_,X,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]]).
caseDiagWin(X,[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,X,_,_],[_,_,X,_,_,_],[_,X,_,_,_,_],[X,_,_,_,_,_],[_,_,_,_,_,_]]).
caseDiagWin(X,[[_,_,_,_,_,_],[_,_,_,_,_,X],[_,_,_,_,X,_],[_,_,_,X,_,_],[_,_,X,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]]).
caseDiagWin(X,[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,X,_],[_,_,_,X,_,_],[_,_,X,_,_,_],[_,X,_,_,_,_],[_,_,_,_,_,_]]).
caseDiagWin(X,[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,X,_,_],[_,_,X,_,_,_],[_,X,_,_,_,_],[X,_,_,_,_,_]]).

caseDiagWin(X,[[_,_,_,_,X,_],[_,_,_,X,_,_],[_,_,X,_,_,_],[_,X,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]]).
caseDiagWin(X,[[_,_,_,_,_,_],[_,_,_,X,_,_],[_,_,X,_,_,_],[_,X,_,_,_,_],[X,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]]).
caseDiagWin(X,[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,X],[_,_,_,_,X,_],[_,_,_,X,_,_],[_,_,X,_,_,_],[_,_,_,_,_,_]]).
caseDiagWin(X,[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,X,_],[_,_,_,X,_,_],[_,_,X,_,_,_],[_,X,_,_,_,_]]).

caseDiagWin(X,[[_,_,_,X,_,_],[_,_,X,_,_,_],[_,X,_,_,_,_],[X,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]]).
caseDiagWin(X,[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,X],[_,_,_,_,X,_],[_,_,_,X,_,_],[_,_,X,_,_,_]]).

winDiag(P,L):-caseDiagWin(P,L).

%win(P,L):- winH(P,L),writeln('H win').
win(P,L):-winV(P,L),writeln('V win').
win(P,L):-winDiag(P,L),writeln('D win').

%coupGagnant(Joueur,Grille avant,Grille apres)
% coupGagnant(P,GrilleAvant,GrilleApres):-
% jouerUnCoup(GrilleAvant,GrilleApres,P,),win(P,GrilleApres).




















