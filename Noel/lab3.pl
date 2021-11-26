verify(Input):-
    see(Input), read(Nextstate), read(Value), read(Start), read(Goal), seen,
    check(Nextstate,Value,Start,[],Goal).

check(Nextstate,Value,Start,Prev,Goal):-
    check_state(Nextstate,Value,Start,Prev,Goal).

%--------------------------Regler check--------------------------
%rule P sant om m�let finns i nuvarande staten
check_state(_,Value,Start,_,Goal):-
   member([Start,L],Value),
   member(Goal,L).

%rule neg(p) sant om m�let inte finns i den nuvarande staten
check_state(_,Value,Start,_,neg(Goal)):-
   member([Start,L],Value),
   not(member(Goal,L)).

%And rule
check_state(_,Value,Start,_,and(A,B)):-
    member([Start,L],Value),
    member(A,L), member(B,L).

%or rule1
check_state(_,Value,Start,_,or(A,_)):-
    member([Start,L],Value),
    member(A,L).

check_state(_,Value,Start,_,or(_,B)):-
    member([Start,L],Value),
    member(B,L).

