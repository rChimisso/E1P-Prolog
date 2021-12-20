:- module(zPathMachine, [zPathMachine/5]).

:- use_module(charUtils).

initial(empty).
final(empty).
final(id44).
final(path).

delta(slash, Char, id44) :- isAlnumChar(Char), !.
delta(empty, Char, id44) :- isAlnumChar(Char), !.
delta(id44, Char, id44) :- isAlnumChar(Char), !.
delta(id44, '.', separator) :- !.
delta(separator, Char, id44) :- isAlnumChar(Char), !.
delta(id44, '(', id8Start) :- !.
delta(id8Start, Char, id8) :- isAlnumChar(Char), !.
delta(id8, Char, id8) :- isAlnumChar(Char), !.

accept([], State, '', '', [], []) :-
	final(State),
	!.
accept([')' | Rest], id8, '', '', [')'], Rest) :- !.
accept(['?' | Rest], State, '', '', [], ['?' | Rest]) :-
	final(State),
	!.
accept(['#' | Rest], State, '', '', [], ['#' | Rest]) :-
	final(State),
	!.
accept(['/' | Chars], empty, ID44, ID8, Path, Leftover) :-
	accept(Chars, slash, ID44, ID8, Path, Leftover),
	!.
accept([Char | Chars], State, ID44, ID8, Path, Leftover) :-
	delta(State, Char, id44),
	accept(Chars, id44, RestID44, ID8, RestPath, Leftover),
	!,
	atom_concat(Char, RestID44, ID44),
	append([Char], RestPath, Path).
accept([Char | Chars], State, ID44, ID8, Path, Leftover) :-
	delta(State, Char, separator),
	accept(Chars, separator, RestID44, ID8, RestPath, Leftover),
	!,
	atom_concat(Char, RestID44, ID44),
	append([Char], RestPath, Path).
accept([Char | Chars], State, ID44, ID8, Path, Leftover) :-
	delta(State, Char, id8),
	accept(Chars, id8, ID44, RestID8, RestPath, Leftover),
	!,
	atom_concat(Char, RestID8, ID8),
	append([Char], RestPath, Path).
accept([Char | Chars], State, ID44, ID8, Path, Leftover) :-
	delta(State, Char, NewState),
	accept(Chars, NewState, ID44, ID8, RestPath, Leftover),
	append([Char], RestPath, Path).
/**
 * zPathMachine(
	++Chars:char[],
	Path:atomic,
	-Leftover:char[]
 * ) is semidet.
 * 
 * True when the list of characters initially has a valid URI zOS specific
 * path definition, but without any constraint on ID44 and ID8 length.
 */
zPathMachine(Chars, ID44, ID8, Path, Leftover) :-
	initial(State),
	accept(Chars, State, ID44, ID8, ValueList, Leftover),
	listToURIValue(ValueList, Path).
