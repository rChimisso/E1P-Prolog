# E1P-Prolog 2022

## Description
Simple Prolog library to parse strings into URIs.
#

## Library interface
This library provides 3 predicates: 1 parser and 2 utilities.

uri_parse/2, the parser, takes care of parsing any given string and
instantiating the matching URI, also working with already partially or fully
instantiated URIs.  
Strings with special characters are converted into their respective octets.

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
	| "zos" ':' [authority] ['/' zosPath ['?' query] ['#' fragment]]  
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
	(Defaults to 80 when not specified)
- path ::= identifier+ ('/' identifier+)*
- zosPath ::= id44 ['(' id8 ')']
- id44 ::= alpha alnum* ('.' alnum+)*  
	(Can be at most 44 characters long)
- id8 ::= alpha alnum*  
	(Can be at most 8 characters long)
- query ::= queryCharacter+
- fragment ::= character+  
#### Where:
- 'character' is any ASCII character between 32 and 127 (both excluded) and
without '\'.
- 'queryCharacter' is as 'character' but without '#'.
- 'hostIdentifier' is as 'queryCharacter' but without  '/', '?', '#', '@',
and ':'.
- 'identifier' is as 'hostIdentifier' but without '.'.
- 'digit' is any ASCII numeric character.
- 'alpha' is any ASCII alphabetic character.
- 'alnum' is any ASCII alphanumeric character.
#

## Mechanisms behind
The whole project uses a custom made utility module ([charUtils]) to
recognize to which character class a given character belongs to and to convert
values from list of characters to URI values with octets.  
The first idea was to create a specific Finite State Machine for each URI part
(Scheme, Userinfo, Host, Port, Path, Query, Fragment).  
To make it possible each machine would have to understand when to stop and leave
the rest of the computation to the other machines.  
The first FSM built was [schemeMachine] to recognize if the string supplied had
at first a valid URI Scheme followed by a ':'. The rest of the string, already
transformed in a list of characters, would then be given to the next machine.  
Since Userinfo and Host are almost identical in grammar rules, sometimes it's
not possible to determine with certainty whether a URI specified
a Userinfo or a Host.  
With this in mind, [userhostMachine] was created, a general machine for
Userinfo and Host, meaning it can always recognize one of
the two or both and further restrictions must be applied outside of it.  
This machine is fundamental for every production, apart the ones that only
specify a Scheme, and it is indeed used as the only machine for most productions
and in combination with other machines for Path related productions.  
After it was the turn of [portMachine], which, as the name suggests, is specific
to recognize a valid URI Port and set it to 80 by default. This, although at
first glance seems as important as [userhostMachine], most productions cannot
specifiy a port and so there was no use for this machine in them and 80 as Port
is forced.  
It however becomes quite useful for the next machine, [authorityMachine], since
it indeed recognize the Port if present or sets it to 80 if not present and also
takes care of detecting the presence of the '/' at the end of the authority and
removes it to prepare the list of characters for the next machines.  
The following machine, as anticipated, is [authorityMachine] which combines
[userhostMachine] and [portMachine] and few other checks to detect the authority
when present and give the leftover, with the initial '/' removed, to the next
machines.  
The next was [qfMachine] to recognize Query and Fragment.  
This needs to be combined with either [pathMachine] or [zPathMachine] to
recognize the whole [path] ['?' query] ['#' fragment] block, with [zPathMachine]
specific for the "zos" Path.  
The combinations of these machines are respectively [pqfMachine] and
[zpqfMachine], with the latter being the one that actually checks the length of
id44 and id8 instead of [zPathMachine].
In [prMachine] [authorityMachine] was combined with either [pqfMachine] or
[zpqfMachine], to recognize any possible URI that can have a Path (this gives
the machine its name, a machine Path Related).  
Finally there's [uriMachine] that for each given Scheme,
apart "zos" that is directly checked in [prMachine], uses the most high-level
machines ([userhostMachine] and [prMachine]) with a few restraints to recognize
any valid URI.  
This final machine is then used in combination with [schemeMachine] in
uri_parse/2, that is the method exposed by the library.

[RFC-3986]: https://datatracker.ietf.org/doc/html/rfc3986
['uri-parse.pl']: ./uri-parse.pl
[Prolog Documentation Standard]:
https://www.swi-prolog.org/pldoc/doc_for?object=section(%27packages/pldoc.html%27)
[charUtils]: ./charUtils.pl
[schemeMachine]: ./schemeMachine.pl
[userhostMachine]: ./userhostMachine.pl
[portMachine]: ./portMachine.pl
[authorityMachine]: ./authorityMachine.pl
[qfMachine]: ./qfMachine.pl
[pathMachine]: ./pathMachine.pl
[zPathMachine]: ./zPathMachine.pl
[pqfMachine]: ./pqfMachine.pl
[zpqfMachine]: ./zpqfMachine.pl
[prMachine]: ./prMachine.pl
[uriMachine]: ./uriMachine.pl
