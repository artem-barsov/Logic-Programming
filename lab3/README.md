Лабораторная работа №3: Решение задач методом поиска в пространстве состояний
----
**Цель работы:** Написать и отладить Пролог-программу решения задачи искусственного интеллекта, используя технологию поиска в пространстве состояний.

### Вариант:
1\. Крестьянину нужно переправить волка, козу и капусту с левого берега реки на правый. Как это сделать за минимальное число шагов, если в распоряжении крестьянина имеется двухместная лодка, и нельзя оставлять волка и козу или козу и капусту вместе без присмотра человека.

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
