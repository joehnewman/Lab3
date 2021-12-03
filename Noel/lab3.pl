verify(Input):-
    see(Input), read(Nextstate), read(Value), read(Start), read(Goal), seen,
    check(Nextstate,Value,Start,[],Goal).

check(Nextstate,Value,Start,U,Goal):-
    check_state(Nextstate,Value,Start,U,Goal).

%--------------------------Regler check--------------------------
%rule P sant om m�let finns i nuvarande staten
check_state(_,Value,Start,_,Goal):-
   write(test),
   member([Start,L],Value),
   member(Goal,L).

%rule neg(p) sant om m�let inte finns i den nuvarande staten
check_state(_,Value,Start,_,neg(Goal)):-
   member([Start,L],Value),
   not(member(Goal,L)).

%And rule
check_state(Nextstate,Value,Start,U,and(A,B)):-
    check_state(Nextstate,Value,Start,U,A),
    check_state(Nextstate,Value,Start,U,B).

%or rule
check_state(Nextstate,Value,Start,U,or(A,B)):-
    check_state(Nextstate,Value,Start,U,A);
    check_state(Nextstate,Value,Start,U,B).


%ax rule
check_state(Nextstate,Value,Start,[],ax(A)):-
    member([Start,NeighborList],Nextstate),
    acheck(Nextstate,Value,NeighborList,[],A).

%ex rule
check_state(Nextstate,Value,Start,[],ex(A)):-
    write(ex),
     member([Start,NeighborList],Nextstate),
    echeck(Nextstate,Value,NeighborList,[],A).

%ag rule
%Basecase
check_state(Nextstate,Value,Start,U,ag(A)):-
    member(Start,U).

check_state(Nextstate,Value,Start,U,ag(A)):-
    check_state(_,Value,Start,_,A),
    acheck(Nextstate,Value,Start,[Start|U],A).


%support metoder---------------------------
acheck(Nextstate,Value,[H|T],U,Goal):-
   check_state(Nextstate,Value,H,U,Goal),
    acheck(Nextstate,Value,T,U,Goal).
%basecase
acheck(_,_,[],_,_).


echeck(Nextstate,Value,[H|T],U,Goal):-
    write(ec),
    check_state(Nextstate,Value,H,U,Goal);
    echeck(Nextstate,Value,T,U,Goal).
