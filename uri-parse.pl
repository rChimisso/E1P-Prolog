:- use_module(schemeMachine).
:- use_module(userhostMachine).
:- use_module(pqfZosMachine).
:- use_module(portMachine).
:- use_module(uriMachine).

/**
 * uri_parse(++String:string, -Uri:uri) is nondet.
 * 
 * True when the given string represents a valid URI.
 */
uri_parse(String, uri(mailto, Userinfo, Host, '80', [], [], [])) :-
	string_chars(String, Chars),
    schemeMachine(Chars, mailto, SchemeLeftover),
	!,
	userhostMachine(SchemeLeftover, Userinfo, Host, []),
	Userinfo \= [].
uri_parse(String, uri(news, [], Host, '80', [], [], [])) :-
	string_chars(String, Chars),
    schemeMachine(Chars, news, SchemeLeftover),
	!,
	userhostMachine(SchemeLeftover, '', Host, []),
	!, % Avoid considering Host as Userinfo.
	Host \= [].
uri_parse(String, uri(tel, Userinfo, [], '80', [], [], [])) :-
	string_chars(String, Chars),
    schemeMachine(Chars, tel, SchemeLeftover),
	!,
	userhostMachine(SchemeLeftover, Userinfo, '', []),
	Userinfo \= [].
uri_parse(String, uri(fax, Userinfo, [], '80', [], [], [])) :-
	string_chars(String, Chars),
    schemeMachine(Chars, fax, SchemeLeftover),
	!,
	userhostMachine(SchemeLeftover, Userinfo, '', []),
	Userinfo \= [].
uri_parse(String, uri(zos, Userinfo, Host, Port, Path, Query, Fragment)) :-
	string_chars(String, Chars),
    schemeMachine(Chars, zos, SchemeLeftover),
	append([/, /], TrimmedChars, SchemeLeftover),
	!, % If it starts with "//", this becomes the only possible zos production.
    userhostMachine(TrimmedChars, Userinfo, Host, UserhostLeftover),
	!, % Avoid considering Host as Userinfo.
    portMachine(UserhostLeftover, Port, PortLeftover),
    pqfZosMachine(PortLeftover, Path, Query, Fragment).
uri_parse(String, uri(zos, [], [], '80', Path, Query, Fragment)) :-
	string_chars(String, Chars),
    schemeMachine(Chars, zos, SchemeLeftover),
	!,
	pqfZosMachine(SchemeLeftover, Path, Query, Fragment).
uri_parse(String, uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)) :-
	string_chars(String, Chars),
    schemeMachine(Chars, Scheme, SchemeLeftover),
	uriMachine(SchemeLeftover, Userinfo, Host, Port, Path, Query, Fragment).
/**
 * uri_display(+Uri:uri, ++Stream:stream) is det.
 * 
 * Always true, writes the given URI to the specified Stream.
 */
uri_display(uri(Scheme, Userinfo, Host, Port, Path, Query, Frag), Stream) :-
	write(Stream, uri(Scheme, Userinfo, Host, Port, Path, Query, Frag)),
	nl(Stream).
/**
 * uri_display(+Uri:uri) is det.
 * 
 * Always true, writes the given URI to current output stream.
 */
uri_display(uri(Scheme, Userinfo, Host, Port, Path, Query, Frag)) :-
	current_output(Stream),
	uri_display(uri(Scheme, Userinfo, Host, Port, Path, Query, Frag), Stream).
