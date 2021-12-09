verify(Input):-
    see(Input), read(Nextstate), read(Values), read(Start), read(Goal), seen,
    check(Nextstate,Values,Start,[],Goal).

check(Nextstate,Values,Start,U,Goal):-
    check_state(Nextstate,Values,Start,U,Goal).

%--------------------------Regler check--------------------------
%rule P sant om m�let finns i nuvarande staten
check_state(_,Values,Start,[],Goal):-
   member([Start,L],Values),                    %checks goal value exists in current state
   member(Goal,L).                              

%rule neg(p) sant om m�let inte finns i den nuvarande staten
check_state(_,Values,Start,[],neg(Goal)):-
   member([Start,L],Values),
   not( member(Goal,L)).
%And rule
check_state(Nextstate,Values,Start,U,and(A,B)):-      
    check_state(Nextstate,Values,Start,U,A),
    check_state(Nextstate,Values,Start,U,B).

%or rule
check_state(Nextstate,Values,Start,U,or(A,B)):-
    check_state(Nextstate,Values,Start,U,A);
    check_state(Nextstate,Values,Start,U,B).


%ax rule        checks all neighbors 
check_state(Nextstate,Values,Start,U,ax(A)):-   
    member([Start,NeighborList],Nextstate),
    acheck(Nextstate,Values,NeighborList,U,A).

%ex rule        %in neighbor list -echeck- ensures min one fulfill goal
check_state(Nextstate,Values,Start,[],ex(A)):-
    member([Start,NeighborList],Nextstate),
    echeck(Nextstate,Values,NeighborList,[],A).

%ag rule
%Basecase
check_state(Nextstate,Values,Start,U,ag(A)):-
    member(Start,U).                            %stop loops

check_state(Nextstate,Values,Start,U,ag(A)):-
    not(member(Start,U)), %viktig rad (om man har två states som pekar mot varandra ex [s0, [s1]],[s1,[s0]], s� kommer det bli en o�ndlig loop. d�rf�r kollar man om current node inte finns med i listan f�r att kunna forts�tta beviset.)
    check_state(Nextstate,Values,Start,[],A),   %this state must fulfill goal
    member([Start,NeighborList],Nextstate),
    acheck(Nextstate,Values,NeighborList,[Start|U],ag(A)). %as must all neighbors

%af
check_state(Nextstate,Values,Start,U,af(A)):-
     not(member(Start,U)),                      %loop must rtn false stops the search tree once true or false if not true at end of branch
    check_state(Nextstate,Values,Start,[],A).   %checks this state 

check_state(Nextstate,Values,Start,U,af(A)):-
    not(member(Start,U)),                       
    member([Start,NeighborList],Nextstate),     %performs same operation on all neighbors with acheck
    acheck(Nextstate,Values,NeighborList,[Start|U],af(A)).

%eg rule
%Basecase
check_state(Nextstate,Values,Start,U,eg(A)):-
    member(Start,U).                           %stops loop/going back

check_state(Nextstate,Values,Start,U,eg(A)):-    
    check_state(_,Values,Start,_,A),           %checks current Values fulfills A
    member([Start,NeighborList],Nextstate),    %+ that in neighbors a state fulfills goal
    echeck(Nextstate,Values,NeighborList,[Start|U],eg(A)). 

%ef
check_state(Nextstate,Values,Start,U,ef(A)):-   
   not(member(Start,U)),                        %must rtn false else a true means seach is fulfilled
    check_state(Nextstate,Values,Start,[],A).   %[]esnsures checks this state only leaving out U in call

check_state(Nextstate,Values,Start,U,ef(A)):-
   not(member(Start,U)),                        
    member([Start,NeighborList],Nextstate),     %gets neighbors
    echeck(Nextstate,Values,NeighborList,[Start|U],ef(A)). %checks all neighbors and appends

%support metoder---------------------------
%acheck() checks all neigbors fulfil goal
acheck(Nextstate,Values,[H|T],U,Goal):-          %splits arrat to H|T
   check_state(Nextstate,Values,H,U,Goal),       %checks that current state H fulfills Goal    
    acheck(Nextstate,Values,T,U,Goal).           %cass self to check att Tail elements fulfil goal
%basecase
acheck(_,_,[],_,_).                              %stops when tail is reached

%checks one of neighbors fulfil goal
echeck(Nextstate,Values,[H|T],U,Goal):-          
    check_state(Nextstate,Values,H,U,Goal);      %checks if this state funfills goal or if something in tail elements does
    echeck(Nextstate,Values,T,U,Goal).           %note due to or (;) basecase not needed. [] H matchas i en checkstate()
                                                 %recursive calling ensure all branches checked
                                                 %when call echeck(..[]..) rtns false and stops