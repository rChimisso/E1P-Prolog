:- module(pqfZosMachine, [pqfZosMachine/4]).

:- use_module(charUtils).

initial(empty).
final(id44).
final(path).
final(query).
final(fragment).

delta(slash, Char, id44) :- isAlnumChar(Char), !.

delta(empty, Char, id44) :- isAlnumChar(Char), !.
delta(id44, Char, id44) :- isAlnumChar(Char), !.
delta(id8Start, Char, id8) :- isAlnumChar(Char), !.
delta(id8, Char, id8) :- isAlnumChar(Char), !.

delta(qStart, Char, query) :- isQueryChar(Char), !.
delta(query, Char, query) :- isQueryChar(Char), !.

delta(fStart, Char, fragment) :- isAllowedChar(Char), !.
delta(fragment, Char, fragment) :- isAllowedChar(Char), !.

accept([], State, [], [], []) :-
	final(State),
	!.
accept(['/' | Chars], empty, Path, Query, Fragment) :-
	accept(Chars, slash, Path, Query, Fragment),
	!.
accept(['?' | Chars], State, [], Query, Fragment) :-
	State \= query,
	State \= fragment,
	final(State),
	accept(Chars, qStart, _, Query, Fragment),
	!.
accept(['#' | Chars], State, [], [], Fragment) :-
	State \= fragment,
	final(State),
	accept(Chars, fStart, _, _, Fragment),
	!.
accept(['(' | Chars], id44, Path, Query, Fragment) :-
	accept(Chars, id8Start, RestPath, Query, Fragment),
	!,
	append(['('], RestPath, Path).
accept([')' | Chars], id8, Path, Query, Fragment) :-
	accept(Chars, path, RestPath, Query, Fragment),
	!,
	append([')'], RestPath, Path).
accept([Char | Chars], State, Path, Query, Fragment) :-
	delta(State, Char, id44),
	accept(Chars, id44, RestPath, Query, Fragment),
	!,
	length(RestPath, Length),
	Length =< 53, % 44 + 8 + 1, 1 is '('.
	append([Char], RestPath, Path).
accept([Char | Chars], State, Path, Query, Fragment) :-
	delta(State, Char, id8),
	accept(Chars, id8, RestPath, Query, Fragment),
	!,
	length(RestPath, Length),
	Length =< 8,
	append([Char], RestPath, Path).
accept([Char | Chars], State, Path, Query, Fragment) :-
	delta(State, Char, query),
	accept(Chars, query, Path, RestQuery, Fragment),
	!,
	append([Char], RestQuery, Query).
accept([Char | Chars], State, Path, Query, Fragment) :-
	delta(State, Char, fragment),
	accept(Chars, fragment, Path, Query, RestFragment),
	!,
	append([Char], RestFragment, Fragment).

pqfZosMachine(Chars, Path, Query, Fragment) :-
	initial(State),
	accept(Chars, State, PathList, QueryList, FragmentList),
	listToURIValue(PathList, Path),
	listToURIValue(QueryList, Query),
	listToURIValue(FragmentList, Fragment).
