:- module(uriMachine, [uriMachine/7]).

:- use_module(schemeMachine).
:- use_module(userhostMachine).
:- use_module(portMachine).
:- use_module(pqfMachine).
:- use_module(machineUtils).

uriMachine(String, Userinfo, Host, Port, Path, Query, Fragment) :-
	startsWith("//", String, TrimmedLeftover),
	!,
    userhostMachine(TrimmedLeftover, Userinfo, Host, UserhostLeftover),
    portMachine(UserhostLeftover, Port, PortLeftover),
    pqfMachine(PortLeftover, Path, Query, Fragment).
uriMachine(String, Userinfo, Host, '80', [], [], []) :-
    userhostMachine(String, Userinfo, Host, "").
uriMachine(String, [], [], '80', Path, Query, Fragment) :-
    pqfMachine(String, Path, Query, Fragment).