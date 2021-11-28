:- module(stringUtilities, [
	includes/2,
	includesNot/2
]).

includes(String, Characters) :-
	string_codes(String, StringCodes),
	string_chars(Chars, Characters),
	string_codes(Chars, CharCodes),
	has(StringCodes, CharCodes).

has(StringCodes, [CharCode | _]) :-
	isIn(CharCode, StringCodes),
	!.
has(StringCodes, [_ | CharCodes]) :- has(StringCodes, CharCodes).

isIn(CharCode, [CharCode | _]) :- !.
isIn(CharCode, [_ | StringCodes]) :- isIn(CharCode, StringCodes).

includesNot(String, Characters) :-
	string_codes(String, StringCodes),
	string_chars(Chars, Characters),
	string_codes(Chars, CharCodes),
	hasNot(StringCodes, CharCodes).

hasNot([_ | _], []) :- !.
hasNot(StringCodes, [CharCode | CharCodes]) :-
	isNotIn(CharCode, StringCodes),
	hasNot(StringCodes, CharCodes).

isNotIn(_, []) :- !.
isNotIn(CharCode, [StringCode | StringCodes]) :-
	CharCode \= StringCode,
	isNotIn(CharCode, StringCodes).
