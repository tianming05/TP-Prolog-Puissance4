﻿:- dynamic board/1.

%Methodes generales
incr(X, X1) :- X1 is X+1.

%Dini si une case X est vide : renvoie true si X est vide
caseLibre(Colonne,Ligne, Board):- nth0(Colonne,Board,Liste), nth0(Ligne,Liste,Val), var(Val).

%Vifie si la Colonne est valide:
%1-  0<Colonne<6
%2-  La Colonne n'est pas remplie
possible(Colonne,Board):- Colonne@>=0,Colonne@=<6, caseLibre(Colonne,5,Board).
possible(Colonne,Board):- writeln('Coup invalide, Veuillez rentrer une nouvelle colonne'), play().

findGoodColonne([],[],_).

findGoodColonne([H|Q],[H|A],Board):-
 caseLibre(H,5,Board),
 findGoodColonne(Q,A,Board).
findGoodColonne([_|Q],T,Board):-findGoodColonne(Q,T,Board).

%Trouve a quel endroit placer le pion en fonction de la colonne.
% retourne l'indice de la premiere case vide de la colonne
calculPosition(Colonne,LigneActuelle,LigneActuelle,Board):- caseLibre(Colonne,LigneActuelle,Board),!.
calculPosition(Colonne,LigneActuelle,BonneLigne,Board):- incr(LigneActuelle,LigneSuivante), calculPosition(Colonne,LigneSuivante,BonneLigne,Board).

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
 win('x',0),
 play2().

play2():-
 board(Board),
 displayBoard,
 copy_term(Board,CurrentBoard),
 choseBestMove(CurrentBoard,Colonne),
 calculPosition(Colonne,0,BonneLigne,Board),
 playMove(Board,Colonne,BonneLigne,NewBoard,'o'),
 applyIt(Board,NewBoard),
 win('o',0),
 play().


%Retourne la Neme Colonne
getList(N,L):- board(B), nth0(N,B,L).

getList(N,L,Board):-nth0(N,Board,L).


%%%% Print the value of the board at index N:
% if iths a variable, print  and x or o otherwise.
printVal(N,L) :-  nth0(N,L,Val), var(Val), write(' '), !.
printVal(N,L) :- nth0(N,L,Val), write(Val).

%%%% Implements MinMax Algorithm
choseBestMove(CurrentBoard,BestColonne):-

	findGoodColonne([0,1,2,3,4,5,6],Colonnes,CurrentBoard),
	evaluate_and_choose(Colonnes,CurrentBoard,0,-1000,1000,BestCurrentColonne,BestColonne,1).

evaluate_and_choose([Colonne|Colonnes],CurrentBoard,Depth,Alpha,Beta,BestCurrentColonne,BestColonne,Flag) :-
	colonnePossible(Colonne,CurrentBoard,NewBoard,Flag),
        Flagl is -Flag,
	alpha_beta(Depth,NewBoard,Alpha,Beta,Colonne,Flag,Value),
	Valuel is -Value,
        board(Board),
	cutoff(Colonne,Value,D,Alpha,Beta,Colonnes,Board,BestCurrentColonne,BestColonne,Flag).
evaluate_and_choose([],_CurrentBoard,_Depth,_Alpha,_Beta,Move,Move,_Flag).

alpha_beta(0,Position,_Alpha,_Beta,_,Flag,Value):-
	V = [[3,4,5,5,4,3],[4,6,8,8,6,4],[5,8,11,11,8,5],[7,10,13,13,10,7],[5,8,11,11,8,5],[4,6,8,8,6,4],[3,4,5,5,4,3]],
	player(Flag,P),
	score(6,P,C,V,Position),%% We are returning the final value
	Value is C * Flag.

alpha_beta(D,Position,Alpha,Beta,Move,Flag,Value):-
	findGoodColonne([0,1,2,3,4,5,6],Moves,Position),
	Alphal is -Beta,
	Betal is -Alpha,
	Dl is D-1,
	evaluate_and_choose(Moves,Position,Dl,Alphal,Betal,4,Move,Flag).

