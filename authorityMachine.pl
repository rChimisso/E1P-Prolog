:- module(authorityMachine, [authorityMachine/5]).

:- use_module(userhostMachine).
:- use_module(portMachine).

/**
 * authorityMachine(
 *	++Chars:atom[],
 *	-Userinfo:atomic,
 *	-Host:atomic,
 *	-Port:atomic,
 *	-Leftover:atom[]
 * ) is nondet.
 * 
 * True when the list of characters initially has a valid URI authority
 * definition or none at all.
 */
authorityMachine(Chars, Userinfo, Host, Port, Leftover) :-
	append([/, /], TrimmedChars, Chars),
	!,
	userhostMachine(TrimmedChars, Userinfo, Host, UserhostLeftover),
	!, % Avoid considering Host as Userinfo.
	Host \= [],
	portMachine(UserhostLeftover, Port, Leftover).
authorityMachine([/ | Chars], [], [], 80, [/ | Chars]).
