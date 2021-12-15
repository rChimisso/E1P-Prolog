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
accept(['/' | Leftover], State, Port, Leftover) :-
	accept([], State, Port, _),
	!.
accept([':' | Rest], empty, Port, Leftover) :-
	accept(Rest, pStart, Port, Leftover),
	!.
accept([Char | Chars], State, Port, Leftover) :-
	delta(State, Char, NewState),
	accept(Chars, NewState, RestPort, Leftover),
	append([Char], RestPort, Port).

portMachine(Chars, Port, Leftover) :-
	initial(State),
	accept(Chars, State, ValueList, Leftover),
	listToURIValue(ValueList, Port).
