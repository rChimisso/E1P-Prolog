:- module(userhostMachine, [userhostMachine/3]).

:- use_module(charUtils).
:- use_module(machineUtils).

initial(empty).
final(userinfo).
final(host).

delta(empty, Char, host) :- isHostIdentifierChar(Char).
delta(host, Char, host) :- isHostIdentifierChar(Char).
delta(host, '.', separator).
delta(separator, Char, host) :- isHostIdentifierChar(Char).
delta(userinfo, '@', at) :- !.
delta(at, Char, host) :- isHostIdentifierChar(Char).
delta(empty, Char, userinfo) :- isIdentifierChar(Char).
delta(userinfo, Char, userinfo) :- isIdentifierChar(Char).

accept([], State, [], "") :-
	final(State),
	!.
accept([':' | Rest], host, [], Leftover) :-
	string_chars(Leftover, Rest),
	!.
accept(['/' | Rest], host, [], Leftover) :-
	string_chars(Leftover, Rest),
	!.
accept([Char | Chars], State, Userhost, Leftover) :-
	delta(State, Char, NewState),
	accept(Chars, NewState, RestUserhost, Leftover),
	append([Char], RestUserhost, Userhost).

userhostMachine(String, Userhost, Leftover) :-
	initial(State),
	string_chars(String, Chars),
	accept(Chars, State, ValueList, Leftover),
	listToURIValue(ValueList, Userhost).
