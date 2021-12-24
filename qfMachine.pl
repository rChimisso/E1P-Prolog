:- module(qfMachine, [qfMachine/3]).

:- use_module(charUtils).

final(empty).
final(query).
final(fragment).

delta(qStart, Char, query) :- isQueryChar(Char), !.
delta(query, Char, query) :- isQueryChar(Char), !.
delta(fStart, Char, fragment) :- isAllowedChar(Char), !.
delta(fragment, Char, fragment) :- isAllowedChar(Char), !.

accept([], State, [], []) :-
	final(State),
	!.
accept([? | Chars], empty, Query, Fragment) :-
	accept(Chars, qStart, Query, Fragment),
	!.
accept([# | Chars], State, [], Fragment) :-
	State \= fragment,
	final(State),
	accept(Chars, fStart, _, Fragment),
	!.
accept([Char | Chars], State, Query, Fragment) :-
	delta(State, Char, query),
	accept(Chars, query, RestQuery, Fragment),
	!,
	append([Char], RestQuery, Query).
accept([Char | Chars], State, Query, Fragment) :-
	delta(State, Char, fragment),
	accept(Chars, fragment, Query, RestFragment),
	!,
	append([Char], RestFragment, Fragment).
/**
 * qfMachine(++Chars:atom[], -Query:atomic, -Fragment:atomic) is semidet.
 * 
 * True when the list of characters initially has a valid URI definition for
 * Query and Fragment in that order.
 */
qfMachine(Chars, Query, Fragment) :-
	accept(Chars, empty, QueryList, FragmentList),
	listToURIValue(QueryList, Query),
	listToURIValue(FragmentList, Fragment).
