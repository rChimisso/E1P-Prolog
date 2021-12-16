:- module(uriMachine, [uriMachine/7]).

:- use_module(schemeMachine).
:- use_module(userhostMachine).
:- use_module(portMachine).
:- use_module(pqfMachine).

uriMachine(Chars, Userinfo, Host, Port, Path, Query, Fragment) :-
	append([/, /], TrimmedChars, Chars),
	!,
    userhostMachine(TrimmedChars, Userinfo, Host, UserhostLeftover),
	!,
    portMachine(UserhostLeftover, Port, PortLeftover),
    pqfMachine(PortLeftover, Path, Query, Fragment).
uriMachine(Chars, Userinfo, Host, '80', [], [], []) :-
    userhostMachine(Chars, Userinfo, Host, []).
uriMachine(Chars, [], [], '80', Path, Query, Fragment) :-
    pqfMachine(Chars, Path, Query, Fragment).
