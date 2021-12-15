:- module(schemeMachine, [schemeMachine/3]).

:- use_module(charUtils).
:- use_module(machineUtils).

initial(empty).
final(scheme).

delta(empty, Char, scheme) :- isIdentifierChar(Char), !.
delta(scheme, Char, scheme) :- isIdentifierChar(Char), !.

accept([':' | Leftover], State, [], Leftover) :-
	final(State),
	!.
accept([Char | Chars], State, Scheme, Leftover) :-
	delta(State, Char, NewState),
	accept(Chars, NewState, RestScheme, Leftover),
	append([Char], RestScheme, Scheme).

schemeMachine(Chars, Scheme, Leftover) :-
	initial(State),
	accept(Chars, State, ValueList, Leftover),
	listToURIValue(ValueList, Scheme).
