﻿:- dynamic board/1.

%Methodes generales
incr(X, X1) :- X1 is X+1.
clear():-retractall(board(_)).

%Dini si une case X est vide : renvoie true si X est vide
caseLibre(Colonne,Ligne, Board):- nth0(Colonne,Board,Liste), nth0(Ligne,Liste,Val), var(Val).
%Verifie si le board est rempli
keepPlaying(N,Board):- caseLibre(N,5,Board).
keepPlaying(N,Board):-N@=<5,incr(N,N1),keepPlaying(N1,Board).
keepPlaying(_,_):-write('Match nul, fin de la partie !').

%Verifie si la Colonne est valide:
%1-  0<Colonne<6
%2-  La Colonne n'est pas remplie
possible(Colonne,Board,_):- Colonne@>=0,Colonne@=<6, caseLibre(Colonne,5,Board).
possible(_,_,Player):- writeln('Coup invalide, Veuillez rentrer une nouvelle colonne'), play(Player).

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

play(_):-board(Board),(win('o',0,Board);not(keepPlaying(0,Board))),displayBoard,clear(),!.
play(Player):-
 board(Board), % instanciate the board from the knowledge base
 displayBoard, % print it
 read(Colonne),
 possible(Colonne,Board,Player),
 calculPosition(Colonne,0,BonneLigne,Board),
 playMove(Board,Colonne,BonneLigne,NewBoard,Player),
 applyIt(Board,NewBoard),
 play2('o').

play2(_):-board(Board),(win('x',0,Board);not(keepPlaying(0,Board))),displayBoard,clear(),!.
play2(Player):-
 board(Board),
 displayBoard,
 copy_term(Board,CurrentBoard),
 choseBestMove(CurrentBoard,Colonne),
 calculPosition(Colonne,0,BonneLigne,Board),
 playMove(Board,Colonne,BonneLigne,NewBoard,Player),
 applyIt(Board,NewBoard),
 play('x').


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
        (  coupGagnantPossible(Colonnes,CurrentBoard,BestColonne);
            coupPerdant(Colonnes,CurrentBoard,BestColonne);
	evaluate_and_choose(Colonnes,CurrentBoard,0,-1000,1000,BestCurrentColonne,BestColonne,1)).

coupPerdant([Colonne|_],CurrentBoard,BestColonne):- colonnePossible(Colonne,CurrentBoard,NewBoard,-1), coupGagnant(0,NewBoard), BestColonne is Colonne.
coupPerdant([_|Colonnes],CurrentBoard,BestColonne) :- coupPerdant(Colonnes,CurrentBoard,BestColonne).

coupGagnantPossible([Colonne|_],CurrentBoard,BestColonne):- colonnePossible(Colonne,CurrentBoard,NewBoard,1), coupGagnant(0,NewBoard), BestColonne is Colonne.
coupGagnantPossible([_|Colonnes],CurrentBoard,BestColonne) :- coupGagnantPossible(Colonnes,CurrentBoard,BestColonne).


evaluate_and_choose([Colonne|Colonnes],CurrentBoard,Depth,Alpha,Beta,BestCurrentColonne,BestColonne,Flag) :-
	colonnePossible(Colonne,CurrentBoard,NewBoard,Flag),
        Flagl is -Flag,
	alpha_beta(Depth,NewBoard,Alpha,Beta,Colonne,Flag,Value),
	Valuel is -Value,
        board(Board),
	cutoff(Colonne,Value,D,Alpha,Beta,Colonnes,Board,BestCurrentColonne,BestColonne,Flag).
evaluate_and_choose([],_CurrentBoard,_Depth,_Alpha,_Beta,Move,Move,_Flag).

alpha_beta(0,Position,_Alpha,_Beta,_,Flag,Value):-
	random(-100,100,Value).

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
init :- length(Board,7), assert(board(Board)),writeln('-------------------PUISSANCE 4--------------- '),writeln('Le but du jeu est d\'aligner 4 symboles indentiques verticalment,horizontalement ou en diagonale. \nPour jouer, saisissez le numéro de la colonne dans laquelle vous voulez jouer (compris entre 0 et 6) suivi d\'un point. \nExemple :(0. vous permet de jouer dans la 1ère colonne)\n \n \n'),play('x').


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

%Vertical Winning configuration
caseWinV(L):-L=[P,Q,R,S,_,_],P==Q,Q==R,R==S.
caseWinV(L):-L=[_,_,P,Q,R,S],P==Q,Q==R,R==S.
caseWinV(L):-L=[_,P,Q,R,S,_],P==Q,Q==R,R==S.

winV(N,B):-getList(N,L,B),caseWinV(L),!.
winV(N,B):-incr(N,N1),N1@=<6,winV(N1,B).

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


win(P,L,B):- caseWinH(B,L),write('\n \n \n Le joueur '),write(P),writeln(' a gagne (alignement Horizontal)').
win(P,L,B):-winV(L,B),write('\n \n \n  Le joueur '),write(P),writeln(' a gagne (alignement Vertical)').
win(P,_,B):- winDiag(B),write('\n \n \n  Le joueur '),write(P),writeln(' a gagne (alignement Diagonal)').

coupGagnant(_,B):- caseWinH(B,0).
coupGagnant(L,B):-winV(L,B).
coupGagnant(_,B):- winDiag(B).
%coupGagnant(Joueur,Grille avant,Grille apres)
% coupGagnant(P,GrilleAvant,GrilleApres):-
% jouerUnCoup(GrilleAvant,GrilleApres,P,),win(P,GrilleApres).

