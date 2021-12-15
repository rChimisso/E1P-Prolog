:- module(machineUtils, [listToURIValue/2]).

listToURIValue([], []) :- !.
listToURIValue(List, Value) :- atom_chars(Value, List).
