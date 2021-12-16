:- module(pqfMachine, [pqfMachine/4]).

:- use_module(charUtils).
:- use_module(machineUtils).

initial(empty).
final(empty).
final(slash).
final(path).
final(query).
final(fragment).

delta(slash, Char, path) :- isIdentifierChar(Char), !.

delta(empty, Char, path) :- isIdentifierChar(Char), !.
delta(path, Char, path) :- isIdentifierChar(Char), !.
delta(separator, Char, path) :- isIdentifierChar(Char), !.

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
accept(['/' | Chars], path, Path, Query, Fragment) :-
	accept(Chars, separator, RestPath, Query, Fragment),
	!,
	append(['/'], RestPath, Path).
accept([Char | Chars], State, Path, Query, Fragment) :-
	delta(State, Char, path),
	accept(Chars, path, RestPath, Query, Fragment),
	!,
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

pqfMachine(Chars, Path, Query, Fragment) :-
	initial(State),
	accept(Chars, State, PathList, QueryList, FragmentList),
	listToURIValue(PathList, Path),
	listToURIValue(QueryList, Query),
	listToURIValue(FragmentList, Fragment).