colonnePossible(Colonne,CurrentBoard,NewBoard,Flag):-
    Flag=(-1),
	calculPosition(Colonne,0,BonneLigne,CurrentBoard),
	playMove(CurrentBoard,Colonne,BonneLigne,NewBoard,'x').

colonnePossible(Colonne,CurrentBoard,NewBoard,Flag):-
	Flag=1 ,
    calculPosition(Colonne,0,BonneLigne,CurrentBoard),
	playMove(CurrentBoard,Colonne,BonneLigne,NewBoard,'o').

player(Flag,'o'):-
	Flag=1 .

player(Flag,'x'):-
	Flag=(-1).

cutoff(Colonne,Value,_D,_Alpha,Beta,_Colonnes,_Position,_Colonne1,Colonne,_Flag):-
	Value >= Beta,!.
cutoff(Colonne,Value,D,Alpha,Beta,Colonnes,Position,_Colonne1,BestColonne,Flag) :-
	Alpha < Value, Value < Beta,!,
	evaluate_and_choose(Colonnes,Position,D,Value,Beta,Colonne,BestColonne,Flag).

cutoff(_Colonne, Value,D,Alpha,Beta,Colonnes,Position,Colonne1,BestColonne,Flag):-
	Value =< Alpha,!,
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

% Calculate the score of player P
scoreColunm4([],_,0,[]).
scoreColunm4([H|L],P,S,[V|Val]):-H==P,scoreColunm4(L,P,S1,Val),S is S1+V.
scoreColunm4([H|L],P,S,[V|Val]):-H\==P,scoreColunm4(L,P,S,Val).

score(-1,_,0,[],_).
score(N,P,S,[V|Val],B):-getList(N,L,B),score(N1,P,S1,Val,B),scoreColunm4(L,P,S2,V),S is S1+S2,N is N1+1.

%Horizontal
caseWinTest(L):-L=[P,Q,R,S,_,_,_],P==Q,Q==R,R==S.
caseWinTest(L):-L=[_,P,Q,R,S,_,_],P==Q,Q==R,R==S.
caseWinTest(L):-L=[_,_,P,Q,R,S,_],P==Q,Q==R,R==S.
caseWinTest(L):-L=[_,_,_,P,Q,R,S],P==Q,Q==R,R==S.

caseWinH([[X|_],[Y|_],[W|_],[Z|_],[U|_],[V|_],[T|_]],N):-caseWinTest([X,Y,W,Z,U,V,T]),!.
caseWinH([[_|A],[_|B],[_|C],[_|D],[_|E],[_|F],[_|G]],N):-incr(N,N1),N1@=<5,caseWinH([A,B,C,D,E,F,G],N1).


%%%% Print the value of the board at index N:
% if its a variable, print ? and x or o otherwise.
printVal(N) :- board(B), nth0(N,B,Val), var(Val), write('?'), !.
printVal(N) :- board(B), nth0(N,B,Val), write(Val).

%Vertical Winning configuration
caseWinV(L):-L=[P,Q,R,S,_,_],P==Q,Q==R,R==S.
caseWinV(L):-L=[_,_,P,Q,R,S],P==Q,Q==R,R==S.
caseWinV(L):-L=[_,P,Q,R,S,_],P==Q,Q==R,R==S.

winV(N):-getList(N,L),caseWinV(L),!.
winV(N):-incr(N,N1),N1@=<6,winV(N1).

