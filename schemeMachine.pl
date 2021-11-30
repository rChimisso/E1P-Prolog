:- module(schemeMachine, [schemeMachine/1]).

:- use_module(charUtils).

initial(empty).
final(scheme).

delta(empty, Char, scheme) :- isIdentifierChar(Char), !.
delta(scheme, Char, scheme) :- isIdentifierChar(Char), !.
delta(_, _, error).

accept([Char | Chars], State) :-
	delta(State, Char, NewState),
	accept(Chars, NewState).
accept([], State) :- final(State).

schemeMachine(String) :-
	initial(State),
	string_chars(String, Chars),
	accept(Chars, State).
