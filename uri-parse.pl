:- use_module(uriUtilities).

% Better idea? Use a composition of FSM to create the URI-FSM, avoid as other
% rules as much as possible. This would require to transform each input string
% into its list of character codes and give this to the URI-FSM.
% Create first each FSM for each part of a URI, then assemble them into the
% URI-FSM by concatenating each final state to the next initial state and
% merging states where needed.
% At the end could be nice to minimize the URI-FSM.

initial(emptyString).
final(uri).

delta(emptyString, String, scheme) :- isScheme(String).
delta(scheme, _, uri).

% accept([S | Ss], Q) :-
% 	delta(Q, S, N),
% 	accept(Ss, N).
% accept([], Q) :- final(Q).

accept(String, Q) :-
	delta(Q, String, N).
accept([], Q) :- final(Q).

uri_parse(URIString) :-
	initial(Q),
	accept(URIString, Q).

uri_parse(URIString, uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)).
