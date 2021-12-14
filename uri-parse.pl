:- use_module(schemeMachine).
:- use_module(userhostMachine).
:- use_module(portMachine).
:- use_module(pathMachine).
:- use_module(queryMachine).
:- use_module(fragmentMachine).

uri_parse(String, uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)) :-
    schemeMachine(String, Scheme, SchemeLeftover),
    userhostMachine(SchemeLeftover, Userinfo, Host, UserhostLeftover),
    portMachine(UserhostLeftover, Port, PortLeftover),
    pathMachine(PortLeftover, Path, PathLeftover),
    queryMachine(PathLeftover, Query, QueryLeftover),
    fragmentMachine(QueryLeftover, Fragment, "").

% uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)

% consult('uri-parse.pl').
% uri_parse("whatever://maria.z@prova.host.dai:77", Uri).