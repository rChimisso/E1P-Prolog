:- module(portMachine, [portMachine/3]).

:- use_module(charUtils).

final(empty).
final(port).

delta(pStart, Char, port) :- isDigitChar(Char), !.
delta(port, Char, port) :- isDigitChar(Char), !.

accept([], port, [], []) :- !.
accept([], empty, ['8', '0'], []) :- !.
accept(['/' | Rest], State, Port, ['/' | Rest]) :-
	accept([], State, Port, []),
	!.
accept([':' | Chars], empty, Port, Leftover) :-
	accept(Chars, pStart, Port, Leftover),
	!.
accept([Char | Chars], State, Port, Leftover) :-
	delta(State, Char, NewState),
	accept(Chars, NewState, RestPort, Leftover),
	append([Char], RestPort, Port).
/**
 * portMachine(++Chars:char[], -Port:atomic, -Leftover:char[]) is semidet.
 * 
 * True when the list of characters initially has a valid URI port definition.
 */
portMachine(Chars, Port, Leftover) :-
	accept(Chars, empty, ValueList, Leftover),
	listToURIValue(ValueList, AtomPort),
	atom_number(AtomPort, Port).
