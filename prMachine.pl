:- module(prMachine, [prMachine/2]).

:- use_module(authorityMachine).
:- use_module(pqfMachine).
:- use_module(zpqfMachine).

/**
 * prMachine(++Chars:char[], -Uri:uri) is semidet.
 * 
 * True when the given URI is valid.  
 * This machine is specific for URIs that can have the Path field
 * (they are Path Related).
 */
prMachine(Chars, uri(zos, Userinfo, Host, Port, Path, Query, Fragment)) :-
	!,
	authorityMachine(Chars, Userinfo, Host, Port, Leftover),
    zpqfMachine(Leftover, Path, Query, Fragment).
prMachine(Chars, uri(_, Userinfo, Host, Port, Path, Query, Fragment)) :-
	authorityMachine(Chars, Userinfo, Host, Port, Leftover),
    pqfMachine(Leftover, Path, Query, Fragment).
