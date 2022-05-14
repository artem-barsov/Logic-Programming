# Отчет по курсовому проекту
## по курсу "Логическое программирование"

### студент: Барсов А.В.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*

## Введение

Опишите, какие знания и навыки вы получите в результате выполнения курсового проекта

## Задание

 1. Создать родословное дерево своего рода на несколько поколений (3-4) назад в стандартном формате GEDCOM с использованием сервиса MyHeritage.com
 2. Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog, используя следующее представление: `parent(родитель, ребенок)`, `sex(человек, m/f)`.
 3. Реализовать предикат проверки/поиска `Деверя`
 4. Реализовать программу на языке Prolog, которая позволит определять степень родства двух произвольных индивидуумов в дереве
 5. [На оценки хорошо и отлично] Реализовать естественно-языковый интерфейс к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы.

## Получение родословного дерева

Я использовал файл [родословной европейской знати](https://www.rusgenealog.ru/gedcom/royal_gen.zip). В данном файле содержится информация об представителях английской, немецкой, французской, польской, чешской и русской знати (всего 33590 персон).

## Конвертация родословного дерева

Для конвертация родословного дерева я реализовал парсер формата GEDCOM с помощью языка bash. Данный скрипт принимает в качестве первого аргумента файл формата GEDCOM, из которого будут считываться данные, и в качестве второго аргумента - выходной пролог-файл, в котором будет записан набор утверждений на языке Prolog.

Фрагмент GEDCOM файла:
```
0 @I500007@ INDI
1 _UPD 4 OCT 2019 15:39:05 GMT -0500
1 NAME Nikolaj /Kulagin/
2 GIVN Nikolaj
2 SURN Kulagin
1 SEX M
1 BIRT
2 DATE 1950
1 FAMS @F500003@
1 FAMC @F500005@
1 RIN MH:I500007
1 _UID 5D97990B657587242186F613BD70A432
```

Фрагмент кода утверждений на языке Prolog:
```prolog
sex("Nikolaj_Kulagin", m).
parent("Nikolaj_Kulagin", "Aleksej_Kulagin").
```

Применение скрипта:

```bash
./parser.sh gedtree.ged tree.pl
```

## Предикат поиска родственника

Для поиска деверя я реализовал вспомогательные предикаты `wife` и `brother`:

```prolog
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
```

И сам предикат поиска деверя:

```prolog
brother_in_law(X, Y) :-
    wife(Z, X),
    brother(Z, Y).
```

Примеры запроса:
```prolog
?- brother_in_law(X, Y).
X = "Elena_Kulagina",
Y = "Aleksandr_Gromov" ;
X = "Alisa_Palyonova",
Y = "Ivan_Kurov" ;
X = "Anna_SHCHeglova",
Y = "Dmitrij_Kurov" ;
false.

?- brother_in_law("Elena_Kulagina", X).
X = "Aleksandr_Gromov".

?- brother_in_law(X, "Aleksandr_Gromov").
X = "Elena_Kulagina" .
```

## Определение степени родства

Предикат `relative(Relation, X, Y)` эквивалентен вопросу "Кто Y для X?"

В данном предикате происходит определение родства двух конкретных индивидуумов.

При определении произвольной степени родства сперва проверяются тривиальные случаи, например:
```prolog
relative(["father"], X, Y, _) :- parent(Y, X), sex(Y, m).
relative(["mother"], X, Y, _) :- parent(Y, X), sex(Y, f).
relative(["daughter"], X, Y, _) :- parent(X, Y), sex(Y, f).
relative(["son"], X, Y, _) :- parent(X, Y), sex(Y, m).
```
Когда совпадений не нашлось, необходимо искать более глубокие связи родства и для этого используется предикат:
```prolog
relative([H1|Deep], X, Y, N) :- N = 'deep',
    relative(Deep, X, Int, 'deep'), X \= Int,
    relative(H, Int, Y, 'head'), Y \= Int, X \= Y, [H1|[]]=H.
```
Данный предикат определяет для X человека, который является каким либо родственником ему, и пытаемся определить степень родства этого человека для Y. Чтобы избежать циклов и малочитаемых сложных решений на ранних стадиях поиска, поиск для Y осуществляется поверхностно, без захода в рекурсивную функцию опеределения родства. Полнота вывода от этого не страдает. Бесконечное количество ответов от такого решения оптимизации не уменьшилось. Однако удобочитаемость и простота ответов повысилась, поскольку подобный поиск очень похож на обход графа с итерационным заглублением, в котором величина спуска равна 1, таким спуском обусловливается последовательное увеличение количества слов в ответе.

## Естественно-языковый интерфейс

Естественно-языковой интерфейс реализован для 4-х видов вопросов:
```prolog
parse_question(X) --> n1r_q(X). % Who is N R
parse_question(X) --> n2r_q(X). % Whose R is N  
parse_question(X) --> rn1n2_q(X). % What kind/type relations between N1 and N2
parse_question(X) --> num_q(X). % How many R does/did/do N have
```
1. Кто является R для N?(пример: `who is Aleksandr_Gromov's brother?`)
2. Чьим R является N?(пример: `whose son is Aleksandr_Gromov?`)
3. Какие отношения между N1 и N2?(пример: `what kind relations between Aleksandr_Gromov and Aleksej_Kulagin?`)
4. Сколько R имеет N?(пример: `how many brothers does Aleksandr_Gromov have?`)

Предикат `ask_question` реализован для разбора грамматики и генерации ответа:

```prolog
ask_question(R) :-
    ask_question(R, Ans),
    print_res(Ans).

ask_question(R, Ans) :-
    read_string_to_list(R, A),
    parse_question(Model, A, []),
    parse_model(Model, Args),
    generate_ans(Args, Ans).
```

Пример работы:

```prolog
?- ask_question("who is Aleksandr_Gromov's brother?").
The brother of Aleksandr_Gromov is Nikolaj_Timofeev
true ;
false.

?- ask_question("whose son is Aleksandr_Gromov?").
Aleksandr_Gromov is son of Aleksej_Timofeev
true ;
Aleksandr_Gromov is son of Lidiya_Timofeeva
true ;
false.

?- ask_question("what kind relations between Aleksandr_Gromov and Aleksej_Kulagin?").
Aleksej_Kulagin is brother of wife of brother of Aleksandr_Gromov
true ;
Aleksej_Kulagin is brother of wife of son of father of Aleksandr_Gromov
true ;
Aleksej_Kulagin is brother of mother of son of brother of Aleksandr_Gromov
true .

?- ask_question("how many brothers does Aleksandr_Gromov have?").
Aleksandr_Gromov has 1 brother
true .
```

## Выводы

Выполняя курсовой проект, я понял, как близок Prolog к нашему естественному языку. Как можно выдать сущности хорошее определение и программа ее найдет. Создается ощущение, что программист на Prolog будто объясняет ребенку, кто такой деверь и ребенок сам находит ее на родовом дереве. К тому же, здесь мы имеем дело с вполне реалистичными понятиями, которыми мы апеллируем в мозгу не задумываясь, так как они для нас привычны.
