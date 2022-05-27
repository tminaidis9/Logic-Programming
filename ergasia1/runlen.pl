% double((_,_)).
% add(X, L, [L|X]).
decode_rl([],[]).
decode_rl([(X,Y)|Tail],L):-
    decode(X,Y,L1),
    decode_rl(Tail,L2),
    append(L1,L2,L),
    !.

decode_rl([X|Tail],L):-
    append([],[X],L1),
    decode_rl(Tail,L2),
    append(L1,L2,L).

decode(_,0,[]).
decode(X,Y,L1):-
    Z is Y-1,
    decode(X,Z,L2),
    append(L2,[X],L1).


% encode_rl/2
find_cons_pref([X],[X],[]).
find_cons_pref([X,X|List],[X|Pref],Rest):-
    find_cons_pref([X|List],Pref,Rest).

find_cons_pref([X,Y|List],[X],[Y|List]):-
    X \= Y.

encode_rl([],[]).
encode_rl([X|List],Encoded):-
    find_cons_pref([X|List],Pref,Rest),
    encode_rl(Rest,Encoded2),
    length(Pref,Num),
    call_append(X,Num,Encoded2,Encoded).

call_append(X,1,Encoded2,Encoded):-
    append([X],Encoded2,Encoded),
    !.

call_append(X,Num,Encoded2,Encoded):-
    append([(X,Num)],Encoded2,Encoded),
    !. % has no use

%solution on question in Askisi 1:
% X = 3
% Y = 3
% L = [(p(3), 2), (q(3), 2), q(4)]
%

