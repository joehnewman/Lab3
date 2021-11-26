verify(Input):-
    see(Input), read(T), read(L), read(S), read(F), seen,
    check(T,L,S,[],F).

check(T,L,S,U,F):-
    check_state(F,L).

check_state(F,[[_,L]]):-

    member(F,L).


