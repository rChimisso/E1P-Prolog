:- module(uriUtilities, [isScheme/1]).

:- use_module(stringUtilities).

isScheme(String) :-
	String \= "",
	includesNot(String, ['/', '?', '#', '@', ':']).
