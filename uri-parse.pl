:- use_module(schemeMachine).
:- use_module(uriMachine).

uri_parse(String, uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)) :-
	string_chars(String, Chars),
    schemeMachine(Chars, Scheme, SchemeLeftover),
	uriMachine(SchemeLeftover, Userinfo, Host, Port, Path, Query, Fragment).

uri_display(uri(Scheme, Userinfo, Host, Port, Path, Query, Frag), Stream) :-
	write(Stream, uri(Scheme, Userinfo, Host, Port, Path, Query, Frag)),
	nl(Stream).

uri_display(uri(Scheme, Userinfo, Host, Port, Path, Query, Frag)) :-
	current_output(Stream),
	uri_display(uri(Scheme, Userinfo, Host, Port, Path, Query, Frag), Stream).
