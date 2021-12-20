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
 * isAllowedChar(++Char:char) is semidet.
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
	CharCode > 32,
	CharCode < 127,
	CharCode \= 34, % "
	CharCode \= 37, % %
	CharCode \= 60, % <
	CharCode \= 62, % >
	CharCode \= 92, % \
	CharCode \= 94, % ^
	CharCode \= 96, % `
	CharCode \= 123, % {
	CharCode \= 124, % |
	CharCode \= 125. % }
/**
 * isQueryChar(++Char:char) is semidet.
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
 * isIdentifierChar(++Char:char) is semidet.
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
 * isHostIdentifierChar(++Char:char) is semidet.
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
 * isDigitChar(++Char:char) is semidet.
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
 * isAlphaChar(++Char:char) is semidet.
 * 
 * True if Char is a alphabetic URI restrained ASCII character.
 */
isAlphaChar(Char) :-
	char_type(Char, alpha),
	isAllowedChar(Char).
/**
 * isAlnumChar(++Char:char) is semidet.
 * 
 * True if Char is a alphanumeric URI restrained ASCII character.
 */
isAlnumChar(Char) :-
	char_type(Char, alnum),
	isAllowedChar(Char).
/**
 * listToURIValue(++List:list, -Value:atomic) is semidet.
 * listToURIValue(-List:list, ++Value:atomic) is semidet.
 * 
 * True if the given list can be converted to an atom or viceversa.
 */
listToURIValue([], []) :- !.
listToURIValue(List, Value) :- atom_chars(Value, List).