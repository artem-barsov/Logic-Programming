husb_and_wife(X, Y) :-
    sex(X, m),
    sex(Y, f).
    parent(X, A),
    parent(Y, A),

brother(X, Y) :-
    sex(Y, m),
    parent(A, X),
    parent(A, Y),
    X\=Y, !.

brother_in_law(X, Y) :-
    husb_and_wife(Z, X),
    brother(Z, Y).
