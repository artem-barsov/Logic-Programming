Лабораторная работа №3: Решение задач методом поиска в пространстве состояний
----
**Цель работы:** Написать и отладить Пролог-программу решения задачи искусственного интеллекта, используя технологию поиска в пространстве состояний.

### Вариант:
1\. Крестьянину нужно переправить волка, козу и капусту с левого берега реки на правый. Как это сделать за минимальное число шагов, если в распоряжении крестьянина имеется двухместная лодка, и нельзя оставлять волка и козу или козу и капусту вместе без присмотра человека.

### Листинг основных предикатов
```prolog
% поиск в глубину
searchDpth(A, B) :-
    write('searchDpth START'), nl,
    get_time(DFS),
    dpth([A], B, L),
    printRes(L),
    get_time(DFS1),
    write('searchDpth END'), nl, nl,
    T1 is DFS1 - DFS,
    write('TIME IS '), write(T1), nl, nl.

dpth([X|T], X, [X|T]).
dpth(P, F, L) :- prolong(P, P1), dpth(P1, F, L).

% поиск в ширину
searchBdth(X, Y) :-
    write('searchBdth START'), nl,
    get_time(BFS),
    bdth([[X]], Y, L),
    printRes(L),
    get_time(BFS1),
    write('searchBdth END'), nl, nl,
    T1 is BFS1 - BFS,
    write('TIME IS '), write(T1), nl, nl.

bdth([[B|T]|_], B, [B|T]).
bdth([H|QT], X, R) :-
    findall(Z, prolong(H, Z), T),
    append(QT, T, OutQ), !,
    bdth(OutQ, X, R).
bdth([_|T], X, R) :- bdth(T, X, R).

% поиск с итерационным углублением
searchId(Start, Finish) :-
    write('searchId START'), nl,
    get_time(ITER),
    int(DepthLimit),
    depthId([Start], Finish, Res, DepthLimit),
    printRes(Res),
    get_time(ITER1),
    write('searchId END'), nl, nl,
    T1 is ITER1 - ITER,
    write('TIME IS '), write(T1), nl, nl.
searchId(Start, Finish, Path) :- int(Level), searchId(Start, Finish, Path, Level).

depthId([Finish|T], Finish, [Finish|T], 0).
depthId(Path, Finish, R, N) :-
    N > 0,
    prolong(Path, NewPath),
    N1 is N - 1,
    depthId(NewPath, Finish, R, N1).
```

### Решение
Основной принцип решения задачи состоит в следующем: из начального состояния с помощью предиката move получаем новое состояние. Состояние s(L,X,R) - соответствует узлу графа:

- L - состояние левого берега
- X - состояние лодки (L - левый берег/R - правый берег)
- R - состояние правого списка

Состояния берегов являются списками, в которых перечесляются животные находящиеся на данном берегу. Предикат prolong нужен, чтобы продлить все пути в графе, предотвращая зацикливания. exception - недопустимые состояния

