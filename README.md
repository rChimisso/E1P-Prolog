# E1P-Prolog 2022

## Description
Simple Prolog library to parse strings into URIs.
#

## Library interface
This library provides 3 predicates: 1 parser and 2 utilities.

uri_parse/2, the parser, takes care of parsing any given string and
instantiating the matching URI, also working with already partially or fully
instantiated URIs.

uri_display/1 and uri_display/2 respectively print the given URI on
the current output stream or any given stream.  
It's important to note that the uri_displays do NOT check for URI validity.
#

## How to use
It's just necessary to load the file ['uri-parse.pl'].  
Then each predicate comes with a short Doc compliant to the
[Prolog Documentation Standard] explaining each parameter and result.
#

## Parsing infos
The parsing is based on a simplified version of [RFC-3986].

It's based on the following case-insensitive productions:
- uri ::=  
	"news" ':' [host]  
	| ("tel" | "fax") ':' [userinfo]  
	| "mailto" ':' [userinfo ['@' host]]  
	| "zos" ':' [authority] ['/' [zosPath] ['?' query] ['#' fragment]]  
	| ("http" | "https") ':' [authority] ['/' [path] ['?' query] ['#' fragment]]  
	| scheme ':' [host]  
	| scheme ':' [userinfo ['@' host]]  
	| scheme ':' [authority] ['/' [path] ['?' query] ['#' fragment]]
- scheme ::= identifier+  
	("news", "tel", "fax", "mailto", "zos", "http" and "https" are excluded)
- authority ::= "//" [userinfo '@'] host [':' port]
- userinfo ::= identifier+
- host ::= hostIdentifier+ ('.' hostIdentifier+)*
- port ::= digit+
- path ::= identifier+ ('/' identifier+)*
- zosPath ::= id44 ['(' id8 ')']
- id44 ::= alpha alnum* ('.' alnum+)*  
	(Must be at most 44 characters long)
- id8 ::= alpha alnum*  
	(Must be at most 8 characters long)
- query ::= queryCharacter+
- fragment ::= character+  
#### Where:
- 'character' is any ASCII character between 32 and 127 (both excluded) and
without '"', '%', '<', '>', '\', '^', '`'. '{', '|' and '}'.
- 'queryCharacter' is as 'character' but without '#'.
- 'hostIdentifier' is as 'queryCharacter' but without  '/', '?', '#', '@',
and ':'.
- 'identifier' is as 'hostIdentifier' but without '.'.
- 'digit' is any ASCII numeric character.
- 'alpha' is any ASCII alphabetic character.
- 'alnum' is any ASCII alphanumeric character.
#

## Mechanisms behind
The whole project uses a custom made utility module (['charUtils.pl']) to
recognize to which character class a given character belongs to.  
The above productions were generalized and unified, and specific FSMs are used
to recognize each URI building block or a set of them.  
Those fundamental FSMs, apart from the Scheme one, are merged into bigger and
more complex ones and the same applies for the latters until reaching
[uriMachine].  
[uriMachine] is the most general FSM to recognize each production, accounting
also for the value of the Scheme.
Finally, uri_parse parses the Scheme and uses [uriMachine] to parse the rest.

[RFC-3986]: https://datatracker.ietf.org/doc/html/rfc3986
['uri-parse.pl']: ./uri-parse.pl
[Prolog Documentation Standard]:
https://www.swi-prolog.org/pldoc/doc_for?object=section(%27packages/pldoc.html%27)
['charUtils.pl']: ./charUtils.pl
[uriMachine]: ./uriMachine.pl
