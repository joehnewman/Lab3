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
check_state(_,Value,Start,_,and(A,B)):-
    member([Start,L],Value),
    member(A,L), member(B,L).

%or rule1
check_state(_,Value,Start,_,or(A,_)):-
    member([Start,L],Value),
    member(A,L).
%or rule2
check_state(_,Value,Start,_,or(_,B)):-
    member([Start,L],Value),
    member(B,L).

%ax rule
check_state(Nextstate,Value,Start,[],ax(A)):-
    acheck(Nextstate,Value,Start,[],A).

%ex rule
check_state(Nextstate,Value,Start,[],ex(A)):-
    echeck(Nextstate,Value,Start,[],A).

%ag rule
%Basecase
check_state(Nextstate,Value,Start,U,ag(A)):-
    member(Start,U).

check_state(Nextstate,Value,Start,U,ag(A)):-
    check_state(_,Value,Start,_,A),
    acheck(Nextstate,Value,Start,[Start|U],A).


%support metoder---------------------------
acheck(Nextstate,Value,Start,U,Goal):-
    member([Start,Statelist],Nextstate),
    atocheck(Nextstate,Value,Start,U,Goal,Statelist).
%basecase
atocheck(_,_,_,_,_,[]).
atocheck(Nextstate,Value,Start,U,Goal,[H|T]):-
    check_state(Nextstate,Value,H,[],Goal),
    atocheck(Nextstate,Value,Start,U,Goal,T).

echeck(Nextstate,Value,Start,U,Goal):-
    member([Start,Statelist],Nextstate),
    etocheck(Nextstate,Value,Start,U,Goal,Statelist).

etocheck(Nextstate,Value,Start,U,Goal,[H|T]):-
    check_state(Nextstate,Value,H,[],Goal);
    etocheck(Nextstate,Value,Start,U,Goal,T).

