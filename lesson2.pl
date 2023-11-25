member(X, [X | _]).
member(X, [_ | Tail]) :- member(X, Tail).

first(E, [E | _]).

last(X, [X]).
last(X, [_ | Tail]) :- last(X, Tail).


penultimate(X, [X, _]).
penultimate(X, [_ | Tail]) :- penultimate(X, Tail).


del_k(X, [X | L], 1, L).
del_k(X, [Y | L1], K, [Y | L2]) :- K > 1, K1 is K - 1, del_k(X, L1, K1, L2).


len([], 0).
len([_| Tail], N) :- len(Tail, N1), N is N1 + 1.

even(L) :- len(L, N), N mod 2 =:= 0.


concat([], L, L).
concat([X | L1], L2, [X | L3]) :- concat(L1, L2, L3).




palindrome([]).
palindrome([_]).
palindrome([X | L]) :- append(Mid, [X], L), palindrome(Mid).
