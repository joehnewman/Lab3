



verify(Input):-
    see(Input), read(T), read(L), read(S), read(F), seen,
    check(T,L,S,[],F).

%check(T,L,S,U,F)
%t transitions ex
[[s0,[s1,,,]],
 [s1,[,,,]],
 [s2,[,,,]]]    list of next states from current
%l labeling
%[[s0, [r]],
% [s1, [],
% [s2, [q]]     list of whats true in given state

%s current state
   ex s1. (for inspection)
%u currently recorded states [opens array for storing stuff]
%f ctl formula to check
%ex ef(ef(ax(r))).
%statement to check. can we get this from current state
%ie exists future(exists future(next state(r)))

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


1 simple case get to take an imput file and rtn true
2 get to check simplest of things such as single node model loop or something
