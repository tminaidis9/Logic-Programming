 % check that your move isn't on list of older moves.
check_LOS(State,[State|_]). % YES if state exist
check_LOS(State,[X|ListOfStates]):-
    State \= X,
    check_LOS(State,ListOfStates).

moveInLOS(L,N,_,ME):- % if all of moves are anavailable, finish.
    length(L,Len),
    N > Len,
    ME = 0, % MoveElement is 0, we haven't any available Move
    !.
moveInLOS(List,Num,LOS,ME):- % find move which doesn't goes to NL in LOS.
    move(List,Num,NL),
    ( check_LOS(NL,LOS) -> %if NL exist in LOS
    Num2 is Num + 1,
    moveInLOS(List,Num2,LOS,ME) % search again with same List and Num = Num + 1. 
    ; % if NL doen't exist in LOS, MoveElement (ME) = Num.
    ME = Num).

swapInLOS(L1,SE,SE2,LOS,N1,N2):- % find swap which doesn't goes to NL in LOS.
    swap(L1,SE,SE2,NL1),
    length(L1,Len),
    ( check_LOS(NL1,LOS), SE2 < Len -> % if NL exist in LOS and SwapElement2 < Length of List1
        NSE2 is SE2 + 1,
        swapInLOS(L1,SE,NSE2,LOS,N1,N2) % search again with same List and SE2Num = SE2Num + 1. 
    ; check_LOS(NL1,LOS), SE < Len -> % if NL exist in LOS and SwapElement2 = Length and SE < Length
        NSE is SE + 1,
        swapInLOS(L1,NSE,1,LOS,N1,N2)
    ; check_LOS(NL1,LOS) -> % if NL exist in LOS and SwapElement2 = Length and SE = Length
        N1 = 0,
        N2 = 0
    ; 
        N1 is SE,
        N2 is SE2
    ).

return_Len([X|_],1,X).
return_Len([_|Tail],Len,Last):-
    Len2 is Len - 1,
    return_Len(Tail,Len2,Last).

father(_,_).

% LOM = ListOfMoves (like move(1)) LOS = ListOfStates (like [a,a,c,d]) 

codegen2(L1,L1,LOM,_,LOM). 
codegen2(L1,L2,LOM,LOS,L):-
    moveInLOS(L1,1,LOS,ME),
    print(ME),
    (ME \= 0 ->
        print(fuck),
        move(L1,ME,NL1),
        append(LOS,[NL1],NewLOS),
        append(LOM,[move(ME)],NewLOM),
        father(L1,NL1),
        codegen2(NL1,L2,NewLOM,NewLOS,L)
    ; swapInLOS(L1,1,2,LOS,SE,SE2), SE \= 0 ->
        print(fu),
        swap(L1,SE,SE2,NL1),
        append(LOS,[NL1],NewLOS),
        append(LOM,[swap(SE,SE2)],NewLOM),
        father(L1,NL1),
        codegen2(NL1,L2,NewLOM,NewLOS,L)
    ;
        print(lom),
        print(LOM),
        length(LOM,Leng),
        return_Len(LOM,Leng,LastInLOM),
        append(NLOM,[LastInLOM],LOM),
        % print(los),
        % print(LOS),
        % print(last),
        print(L1),
        % nl,
        father(Father,L1),
        print(Father),
        codegen2(Father,L2,NLOM,LOS,L)
    ;
        print(ok)
    ).

        
codegen(List,List,[]).
codegen(List1,List2,L):-
    append([],[List1],LOS), 
    S is 0,
    father(List1,List1),
    codegen2(List1,List2,[S],LOS,L).

% functions using in swap,move
find([X|_],Number,Number,X).                      %briskei to stoixeio stin mia apo tis dio theseis pou tha ginei to swap
find([_|Tail],XNum,Num,Target):-
    XNum \= Num,
    Num2 is Num + 1,
    find(Tail,XNum,Num2,Target2),
    Target = Target2.

swapzy([],_,_,_,[]).                                % Change the element List1[Num] with element Y and returns List
swapzy([_|Tail],Y,Length,Length,List):- 
    Num2 is Length + 1,
    swapzy(Tail,Y,Length,Num2,List2),
    append([Y],List2,List).

swapzy([X|Tail],Y,Length,Num,List):-
    Length \= Num,
    Num2 is Num + 1,
    swapzy(Tail,Y,Length,Num2,List2),
    append([X],List2,List).

% Swap/4
swap([],_,_,[]).
swap([X|Tail],XNum,YNum,L):-
    find([X|Tail],XNum,1,Z),
    find([X|Tail],YNum,1,Y),
    swapzy([X|Tail],Y,XNum,1,List),
    swapzy(List,Z,YNum,1,L).
    
% Move/3
move([X|Tail],Num,L):-
    find([X|Tail],Num,1,Y), 
    Num2 is Num + 1,
    length([X|Tail],Length),
    Length < Num2,
    swapzy([X|Tail],Y,1,1,L),
    !. 

move([X|Tail],Num,L):-
    find([X|Tail],Num,1,Y), %find the element List[Num] and 
    Num2 is Num + 1,
    swapzy([X|Tail],Y,Num2,1,L). % change the next one with it.