Результат:
```prolog
?- searchBdth(s(['Volk','Koza','Kapusta'],'L',[]),s([],'R',[_,_,_])).
searchBdth START
s([Volk,Koza,Kapusta],L,[])
s([Volk,Kapusta],R,[Koza])
s([Volk,Kapusta],L,[Koza])
s([Kapusta],R,[Koza,Volk])
s([Kapusta,Koza],L,[Volk])
s([Koza],R,[Volk,Kapusta])
s([Koza],L,[Volk,Kapusta])
s([],R,[Volk,Kapusta,Koza])
searchBdth END

TIME IS 0.011264562606811523

true ;
s([Volk,Koza,Kapusta],L,[])
s([Volk,Kapusta],R,[Koza])
s([Volk,Kapusta],L,[Koza])
s([Volk],R,[Koza,Kapusta])
s([Volk,Koza],L,[Kapusta])
s([Koza],R,[Kapusta,Volk])
s([Koza],L,[Kapusta,Volk])
s([],R,[Kapusta,Volk,Koza])
searchBdth END

TIME IS 0.11845278739929199

true ;
s([Volk,Koza,Kapusta],L,[])
s([Volk,Kapusta],R,[Koza])
s([Volk,Kapusta],L,[Koza])
s([Kapusta],R,[Koza,Volk])
s([Kapusta,Koza],L,[Volk])
s([Kapusta],R,[Volk,Koza])
s([Kapusta,Volk],L,[Koza])
s([Volk],R,[Koza,Kapusta])
s([Volk,Koza],L,[Kapusta])
s([Koza],R,[Kapusta,Volk])
s([Koza],L,[Kapusta,Volk])
s([],R,[Kapusta,Volk,Koza])
searchBdth END

TIME IS 0.31777238845825195

true ;
false.

?- searchDpth(s(['Volk','Koza','Kapusta'],'L',[]),s([],'R',[_,_,_])).
searchDpth START
s([Volk,Koza,Kapusta],L,[])
s([Volk,Kapusta],R,[Koza])
s([Volk,Kapusta],L,[Koza])
s([Kapusta],R,[Koza,Volk])
s([Kapusta,Koza],L,[Volk])
s([Koza],R,[Volk,Kapusta])
s([Koza],L,[Volk,Kapusta])
s([],R,[Volk,Kapusta,Koza])
searchDpth END

TIME IS 0.010365486145019531

true ;
s([Volk,Koza,Kapusta],L,[])
s([Volk,Kapusta],R,[Koza])
s([Volk,Kapusta],L,[Koza])
s([Kapusta],R,[Koza,Volk])
s([Kapusta,Koza],L,[Volk])
s([Kapusta],R,[Volk,Koza])
s([Kapusta,Volk],L,[Koza])
s([Volk],R,[Koza,Kapusta])
s([Volk,Koza],L,[Kapusta])
s([Koza],R,[Kapusta,Volk])
s([Koza],L,[Kapusta,Volk])
s([],R,[Kapusta,Volk,Koza])
searchDpth END

TIME IS 0.10996484756469727

true ;
s([Volk,Koza,Kapusta],L,[])
s([Volk,Kapusta],R,[Koza])
s([Volk,Kapusta],L,[Koza])
s([Volk],R,[Koza,Kapusta])
s([Volk,Koza],L,[Kapusta])
s([Koza],R,[Kapusta,Volk])
s([Koza],L,[Kapusta,Volk])
s([],R,[Kapusta,Volk,Koza])
searchDpth END

TIME IS 0.28425145149230957

true ;
false.

?- searchId(s(['Volk','Koza','Kapusta'],'L',[]),s([],'R',[_,_,_])).
searchId START
s([Volk,Koza,Kapusta],L,[])
s([Volk,Kapusta],R,[Koza])
s([Volk,Kapusta],L,[Koza])
s([Kapusta],R,[Koza,Volk])
s([Kapusta,Koza],L,[Volk])
s([Koza],R,[Volk,Kapusta])
s([Koza],L,[Volk,Kapusta])
s([],R,[Volk,Kapusta,Koza])
searchId END

TIME IS 0.01048421859741211

true ;
s([Volk,Koza,Kapusta],L,[])
s([Volk,Kapusta],R,[Koza])
s([Volk,Kapusta],L,[Koza])
s([Volk],R,[Koza,Kapusta])
s([Volk,Koza],L,[Kapusta])
s([Koza],R,[Kapusta,Volk])
s([Koza],L,[Kapusta,Volk])
s([],R,[Kapusta,Volk,Koza])
searchId END

TIME IS 0.1261436939239502

true ;
s([Volk,Koza,Kapusta],L,[])
s([Volk,Kapusta],R,[Koza])
s([Volk,Kapusta],L,[Koza])
s([Volk,Kapusta],L,[Koza])
s([Kapusta],R,[Koza,Volk])
s([Kapusta,Koza],L,[Volk])
s([Kapusta],R,[Volk,Koza])
s([Kapusta,Volk],L,[Koza])
s([Volk],R,[Koza,Kapusta])
s([Volk,Koza],L,[Kapusta])
s([Koza],R,[Kapusta,Volk])
s([Koza],L,[Kapusta,Volk])
s([],R,[Kapusta,Volk,Koza])
searchId END

TIME IS 0.3310561180114746
```

### Выводы
Все три алгоритма справились со своей задачей. Если сравнивать замеры времени после первого ответа (потому что они самые точные), получится что самый эффективный по времени поиск в глубину, хотя поиск с итеративным погружением отстает от него на уровне погрешности, но минус поиск с итеративным погружением заключается в том, что он последним нашел самый длинный путь. А поиск в ширину нашел сначала короткие, затем длинные маршруты, но не самые длинные. Также он неэффективен по времени и памяти.

Для различных задач подходят различные виды поиска, и выбор должен зависеть от цели. В условиях ограничения по памяти лучше использовать поиск в глубину, а с целью поиска кратчайшего пути -- поиск в ширину. Поиск с итеративным углублением хоть и избегает экспоненциальной сложности, но пригоден только для самых простых задач.
