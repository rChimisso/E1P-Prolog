:- module(machineUtils, [
	listToURIValue/2,
	startsWith/3
]).

listToURIValue([], []) :- !.
listToURIValue(List, Value) :- atom_chars(Value, List).

startsWith(Prefix, String, Trimmed) :-
	string_chars(Prefix, PChars),
	string_chars(String, SChars),
	append(PChars, Trimmed, SChars).