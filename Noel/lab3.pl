verify(Input):-
    see(Input), read(Nextstate), read(Value), read(Start), read(Goal), seen,
    check(Nextstate,Value,Start,[],Goal).

check(Nextstate,Value,Start,Prev,Goal):-
    check_state(Nextstate,Value,Start,Prev,Goal).

%--------------------------Regler check--------------------------
%rule P sant om målet finns i nuvarande staten
check_state(_,Value,Start,_,Goal):-
   member([Start,L],Value),
   member(Goal,L).

%rule neg(p) sant om målet inte finns i den nuvarande staten
check_state(_,Value,Start,_,neg(Goal)):-
   member([Start,L],Value),
   not(member(Goal,L)).

%And rule

