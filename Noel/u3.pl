partstring(X,L,R):-    %uses phelp to get lists, adds length
      phelp(X,R),
      length(R,L).

phelp([], []).         %B.C once tail empty stops

phelp([_|T], R) :-     %looks at tail
     phelp(T, R).      %passes on tail to call itself

phelp([H|T], [H|R]) :- %keeps head and future R
       helper(T, R).   %calls helper on T

helper(_, []).         %puts end on all functions ensuring a, ab, abc, abcd
helper([H|T], [H|R]) :-%recalls helper keeping head
    helper(T, R).

%each call multiple search paths are opened up
%phelp [_|T] gives abcd bcd cd d
%helper [H|T] gives a ab abc abcd at each step
