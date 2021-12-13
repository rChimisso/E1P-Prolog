:- module(fragmentMachine, [fragmentMachine/3]).

:- use_module(charUtils).
:- use_module(machineUtils).

initial(empty).
final(empty).
final(fragment).

delta(empty, Char, fragment) :- isAllowedChar(Char), !.
delta(fragment, Char, fragment) :- isAllowedChar(Char), !.

accept([], State, [], "") :-
	final(State),
	!.
accept([Char | Chars], State, Fragment, Leftover) :-
	delta(State, Char, NewState),
	accept(Chars, NewState, RestFragment, Leftover),
	append([Char], RestFragment, Fragment).

fragmentMachine(String, Fragment, Leftover) :-
	initial(State),
	string_chars(String, Chars),
	accept(Chars, State, ValueList, Leftover),
	listToURIValue(ValueList, Fragment).
