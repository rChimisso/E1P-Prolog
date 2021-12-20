:- module(uriMachine, [uriMachine/2]).

:- use_module(schemeMachine).
:- use_module(userhostMachine).
:- use_module(prMachine).

noPathScheme(Scheme) :-
	Scheme \= zos,
	Scheme \= http,
	Scheme \= https.

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
/**
 * The following version of this machine is needed only to not have a useless
 * false as a result when the URI follows the mailto scheme-syntax with
 * both Userinfo and Host present (when '@' is present).
 * Without it, it would be checked if the URI has Path and thus the false.
 */
uriMachine(Chars, uri(Scheme, Userinfo, Host, '80', [], [], [])) :-
	noPathScheme(Scheme),
    userhostMachine(Chars, Userinfo, Host, []),
	Userinfo \= [],
	Host \= [],
	!.
uriMachine(Chars, uri(Scheme, Userinfo, Host, '80', [], [], [])) :-
	noPathScheme(Scheme),
    userhostMachine(Chars, Userinfo, Host, []).
uriMachine(Chars, uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)) :-
	prMachine(Chars, uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)).
