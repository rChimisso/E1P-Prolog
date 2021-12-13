:- module(userinfoMachine, [userinfoMachine/3]).

:- use_module(charUtils).
:- use_module(machineUtils).

initial(empty).
final(empty).
final(userinfo).

delta(empty, Char, userinfo) :- isIdentifierChar(Char), !.
delta(userinfo, Char, userinfo) :- isIdentifierChar(Char), !.

accept([], State, [], "") :-
	final(State),
	!.
accept(['@' | Rest], State, [], Leftover) :-
	final(State),
	string_chars(Leftover, Rest),
	!.
accept([Char | Chars], State, Scheme, Leftover) :-
	delta(State, Char, NewState),
	accept(Chars, NewState, RestScheme, Leftover),
	append([Char], RestScheme, Scheme).

userinfoMachine(String, Scheme, Leftover) :-
	initial(State),
	string_chars(String, Chars),
	accept(Chars, State, ValueList, Leftover),
	listToURIValue(ValueList, Scheme).
