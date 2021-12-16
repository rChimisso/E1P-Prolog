:- module(portMachine, [portMachine/3]).

:- use_module(charUtils).
:- use_module(machineUtils).

initial(empty).
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

portMachine(Chars, Port, Leftover) :-
	initial(State),
	accept(Chars, State, ValueList, Leftover),
	listToURIValue(ValueList, Port).
