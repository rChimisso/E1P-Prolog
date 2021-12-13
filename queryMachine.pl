:- module(queryMachine, [queryMachine/3]).

:- use_module(charUtils).
:- use_module(machineUtils).

initial(empty).
final(empty).
final(query).

delta(empty, Char, query) :- isQueryChar(Char), !.
delta(query, Char, query) :- isQueryChar(Char), !.

accept([], State, [], "") :-
	final(State),
	!.
accept(['#' | Rest], State, [], Leftover) :-
	final(State),
	string_chars(Leftover, Rest),
	!.
accept([Char | Chars], State, Query, Leftover) :-
	delta(State, Char, NewState),
	accept(Chars, NewState, RestQuery, Leftover),
	append([Char], RestQuery, Query).

queryMachine(String, Query, Leftover) :-
	initial(State),
	string_chars(String, Chars),
	accept(Chars, State, ValueList, Leftover),
	listToURIValue(ValueList, Query).
