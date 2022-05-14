wife(X, Y) :-
    parent(X, A),
    parent(Y, A),
    sex(X, m),
    sex(Y, f).

brother(X, Y) :-
    parent(A, X),
    parent(A, Y),
    sex(Y, m),
    X\=Y, !.

brother_in_law(X, Y) :-
    wife(Z, X),
    brother(Z, Y).
