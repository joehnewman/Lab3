verify(Input):-
    see(Input), read(Nextstate), read(Value), read(Start), read(Goal), seen,
    check(Nextstate,Value,Start,[],Goal), !.

check(Nextstate,Value,Start,U,Goal):-
    check_state(Nextstate,Value,Start,U,Goal).

%--------------------------Regler check--------------------------
%rule P sant om m�let finns i nuvarande staten
check_state(_,Value,Start,[],Goal):-
   member([Start,L],Value),
   member(Goal,L).

%rule neg(p) sant om m�let inte finns i den nuvarande staten
check_state(_,Value,Start,[],neg(Goal)):-
   member([Start,L],Value),
   not( member(Goal,L)).
%And rule
check_state(Nextstate,Value,Start,U,and(A,B)):-
    check_state(Nextstate,Value,Start,U,A),
    check_state(Nextstate,Value,Start,U,B).

%or rule
check_state(Nextstate,Value,Start,U,or(A,B)):-
    check_state(Nextstate,Value,Start,U,A);
    check_state(Nextstate,Value,Start,U,B).


%ax rule
check_state(Nextstate,Value,Start,U,ax(A)):-
    member([Start,NeighborList],Nextstate),
    acheck(Nextstate,Value,NeighborList,U,A).

%ex rule
check_state(Nextstate,Value,Start,[],ex(A)):-
    member([Start,NeighborList],Nextstate),
    echeck(Nextstate,Value,NeighborList,[],A).

%ag rule
%Basecase
check_state(Nextstate,Value,Start,U,ag(A)):-
    member(Start,U).

check_state(Nextstate,Value,Start,U,ag(A)):-
    not(member(Start,U)), %viktig rad (om man har tv� states som pekar mot varandra ex [s0, [s1]],[s1,[s0]], s� kommer det bli en o�ndlig loop. d�rf�r kollar man om current node inte finns med i listan f�r att kunna forts�tta beviset.)
    check_state(Nextstate,Value,Start,[],A),
    member([Start,NeighborList],Nextstate),
    acheck(Nextstate,Value,NeighborList,[Start|U],ag(A)).

%af
check_state(Nextstate,Value,Start,U,af(A)):-
     not(member(Start,U)),
    check_state(Nextstate,Value,Start,[],A).

check_state(Nextstate,Value,Start,U,af(A)):-
    not(member(Start,U)),
    member([Start,NeighborList],Nextstate),
    acheck(Nextstate,Value,NeighborList,[Start|U],af(A)).

%eg rule
%Basecase
check_state(_,_,Start,U,eg(_)):-
    member(Start,U).

check_state(Nextstate,Value,Start,U,eg(A)):-
   not(member(Start,U)),
    check_state(Nextstate,Value,Start,[],A),
    member([Start,NeighborList],Nextstate),
    echeck(Nextstate,Value,NeighborList,[Start|U],eg(A)).
%ef
check_state(Nextstate,Value,Start,U,ef(A)):-
   not(member(Start,U)),
    check_state(Nextstate,Value,Start,[],A).

check_state(Nextstate,Value,Start,U,ef(A)):-
   not(member(Start,U)),
    member([Start,NeighborList],Nextstate),
    echeck(Nextstate,Value,NeighborList,[Start|U],ef(A)).

%support metoder---------------------------
%base
acheck(_,_,[],_,_).
acheck(Nextstate,Value,[H|T],U,Goal):-
   check_state(Nextstate,Value,H,U,Goal),
    acheck(Nextstate,Value,T,U,Goal).


echeck(Nextstate,Value,[H|T],U,Goal):-
    check_state(Nextstate,Value,H,U,Goal);
    echeck(Nextstate,Value,T,U,Goal).
