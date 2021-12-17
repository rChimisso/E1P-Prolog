:- module(pathMachine, [pathMachine/3]).

:- use_module(charUtils).

initial(empty).
final(empty).
final(slash).
final(path).

delta(slash, Char, path) :- isIdentifierChar(Char), !.
delta(empty, Char, path) :- isIdentifierChar(Char), !.
delta(path, Char, path) :- isIdentifierChar(Char), !.
delta(path, '/', separator) :- !.
delta(separator, Char, path) :- isIdentifierChar(Char), !.

accept([], State, [], []) :-
	final(State),
	!.
accept(['?' | Rest], State, [], ['?' | Rest]) :-
	final(State),
	!.
accept(['#' | Rest], State, [], ['#' | Rest]) :-
	final(State),
	!.
accept(['/' | Chars], empty, Path, Leftover) :-
	accept(Chars, slash, Path, Leftover),
	!.
accept([Char | Chars], State, Path, Leftover) :-
	delta(State, Char, NewState),
	accept(Chars, NewState, RestPath, Leftover),
	append([Char], RestPath, Path).

pathMachine(Chars, Path, Leftover) :-
	initial(State),
	accept(Chars, State, ValueList, Leftover),
	listToURIValue(ValueList, Path).
