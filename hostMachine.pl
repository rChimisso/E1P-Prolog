:- module(hostMachine, [hostMachine/3]).

:- use_module(charUtils).
:- use_module(machineUtils).

initial(empty).
final(empty).
final(host).

delta(empty, Char, host) :- isHostIdentifierChar(Char), !.
delta(host, Char, host) :- isHostIdentifierChar(Char), !.
delta(host, '.', separator) :- !.
delta(separator, Char, host) :- isHostIdentifierChar(Char), !.

accept([], State, [], "") :-
	final(State),
	!.
accept([':' | Rest], State, [], Leftover) :-
	final(State),
	string_chars(Leftover, Rest),
	!.
accept([Char | Chars], State, Host, Leftover) :-
	delta(State, Char, NewState),
	accept(Chars, NewState, RestHost, Leftover),
	append([Char], RestHost, Host).

hostMachine(String, Host, Leftover) :-
	initial(State),
	string_chars(String, Chars),
	accept(Chars, State, ValueList, Leftover),
	listToURIValue(ValueList, Host).
