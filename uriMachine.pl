:- module(uriMachine, [uriMachine/2]).

:- use_module(schemeMachine).
:- use_module(userhostMachine).
:- use_module(prMachine).

/**
 * noPathScheme(++Scheme:atom) is semidet.
 * 
 * True when Scheme is not one in [zos, http, https].
 */
noPathScheme(Scheme) :-
	Scheme \= zos,
	Scheme \= http,
	Scheme \= https.
/**
 * uriMachine(++Chars:atom[], -Uri:uri) is nondet.
 * 
 * True when the given list of characters forms a valid URI.
 * The URI Scheme field must be ground at call-time for a correct execution.
 */
uriMachine([], uri(_, [], [], 80, [], [], [])) :- !.
uriMachine(Chars, uri(mailto, Userinfo, Host, 80, [], [], [])) :-
	!,
    userhostMachine(Chars, Userinfo, Host, []),
	Userinfo \= [].
uriMachine(Chars, uri(news, [], Host, 80, [], [], [])) :-
	!,
    userhostMachine(Chars, '', Host, []),
	!. % Avoid considering Host as Userinfo.
uriMachine(Chars, uri(tel, Userinfo, [], 80, [], [], [])) :-
	!,
    userhostMachine(Chars, Userinfo, '', []).
uriMachine(Chars, uri(fax, Userinfo, [], 80, [], [], [])) :-
	!,
    userhostMachine(Chars, Userinfo, '', []).
uriMachine(Chars, uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)) :-
	prMachine(Chars, uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)),
	!.
uriMachine(Chars, uri(Scheme, Userinfo, Host, 80, [], [], [])) :-
	noPathScheme(Scheme),
    userhostMachine(Chars, Userinfo, Host, []).