%Diag
caseDiagWin(L):-L=[[A|_],[_,B|_],[_,_,C|_],[_,_,_,D|_],_,_,_],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,A,_,_,_,_],[_,_,B,_,_,_],[_,_,_,C,_,_],[_,_,_,_,D,_],[_,_,_,_,_,_],[_,_,_,_,_,_]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,A,_,_,_],[_,_,_,B,_,_],[_,_,_,_,C,_],[_,_,_,_,_,D],[_,_,_,_,_,_]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,_,_,_,_],[A,_,_,_,_,_],[_,B,_,_,_,_],[_,_,C,_,_,_],[_,_,_,D,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,A,_,_,_,_],[_,_,B,_,_,_],[_,_,_,C,_,_],[_,_,_,_,D,_],[_,_,_,_,_,_]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,A,_,_,_],[_,_,_,B,_,_],[_,_,_,_,C,_],[_,_,_,_,_,D]],A==B,B==C,C==D.

caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,_,_,_,_,_],[A,_,_,_,_,_],[_,B,_,_,_,_],[_,_,C,_,_,_],[_,_,_,D,_,_],[_,_,_,_,_,_]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,A,_,_,_,_],[_,_,B,_,_,_],[_,_,_,C,_,_],[_,_,_,_,D,_]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,A,_,_,_,_],[_,_,B,_,_,_],[_,_,_,C,_,_],[_,_,_,_,D,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,_,A,_,_,_],[_,_,_,B,_,_],[_,_,_,_,C,_],[_,_,_,_,_,D],[_,_,_,_,_,_],[_,_,_,_,_,_]],A==B,B==C,C==D.

caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,A,_,_,_],[_,_,_,B,_,_],[_,_,_,_,C,_],[_,_,_,_,_,D]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,A,_,_,_],[_,_,_,B,_,_],[_,_,_,_,C,_],[_,_,_,_,_,D],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]],A==B,B==C,C==D.

caseDiagWin(L):-L=[[_,_,_,_,_,A],[_,_,_,_,B,_],[_,_,_,C,_,_],[_,_,D,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,_,_,_,A,_],[_,_,_,B,_,_],[_,_,C,_,_,_],[_,D,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,A,_,_],[_,_,B,_,_,_],[_,C,_,_,_,_],[D,_,_,_,_,_],[_,_,_,_,_,_]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,_,_,_,_,A],[_,_,_,_,B,_],[_,_,_,C,_,_],[_,_,D,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,A,_],[_,_,_,B,_,_],[_,_,C,_,_,_],[_,D,_,_,_,_],[_,_,_,_,_,_]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,A,_,_],[_,_,B,_,_,_],[_,C,_,_,_,_],[D,_,_,_,_,_]],A==B,B==C,C==D.

caseDiagWin(L):-L=[[_,_,_,_,A,_],[_,_,_,B,_,_],[_,_,C,_,_,_],[_,D,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,_,_,A,_,_],[_,_,B,_,_,_],[_,C,_,_,_,_],[D,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,A],[_,_,_,_,B,_],[_,_,_,C,_,_],[_,_,D,_,_,_],[_,_,_,_,_,_]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,A,_],[_,_,_,B,_,_],[_,_,C,_,_,_],[_,D,_,_,_,_]],A==B,B==C,C==D.

caseDiagWin(L):-L=[[_,_,_,A,_,_],[_,_,B,_,_,_],[_,C,_,_,_,_],[D,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_]],A==B,B==C,C==D.
caseDiagWin(L):-L=[[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,_],[_,_,_,_,_,A],[_,_,_,_,B,_],[_,_,_,C,_,_],[_,_,D,_,_,_]],A==B,B==C,C==D.

winDiag(L):-caseDiagWin(L),!.


win(P,L):- board(B), caseWinH(B,0),write(P),writeln(' win').
win(P,L):-winV(L),write(P),writeln(' win').
win(P,L):- board(B),winDiag(B),writeln('D win').
win(P,L):-write('').
%coupGagnant(Joueur,Grille avant,Grille apres)
% coupGagnant(P,GrilleAvant,GrilleApres):-
% jouerUnCoup(GrilleAvant,GrilleApres,P,),win(P,GrilleApres).

