:- module(uriMachine, [uriMachine/2]).

:- use_module(schemeMachine).
:- use_module(userhostMachine).
:- use_module(portMachine).
:- use_module(pqfMachine).
:- use_module(zpqfMachine).

uriMachine(Chars, uri(mailto, Userinfo, Host, '80', [], [], [])) :-
	!,
    userhostMachine(Chars, Userinfo, Host, []),
	Userinfo \= [].
uriMachine(Chars, uri(news, [], Host, '80', [], [], [])) :-
	!,
    userhostMachine(Chars, '', Host, []),
	!, % Avoid considering Host as Userinfo.
	Host \= [].
uriMachine(Chars, uri(tel, Userinfo, [], '80', [], [], [])) :-
	!,
    userhostMachine(Chars, Userinfo, '', []),
	Userinfo \= [].
uriMachine(Chars, uri(fax, Userinfo, [], '80', [], [], [])) :-
	!,
    userhostMachine(Chars, Userinfo, '', []),
	Userinfo \= [].
uriMachine(Chars, uri(zos, Userinfo, Host, Port, Path, Query, Fragment)) :-
	!,
	append([/, /], TrimmedChars, Chars),
	!, % If it starts with "//", this becomes the only possible production.
    userhostMachine(TrimmedChars, Userinfo, Host, UserhostLeftover),
	!, % Avoid considering Host as Userinfo.
    portMachine(UserhostLeftover, Port, PortLeftover),
    zpqfMachine(PortLeftover, Path, Query, Fragment).
uriMachine(Chars, uri(zos, [], [], '80', Path, Query, Fragment)) :-
	!,
    zpqfMachine(Chars, Path, Query, Fragment).
uriMachine(Chars, uri(_, Userinfo, Host, Port, Path, Query, Fragment)) :-
	append([/, /], TrimmedChars, Chars),
	!, % If it starts with "//", this becomes the only possible production.
    userhostMachine(TrimmedChars, Userinfo, Host, UserhostLeftover),
	!, % Avoid considering Host as Userinfo.
    portMachine(UserhostLeftover, Port, PortLeftover),
    pqfMachine(PortLeftover, Path, Query, Fragment).
/**
 * The following version of this machine is needed only to not have a useless
 * false as a result when the URI follows the mailto scheme-syntax with
 * both Userinfo and Host present (when '@' is present).
 * Without it, it would be checked if the URI has a path and thus the false.
 */
uriMachine(Chars, uri(_, Userinfo, Host, '80', [], [], [])) :-
    userhostMachine(Chars, Userinfo, Host, []),
	Userinfo \= [],
	Host \= [],
	!.
uriMachine(Chars, uri(_, Userinfo, Host, '80', [], [], [])) :-
    userhostMachine(Chars, Userinfo, Host, []).
uriMachine(Chars, uri(_, [], [], '80', Path, Query, Fragment)) :-
    pqfMachine(Chars, Path, Query, Fragment).

% Due to the cut and the double productions for zos, only the production with
% authority is considered for zos.
% Possible solution may be to extract append, userhostMachine and portMachine
% into a separate authorityMachine, unify then the productions (zos and generic)
% with pqf machines.