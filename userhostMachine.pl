:- module(userhostMachine, [userhostMachine/4]).

:- use_module(charUtils).

initial(empty).
final(userinfo).
final(host).

delta(empty, Char, host) :- isHostIdentifierChar(Char).
delta(host, Char, host) :- isHostIdentifierChar(Char).
delta(host, '.', separator).
delta(separator, Char, host) :- isHostIdentifierChar(Char).
delta(at, Char, host) :- isHostIdentifierChar(Char).
delta(empty, Char, userinfo) :- isIdentifierChar(Char).
delta(userinfo, Char, userinfo) :- isIdentifierChar(Char).

accept([], State, [], [], []) :-
	final(State),
	!.
accept([':' | Rest], host, [], [], [':' | Rest]) :- !.
accept(['/' | Rest], host, [], [], ['/' | Rest]) :- !.
accept(['@' | Chars], userinfo, [], Host, Leftover) :-
	accept(Chars, at, _, Host, Leftover),
	!.
accept([Char | Chars], State, Userinfo, Host, Leftover) :-
	delta(State, Char, NewState),
	NewState \= userinfo,
	accept(Chars, NewState, Userinfo, RestHost, Leftover),
	append([Char], RestHost, Host).
accept([Char | Chars], State, Userinfo, Host, Leftover) :-
	delta(State, Char, userinfo),
	accept(Chars, userinfo, RestUserinfo, Host, Leftover),
	append([Char], RestUserinfo, Userinfo).
/**
 * userhostMachine(
 *	++Chars:char[],
 *	-Userinfo:atomic,
 *	-Host:atomic,
 *  -Leftover:char[]
 * ) is semidet.
 * 
 * True when the list of characters initially has a valid URI definition for
 * Userinfo and/or Host.
 */
userhostMachine(Chars, Userinfo, Host, Leftover) :-
	initial(State),
	accept(Chars, State, UserinfoList, HostList, Leftover),
	listToURIValue(UserinfoList, Userinfo),
	listToURIValue(HostList, Host).
