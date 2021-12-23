:- module(prMachine, [prMachine/2]).

:- use_module(authorityMachine).
:- use_module(pqfMachine).
:- use_module(zpqfMachine).

/**
 * 
 */
prMachine(Chars, uri(zos, Userinfo, Host, Port, Path, Query, Fragment)) :-
	!,
	authorityMachine(Chars, Userinfo, Host, Port, Leftover),
    zpqfMachine(Leftover, Path, Query, Fragment).
% prMachine(Chars, uri(http, Userinfo, Host, Port, Path, Query, Fragment)) :-
% 	!,
% 	authorityMachine(Chars, Userinfo, Host, Port, Leftover),
%   pqfMachine(Leftover, Path, Query, Fragment).
% prMachine(Chars, uri(https, Userinfo, Host, Port, Path, Query, Fragment)) :-
% 	!,
% 	authorityMachine(Chars, Userinfo, Host, Port, Leftover),
%   pqfMachine(Leftover, Path, Query, Fragment).
prMachine(Chars, uri(_, Userinfo, Host, Port, Path, Query, Fragment)) :-
	authorityMachine(Chars, Userinfo, Host, Port, Leftover),
    pqfMachine(Leftover, Path, Query, Fragment).
