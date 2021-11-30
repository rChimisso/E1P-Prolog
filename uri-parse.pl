:- use_module(charUtils).
:- use_module(schemeMachine).

final(uri).

delta(scheme, ':', uri) :- !.
delta(uri, Char, uri) :- isAllowedChar(Char), !.

accept([Char | Chars], State) :-
	delta(State, Char, NewState),
	accept(Chars, NewState).
accept([], State) :- final(State).

% uriMachine(String).

uri_parse(String) :- schemeMachine(String), !.

% uri_parse(URIString, uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)).

% How to merge?