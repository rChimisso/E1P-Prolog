:- module(schemeMachine, [schemeMachine/3]).

:- use_module(charUtils).
:- use_module(machineUtils).

initial(empty).
final(scheme).

delta(empty, Char, scheme) :- isIdentifierChar(Char), !.
delta(scheme, Char, scheme) :- isIdentifierChar(Char), !.

accept([':' | Rest], State, [], Leftover) :-
	final(State),
	string_chars(Leftover, Rest),
	!.
accept([Char | Chars], State, Scheme, Leftover) :-
	delta(State, Char, NewState),
	accept(Chars, NewState, RestScheme, Leftover),
	append([Char], RestScheme, Scheme).

schemeMachine(String, Scheme, Leftover) :-
	initial(State),
	string_chars(String, Chars),
	accept(Chars, State, ValueList, Leftover),
	listToURIValue(ValueList, Scheme).
