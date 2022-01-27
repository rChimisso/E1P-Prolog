:- module(pathMachine, [pathMachine/3]).

:- use_module(charUtils).

final(empty).
final(slash).
final(path).

delta(slash, Char, path) :- isIdentifierChar(Char), !.
delta(path, Char, path) :- isIdentifierChar(Char), !.
delta(path, /, separator) :- !.
delta(separator, Char, path) :- isIdentifierChar(Char), !.

accept([], State, [], []) :-
	final(State),
	!.
accept([? | Rest], State, [], [? | Rest]) :-
	final(State),
	!.
accept([# | Rest], State, [], [# | Rest]) :-
	final(State),
	!.
accept([/ | Rest], empty, Path, Leftover) :-
	!,
	accept(Rest, slash, Path, Leftover),
	!.
accept([Char | Chars], State, Path, Leftover) :-
	delta(State, Char, NewState),
	accept(Chars, NewState, RestPath, Leftover),
	append([Char], RestPath, Path).
/**
 * pathMachine(++Chars:atom[], -Path:atomic, -Leftover:atom[]) is semidet.
 * 
 * True when the list of characters initially has a valid URI path definition.
 */
pathMachine(Chars, Path, Leftover) :-
	accept(Chars, empty, ValueList, Leftover),
	listToURIValue(ValueList, Path).
