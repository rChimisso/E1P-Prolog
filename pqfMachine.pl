:- module(pqfMachine, [pqfMachine/4]).

:- use_module(pathMachine).
:- use_module(qfMachine).

/**
 * pqfMachine(
 *	++Chars:char[],
 *	-Path:atomic,
 *	-Query:atomic,
 *	-Fragment:atomic
 * ) is semidet.
 * 
 * True when the list of characters initially has a valid URI definition for
 * Path, Query and Fragment in that order.
 */
pqfMachine(Chars, Path, Query, Fragment) :-
	pathMachine(Chars, Path, Leftover),
	qfMachine(Leftover, Query, Fragment).
