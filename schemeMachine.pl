:- module(schemeMachine, [schemeMachine/3]).

:- use_module(charUtils).

delta(empty, Char, scheme) :- isIdentifierChar(Char), !.
delta(scheme, Char, scheme) :- isIdentifierChar(Char), !.

accept([: | Leftover], scheme, [], Leftover) :- !.
accept([Char | Chars], State, Scheme, Leftover) :-
	delta(State, Char, NewState),
	accept(Chars, NewState, RestScheme, Leftover),
	append([Char], RestScheme, Scheme).
/**
 * schemeMachine(++Chars:atom[], -Scheme:atomic, -Leftover:atom[]) is semidet.
 * 
 * True when the list of characters initially has a valid URI scheme definition.
 */
schemeMachine(Chars, Scheme, Leftover) :-
	accept(Chars, empty, ValueList, Leftover),
	listToURIValue(ValueList, Scheme).
