:- use_module(schemeMachine).
:- use_module(userinfoMachine).
:- use_module(hostMachine).
:- use_module(portMachine).
:- use_module(pathMachine).
:- use_module(queryMachine).
:- use_module(fragmentMachine).

uri_parse(String, uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)) :-
    schemeMachine(String, Scheme, SchemeLeftover),
    userinfoMachine(SchemeLeftover, Userinfo, UserinfoLeftover),
    hostMachine(UserinfoLeftover, Host, HostLeftover),
    portMachine(HostLeftover, Port, PortLeftover),
    pathMachine(PortLeftover, Path, PathLeftover),
    queryMachine(PathLeftover, Query, QueryLeftover),
    fragmentMachine(QueryLeftover, Fragment, "").

% uri_parse(String, uri(Scheme, Host, Port, AfterHost, AfterPort, _, _)) :-
%     schemeMachine(String, Scheme, AfterScheme),
% 	hostMachine(AfterScheme, Host, AfterHost),
% 	portMachine(AfterHost, Port, AfterPort).

% consult('uri-parse.pl').
% uri_parse("whatever://maria.z@prova.host.dai:77", Uri).