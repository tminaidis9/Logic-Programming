check_LOS(State,[State|_]). % YES if state exist
check_LOS(State,[X|ListOfStates]):-
    State \= X,
    check_LOS(State,ListOfStates).

sil(State,LOS,LOS2):-
    append(LOS,[State],LOS2).