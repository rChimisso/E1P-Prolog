:- module(zpqfMachine, [zpqfMachine/4]).

:- use_module(zPathMachine).
:- use_module(qfMachine).

/**
 * zpqfMachine(
 *	++Chars:char[],
 *	-Path:atomic,
 *	-Query:atomic,
 *	-Fragment:atomic
 * ) is semidet.
 * 
 * True when the list of characters initially has a valid URI definition for
 * zOS Path, Query and Fragment in that order.
 */
zpqfMachine(Chars, Path, Query, Fragment) :-
	zPathMachine(Chars, ID44, ID8, Path, Leftover),
	write_length(ID44, _, [max_length(44)]),
	write_length(ID8, _, [max_length(8)]),
	qfMachine(Leftover, Query, Fragment).
