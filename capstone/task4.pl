relative(X,Y,Z):-relative(X,Y,Z,'deep').

relative(["father"], X, Y, _) :- parent(Y, X), sex(Y, m).
relative(["mother"], X, Y, _) :- parent(Y, X), sex(Y, f).
relative(["daughter"], X, Y, _) :- parent(X, Y), sex(Y, f).
relative(["son"], X, Y, _) :- parent(X, Y), sex(Y, m).
relative(["sister"], X, Y, _) :- sex(Y, f),
    parent(A, X), parent(B, X), parent(A, Y), parent(B, Y),
    sex(A, f), sex(B, m), X\=Y.
relative(["brother"], X, Y, _) :- sex(Y, m),
    parent(A, X), parent(B, X), parent(A, Y), parent(B, Y),
    sex(A, f), sex(B, m), X\=Y.
relative(["wife"], X, Y, _) :- sex(Y, f), sex(X, m), parent(X, C), parent(Y, C).
relative(["husband"], Y, X, _) :- sex(Y, f), sex(X, m), parent(X, C), parent(Y, C).

relative([H1|Deep], X, Y, N) :- N = 'deep',
    relative(Deep, X, Int, 'deep'), X \= Int,
    relative(H, Int, Y, 'head'), Y \= Int, X \= Y, [H1|[]]=H.
