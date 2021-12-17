:- module(pqfMachine, [pqfMachine/4]).

:- use_module(charUtils).
:- use_module(pathMachine).
:- use_module(qfMachine).

pqfMachine(Chars, Path, Query, Fragment) :-
	pathMachine(Chars, Path, Leftover),
	qfMachine(Leftover, Query, Fragment).
