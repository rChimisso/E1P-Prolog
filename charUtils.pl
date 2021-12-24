:- module(charUtils, [
	isAllowedChar/1,
	isQueryChar/1,
	isIdentifierChar/1,
	isHostIdentifierChar/1,
	isDigitChar/1,
	isAlphaChar/1,
	isAlnumChar/1,
	listToURIValue/2
]).

/**
 * isAllowedChar(++Char:atom) is semidet.
 * 
 * True if Char is a URI restrained ASCII character.
 */
isAllowedChar(Char) :-
	char_code(Char, CharCode),
	isAllowedCode(CharCode).
/**
 * isAllowedCode(++CharCode:int) is semidet.
 * 
 * True if the integer supplied represents a URI restrained ASCII character.
 */
isAllowedCode(CharCode) :-
	CharCode > 31,
	CharCode < 127,
	CharCode \= 92. % \
/**
 * isQueryChar(++Char:atom) is semidet.
 * 
 * True if Char is  a URI restrained ASCII character,
 * apart from '#'.
 */
isQueryChar(Char) :-
	char_code(Char, CharCode),
	isQueryCode(CharCode).
/**
 * isQueryCode(++CharCode:int) is semidet.
 * 
 * True if the integer supplied represents a URI restrained ASCII character,
 * apart from '#'.
 */
isQueryCode(CharCode) :-
	isAllowedCode(CharCode),
	CharCode \= 35.
/**
 * isIdentifierChar(++Char:atom) is semidet.
 * 
 * True if Char is a URI restrained ASCII character,
 * apart from '#', '/', ':', '?' and '@'.
 */
isIdentifierChar(Char) :-
	char_code(Char, CharCode),
	isIdentifierCode(CharCode).
/**
 * isIdentifierCode(++CharCode:int) is semidet.
 * 
 * True if the integer supplied represents a URI restrained ASCII character,
 * apart from '#', '/', ':', '?' and '@'.
 */
isIdentifierCode(CharCode) :-
	isQueryCode(CharCode),
	CharCode \= 47,
	CharCode \= 58,
	CharCode \= 63,
	CharCode \= 64.
/**
 * isHostIdentifierChar(++Char:atom) is semidet.
 * 
 * True if Char is a URI restrained ASCII character,
 * apart from '#', '.', '/', ':', '?' and '@'.
 */
isHostIdentifierChar(Char) :-
	char_code(Char, CharCode),
	isHostIdentifierCode(CharCode).
/**
 * isHostIdentifierCode(++CharCode:int) is semidet.
 * 
 * True if the integer supplied represents a URI restrained ASCII character,
 * apart from '#', '.', '/', ':', '?' and '@'.
 */
isHostIdentifierCode(CharCode) :-
	isIdentifierCode(CharCode),
	CharCode \= 46.
/**
 * isDigitChar(++Char:atom) is semidet.
 * 
 * True if Char is a URI restrained ASCII character representing a digit.
 */
isDigitChar(Char) :-
	char_code(Char, CharCode),
	isDigitCode(CharCode).
/**
 * isDigitCode(++CharCode:int) is semidet.
 * 
 * True if the integer supplied represents a URI restrained ASCII character
 * representing a digit.
 */
isDigitCode(CharCode) :-
	CharCode > 47,
	CharCode < 58.
/**
 * isAlphaChar(++Char:atom) is semidet.
 * 
 * True if Char is a alphabetic URI restrained ASCII character.
 */
isAlphaChar(Char) :-
	char_type(Char, alpha),
	isAllowedChar(Char).
/**
 * isAlnumChar(++Char:atom) is semidet.
 * 
 * True if Char is a alphanumeric URI restrained ASCII character.
 */
isAlnumChar(Char) :-
	char_type(Char, alnum),
	isAllowedChar(Char).
/**
 * octetList(?List:atom[], ?OctetList:atom[]) is semidet.
 * 
 * True when OctetList is the same as List, but with its special characters
 * converted into URI percentage encoded octets.
 */
octetList([], []) :- !.
octetList([' ' | Ts], ['%', '2', '0' | OctetTs]) :- !, octetList(Ts, OctetTs).
octetList(['"' | Ts], ['%', '2', '2' | OctetTs]) :- !, octetList(Ts, OctetTs).
octetList(['%' | Ts], ['%', '2', '5' | OctetTs]) :- !, octetList(Ts, OctetTs).
octetList(['<' | Ts], ['%', '3', 'C' | OctetTs]) :- !, octetList(Ts, OctetTs).
octetList(['>' | Ts], ['%', '3', 'E' | OctetTs]) :- !, octetList(Ts, OctetTs).
octetList(['^' | Ts], ['%', '5', 'E' | OctetTs]) :- !, octetList(Ts, OctetTs).
octetList(['`' | Ts], ['%', '6', '0' | OctetTs]) :- !, octetList(Ts, OctetTs).
octetList(['{' | Ts], ['%', '7', 'B' | OctetTs]) :- !, octetList(Ts, OctetTs).
octetList(['|' | Ts], ['%', '7', 'C' | OctetTs]) :- !, octetList(Ts, OctetTs).
octetList(['}' | Ts], ['%', '7', 'D' | OctetTs]) :- !, octetList(Ts, OctetTs).
octetList([H | Ts], [H | OctetTs]) :- octetList(Ts, OctetTs).
/**
 * listToURIValue(++List:list, -Value:atomic) is semidet.
 * listToURIValue(-List:list, ++Value:atomic) is semidet.
 * 
 * True if the given list can be converted to an atom or viceversa.
 */
listToURIValue([], []) :- !.
listToURIValue(List, Value) :-
	octetList(List, OctetList),
	atom_chars(Value, OctetList).