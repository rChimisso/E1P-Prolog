:- use_module(schemeMachine).
:- use_module(uriMachine).

uri_parse(String, uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)) :-
    schemeMachine(String, Scheme, SchemeLeftover),
	uriMachine(SchemeLeftover, Userinfo, Host, Port, Path, Query, Fragment).

% uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)

% Port può essere presente solo con // iniziali.
% Dopo host e userinfo può esserci qualcosa solo con // iniziali.

% consult('uri-parse.pl').
% uri_parse("whatever://maria.z@prova.host.dai:77", Uri).