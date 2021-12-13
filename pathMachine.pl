:- module(pathMachine, [pathMachine/3]).

:- use_module(charUtils).
:- use_module(machineUtils).

initial(empty).
final(empty).
final(path).

delta(empty, Char, path) :- isIdentifierChar(Char), !.
delta(path, Char, path) :- isIdentifierChar(Char), !.
delta(path, '/', separator) :- !.
delta(separator, Char, path) :- isIdentifierChar(Char), !.

accept([], State, [], "") :-
	final(State),
	!.
accept(['?' | Rest], State, [], Leftover) :-
	final(State),
	string_chars(Leftover, Rest),
	!.
accept([Char | Chars], State, Path, Leftover) :-
	delta(State, Char, NewState),
	accept(Chars, NewState, RestPath, Leftover),
	append([Char], RestPath, Path).

pathMachine(String, Path, Leftover) :-
	initial(State),
	string_chars(String, Chars),
	accept(Chars, State, ValueList, Leftover),
	listToURIValue(ValueList, Path).
