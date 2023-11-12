domains
	list=integer*
	listOfList=list*
	len=integer
	index=integer
	elem=integer
predicates
	inputList(list).
	inputIndex(index).
	length(list, len).
	find(list, index, elem).
	insert_after(elem, index, list, list).
	insert_after(elem, index, list, index, list).
	compare_update_elements(list, list).
	compare_update_elements(list, len, index, list).
clauses
	inputList([H|T]) :- 
		write("elem --> "), readint(H), !, 
		inputList(T).
	inputList([]).
	
	inputIndex(Elem) :- readInt(Elem).
 
	length([], 0) :- !.
	length([_|T], Len) :-
		length(T, TLen),
		Len = TLen + 1.
 	
 	find([H|_], 1, H).
 	find([_|T], N, R) :-
 		N1 = N - 1,
 		find(T, N1, R).

	% Оболочка для вставки
	insert_after(Element, Index, List, Result) :-
    		insert_after(Element, Index, List, 0, Result).

	% Если индексы равын то в результирующий массив добавляем новый элемент и в конец передаём всё, что осталось
	insert_after(Element, Index, [Head|Tail], Index, [Element|Rest]) :-
		!, % Обрываем поиск после достижения нужного индекса
		Rest = [Head|Tail].

	% Если не достигли нужного индекса, то переходим дальше и вызываем метод заново
	insert_after(Element, Index, [Head|Tail], CurrentIndex, [Head|ResultTail]) :-
		NewIndex = CurrentIndex + 1,
		insert_after(Element, Index, Tail, NewIndex, ResultTail).

	% Если индекс больше длины списка, вставляем в конец
	insert_after(Element, _, [], _, [Element]).

	% Начало сравнения
	compare_update_elements(Array, UpdatedArray) :-
		length(Array, Len),
		compare_update_elements(Array, Len, 2, UpdatedArray).

	% Базовый случай: достигли середины массива
	compare_update_elements(Array, Len, Index, Array) :-
		Index > Len / 2.

	% Случай 1: значения равны, переходим к следующему индексу
	compare_update_elements(Array, Len, Index, UpdatedArray) :-
		Index <= Len / 2,
		OtherIndex = Len - Index + 1,
		find(Array, Index, V1),
		find(Array, OtherIndex, V2),
		V1 = V2,
		NextIndex = Index + 1,
		compare_update_elements(Array, Len, NextIndex, UpdatedArray).

	% Случай 2: значения не равны, обновляем массив и переходим к следующему индексу
	compare_update_elements(Array, Len, Index, UpdatedArray) :-
		Index <= Len / 2,
		OtherIndex = Len - Index + 1,
		find(Array, Index, V1),
		find(Array, OtherIndex, V2),
		V1 <> V2,
		
		% Вставляем i-й элемент после элемента на позиции len-i+1
		insert_after(V1, OtherIndex, Array, TempArray),
		
		% Пересчитываем длину
		length(TempArray, NewLen),
		
		% Рекурсивный вызов для следующего индекса
		NextIndex = Index + 1,
		compare_update_elements(TempArray, NewLen, NextIndex, UpdatedArray).

goal
	clearwindow, 
	write("Create an array"), nl, !,
	inputList(L),
	write("Array --> ", L), nl,
	compare_update_elements(L, UpL), nl,
	write("Updated --> ", UpL).
	