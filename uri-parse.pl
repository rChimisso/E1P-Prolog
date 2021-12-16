:- use_module(schemeMachine).
:- use_module(uriMachine).

uri_parse(String, uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)) :-
	string_chars(String, Chars),
    schemeMachine(Chars, Scheme, SchemeLeftover),
	uriMachine(SchemeLeftover, Userinfo, Host, Port, Path, Query, Fragment).

% uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)

% Problemi:
% Per le produzioni mailto (3) viene stampato un false superfluo per via del controllo su path.

% Aggiunte future:
% Se possibile, sfoltimento codice e diminuizione duplicazione.

% consult('uri-parse.pl').
% uri_parse("whatever://maria.z@prova.host.dai:77", Uri).
