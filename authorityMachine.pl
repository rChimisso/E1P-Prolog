:- module(authorityMachine, [authorityMachine/5]).

:- use_module(userhostMachine).
:- use_module(portMachine).

authorityMachine(Chars, Userinfo, Host, Port, PortLeftover) :-
	append([/, /], TrimmedChars, Chars),
	!, % If it starts with "//", this becomes the only possible production.
    userhostMachine(TrimmedChars, Userinfo, Host, UserhostLeftover),
	!, % Avoid considering Host as Userinfo.
    portMachine(UserhostLeftover, Port, PortLeftover).
authorityMachine(Chars, [], [], '80', Chars).
