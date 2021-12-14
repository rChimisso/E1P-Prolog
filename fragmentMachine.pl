:- module(fragmentMachine, [fragmentMachine/2]).

:- use_module(charUtils).
:- use_module(machineUtils).

initial(empty).
final(empty).
final(fragment).

delta(empty, Char, fragment) :- isAllowedChar(Char), !.
delta(fragment, Char, fragment) :- isAllowedChar(Char), !.

accept([], State, []) :-
	final(State),
	!.
accept([Char | Chars], State, Fragment) :-
	delta(State, Char, NewState),
	accept(Chars, NewState, RestFragment),
	append([Char], RestFragment, Fragment).

fragmentMachine(String, Fragment) :-
	initial(State),
	string_chars(String, Chars),
	accept(Chars, State, ValueList),
	listToURIValue(ValueList, Fragment).
