:- module(charUtils, [
	isAllowedChar/1,
	isQueryChar/1,
	isIdentifierChar/1,
	isHostIdentifierChar/1,
	isDigitChar/1
]).

/**
 * isAllowedChar(++Char:char) is det
 * 
 * True if Char is a URI restrained ASCII character.
 */
isAllowedChar(Char) :-
	char_code(Char, CharCode),
	isAllowedCode(CharCode).
/**
 * isAllowedCode(++CharCode:int) is det
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
 * isQueryChar(++Char:char) is det
 * 
 * True if Char is a URI restrained ASCII character,
 * apart from '#'.
 */
isQueryChar(Char) :-
	char_code(Char, CharCode),
	isQueryCode(CharCode).
/**
 * isQueryCode(++CharCode:int) is det
 * 
 * True if the integer supplied represents a URI restrained ASCII character,
 * apart from '#'.
 */
isQueryCode(CharCode) :-
	isAllowedCode(CharCode),
	CharCode \= 35.
/**
 * isIdentifierChar(++Char:char) is det
 * 
 * True if Char is a URI restrained ASCII character,
 * apart from '#', '/', ':', '?' and '@'.
 */
isIdentifierChar(Char) :-
	char_code(Char, CharCode),
	isIdentifierCode(CharCode).
/**
 * isIdentifierCode(++CharCode:int) is det
 * 
 * True if the integer supplied represents a URI restrained ASCII character,
 * apart from '#', '/', ':', '?' and '@'.
 */
isIdentifierCode(CharCode) :-
	isAllowedCode(CharCode),
	CharCode \= 35,
	CharCode \= 47,
	CharCode \= 58,
	CharCode \= 63,
	CharCode \= 64.
/**
 * isHostIdentifierChar(++Char:char) is det
 * 
 * True if Char is a URI restrained ASCII character,
 * apart from '#', '.', '/', ':', '?' and '@'.
 */
isHostIdentifierChar(Char) :-
	char_code(Char, CharCode),
	isIdentifierCode(CharCode).
/**
 * isHostIdentifierCode(++CharCode:int) is det
 * 
 * True if the integer supplied represents a URI restrained ASCII character,
 * apart from '#', '.', '/', ':', '?' and '@'.
 */
isHostIdentifierCode(CharCode) :-
	isAllowedCode(CharCode),
	CharCode \= 35,
	CharCode \= 46,
	CharCode \= 47,
	CharCode \= 58,
	CharCode \= 63,
	CharCode \= 64.
/**
 * isDigitChar(++Char:int) is det
 * 
 * True if Char is a URI restrained ASCII character representing a digit.
 */
isDigitChar(Char) :-
	char_code(Char, CharCode),
	isDigitCode(CharCode).
/**
 * isDigit(++Char:int) is det
 * 
 * True if the integer supplied represents a URI restrained ASCII character
 * representing a digit.
 */
isDigitCode(CharCode) :-
	CharCode > 47,
	CharCode < 58.
