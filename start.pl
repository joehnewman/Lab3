



verify(Input):-
    see(Input), read(T), read(L), read(S), read(F), seen,
    check(T,L,S,[],F).

%check(T,L,S,U,F)
%t transitions
%l labeling
%s current state
%u currently recorded states
%f ctl formula to check

%evaluates true if sequent below is valid
%(T,L), S |- F
%          U

%literals
check(_, L, S, [], X) :-
    ...

check(_, L, S, [], neg(X)) :-
    ...


%and
check(_, L, S, [], and(F,G)) :-
    ...

%Or
%AX
%EX
%AG
%EG
%EF
%AF
