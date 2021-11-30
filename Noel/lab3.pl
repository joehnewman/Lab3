verify(Input):-
    see(Input), read(Nextstate), read(Value), read(Start), read(Goal), seen,
    check(Nextstate,Value,Start,[],Goal).

check(Nextstate,Value,Start,Prev,Goal):-
    check_state(Nextstate,Value,Start,Prev,Goal).

%--------------------------Regler check--------------------------
%rule P sant om målet finns i nuvarande staten
check_state(_,Value,Start,_,Goal):-
   write(test),
   member([Start,L],Value),
   member(Goal,L).

%rule neg(p) sant om målet inte finns i den nuvarande staten
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
    acheck(Nextstate,Value,Start,A).

%support metoder---------------------------
acheck(Nextstate,Value,Start,Goal):-
    member([Start,Statelist],Nextstate),
    atocheck(Nextstate,Value,Start,Goal,Statelist).
%basecase
atocheck(_,_,_,_,[]).
atocheck(Nextstate,Value,Start,Goal,[H|T]):-
    check_state(Nextstate,Value,H,[],Goal),
    atocheck(Nextstate,Value,Start,Goal,T).
