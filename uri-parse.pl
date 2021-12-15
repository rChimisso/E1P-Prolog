:- use_module(schemeMachine).
:- use_module(uriMachine).

uri_parse(String, uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)) :-
	string_chars(String, Chars),
    schemeMachine(Chars, Scheme, SchemeLeftover),
	uriMachine(SchemeLeftover, Userinfo, Host, Port, Path, Query, Fragment).

% uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)

% Problemi:
% Per le produzioni mailto (3) viene stampato un false superfluo per via del controllo su path.
% Per le produzioni del tipo "scheme://userhost/" viene stampato un false superfluo per via della indeterminazione di userhostMachine.
% Per le produzioni del tipo "scheme://userhost" viene stampato "userhost" sia come host (corretto) che come userinfo (sbagliato).

% Possibili soluzioni:
% Aggiungere delta a uriMachine.
% Aggiungere accept a uriMachine.

% Aggiunte future:
% Se possibile, sfoltimento codice e diminuizione duplicazione.

% consult('uri-parse.pl').
% uri_parse("whatever://maria.z@prova.host.dai:77", Uri).