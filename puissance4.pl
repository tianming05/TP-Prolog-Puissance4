﻿﻿:- dynamic board/1.

%Methodes generales
incr(X, X1) :- X1 is X+1.
%ajoute X a la fin de la liste L
updateListe(X,L,L1):-L1=[L|X].
decr(X,X1):- X1 is X-1.

%Dini si une case X est vide : renvoie true si X est vide
caseLibre(Colonne,Ligne, Board):- nth0(Colonne,Board,Liste), nth0(Ligne,Liste,Val), var(Val).

%Vifie si la Colonne est valide:
%1-  0<Colonne<6
%2-  La Colonne n'est pas remplie
possible(Colonne,Board):- Colonne@>=0,Colonne@=<6, caseLibre(Colonne,5,Board).
possible(Colonne,Board):- writeln('Coup invalide, Veuillez rentrer une nouvelle colonne'), play().

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
 board(Board), % instanciate the board from the knowledge base
 displayBoard, % print it
 read(Colonne),
 possible(Colonne,Board),
 calculPosition(Colonne,0,BonneLigne,Board),
 playMove(Board,Colonne,BonneLigne,NewBoard,'o'),
 applyIt(Board,NewBoard),
 win('o',0),
 play().


%Retourne la Neme Colonne
getList(N,L):- board(B), nth0(N,B,L).


%%%% Print the value of the board at index N:
% if iths a variable, print  and x or o otherwise.
printVal(N,L) :-  nth0(N,L,Val), var(Val), write(' '), !.
printVal(N,L) :- nth0(N,L,Val), write(Val).

%%%% Implements MinMax Algorithm

choseBestMove(CurrentConfig,Computer,Move):-
	set_of(M,possible(M,CurrentConfig),Moves),
	chooseMove(Moves,CurrentBoard,1,1,(nil,-1000),(Move,Value)).

chooseMove([Move|Moves],CurrentBoard,Depth,Flag,Record,Best):-
	movePossible(Move,CurrentBoard,NewBoard),
	minmax(Depth,NewBoard,Flag,Move,Value),
	update(Move,Value,Record,Record1),
	chooseMove(Moves,CurrentBoard,Depth,Flag,Record1,Best).
chooseMove([],CurrentBoard,Depth,Flag,Record,Record).

minmax(0,CurrentBoard,Flag,Move,Value):-
	value(CurrentBoard,C),%% We are returning the final value
	Value:=C * Flag.

minmax(Depth,CurrentBoard,Flag,Move,Value):-
	set_of(M,possible(M,CurrentConfig),Moves),
	FlagBis:= -Flag,
	DepthBis:= Depth-1,
	chooseMove(Moves,CurrentBoard,DepthBis,FlagBis,(nil,-1000),(Move,Value)).

update(Move,Value,(MoveBis,ValueBis),(MoveBis,ValueBis)):-
	Value =< ValueBis.

update(Move,Value,(MoveBis,ValueBis),(Move,Value)):-
	Value > ValueBis.


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


%Si c'est au début
% caseWinTest(Board):- Board=[[P|_],[Q|_],[R|_],[S|_],_,_,_],P==Q,Q==R,R==S.
%caseWinH(Board):-
% Board=[_,[P|_],[Q|_],[R|_],[S|_],_,_],P==Q,Q==R,R==S. caseWinH(Board):-
% Board=[_,_,[P|_],[Q|_],[R|_],[S|_],_],P==Q,Q==R,R==S. caseWinH(Board):-
% Board=[_,_,_,[P|_],[Q|_],[R|_],[S|_]],P==Q,Q==R,R==S.
%

caseWinTest(L):-L=[P,Q,R,S,_,_,_],P==Q,Q==R,R==S.
caseWinTest(L):-L=[_,P,Q,R,S,_,_],P==Q,Q==R,R==S.
caseWinTest(L):-L=[_,_,P,Q,R,S,_],P==Q,Q==R,R==S.
caseWinTest(L):-L=[_,_,_,P,Q,R,S],P==Q,Q==R,R==S.
%caseWinH(N):-getLigne(N,L,0), caseWinTest(L),!.
%caseWinH(N):-incr(N,N1),N1@=<5,caseWinH(N1).

caseWinH([[X|_],[Y|_],[W|_],[Z|_],[U|_],[V|_],[T|_]],N):-caseWinTest([X,Y,W,Z,U,V,T]),!.
caseWinH([[_|A],[_|B],[_|C],[_|D],[_|E],[_|F],[_|G]],N):-incr(N,N1),N1@=<5,caseWinH([A,B,C,D,E,F,G],N1).


% caseWinH([[X|A],[Y|B],[W|C],[Z|D],E,F,G],Index):-Index@=<5,caseWinTest1([X,Y,W,Z,_,_,_]),incr(Index,Index1),caseWinH([A,B,C,D,E,F,G],Index1).
 %caseWinH([A,[X|B],[Y|C],[W|D],[Z|E],F,G],Index):-Index@=<5,caseWinTest2([X,Y,W,Z,_,_,_]),incr(Index,Index1),caseWinH([A,B,C,D,E,F,G],Index1).
 %caseWinH([A,B,[X|C],[Y|D],[W|E],[Z|F],G]):-(X\==Y;Y\==W;W\==Z),caseWinH([A,B,C,D,E,F,G]).
% caseWinH([A,B,C,[X|D],[Y|E],[W|F],[Z|G]]):-(X\==Y;Y\==W;W\==Z),caseWinH([A,B,C,D,E,F,G]).
%




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
