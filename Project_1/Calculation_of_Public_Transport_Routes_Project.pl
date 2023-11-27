
ligne(1, bus,
    [
        [arret1, 5],
        [arret2, 8],
        [arret3, 10],
        [arret4, 12]
    ],
    [[6, 0], 15, [20, 0]],
    [[6, 30], 20, [21, 0]]
).

ligne(a, metro,
    [
        [stationA, 3],
        [stationB, 5],
        [stationC, 7],
        [stationD, 10]
    ],
    [[7, 0], 10, [22, 0]],
    [[7, 15], 12, [22, 15]]
).

ligne(256, tram,
    [
        [stop1, 2],
        [stop2, 5],
        [stop3, 8],
        [stop4, 12]
    ],
    [[8, 0], 8, [23, 0]],
    [[8, 10], 15, [23, 30]]
).

%Add Time function
addh([H, M], MinutesToAdd, [NewH, NewM]) :-
    TotalMinutes is H * 60 + M + MinutesToAdd,
    NewH is TotalMinutes // 60,
    NewM is TotalMinutes mod 60.

%Display time function
affiche([H, M]) :-
    format('~|~`0t~d~2+:~|~`0t~d~2+~n', [H, M]).

%function to verify if a line passes one stop to another
lig(Arret1, Arret2, Ligne) :-
    ligne(Ligne, _, Arrets, _, _),
    member([Arret1, _], Arrets),
    member([Arret2, _], Arrets),
    nth1(Index1, Arrets, [Arret1, _]),
    nth1(Index2, Arrets, [Arret2, _]),
    Index1 < Index2.
% function to check when the line leaves the earliest from one stop to
% another
ligtot(Arret1, Arret2, Ligne, Horaire) :-
    ligne(Ligne, _, Arrets, [Depart, Intervalle, _DernierDepart], _),
    member([Arret1, _], Arrets),
    member([Arret2, _], Arrets),
    nth1(Index1, Arrets, [Arret1, _]),
    nth1(Index2, Arrets, [Arret2, _]),
    Index1 < Index2,
    addh(Depart, Intervalle, NextDepart),
    addh(NextDepart, -Intervalle, LastPossibleDepart),
    addh(Horaire, 0, HorairePlus0),
    addh(Horaire, 1439, HorairePlus1Day),
    addh(LastPossibleDepart, 0, LastPossibleDepartPlus0),
    (HorairePlus0 @=< NextDepart ; HorairePlus1Day @>= LastPossibleDepartPlus0).

% function to check when the line leaves the latest from one stop to
% another
ligtard(Arret1, Arret2, Ligne, Horaire) :-
    ligne(Ligne, _, Arrets, [_, Intervalle, _], Retour),
    member([Arret1, _], Arrets),
    member([Arret2, _], Arrets),
    nth1(Index1, Arrets, [Arret1, _]),
    nth1(Index2, Arrets, [Arret2, _]),
    Index1 < Index2,
    addh(Retour, 0, DernierDepart),
    addh(DernierDepart, -Intervalle, FirstPossibleDepart),
    addh(Horaire, 0, HorairePlus0),
    addh(Horaire, 1439, HorairePlus1Day),
    addh(FirstPossibleDepart, 0, _FirstPossibleDepartPlus0),
    (HorairePlus0 @>= FirstPossibleDepart ; HorairePlus1Day @=< DernierDepart).

itinTot(Arret1, Arret2, Horaire, [Arret1, Horaire, Arret2]) :-
    ligtot(Arret1, Arret2, _, Horaire).

itinTot(Arret1, Arret2, Horaire, [Arret1, Horaire, ArretX | Rest]) :-
    ligtot(Arret1, ArretX, _, Horaire),
    itinTot(ArretX, Arret2, _, [ArretX, _, Arret2 | Rest]).

itinTard(Arret1, Arret2, Horaire, [Arret1, Horaire, Arret2]) :-
    ligtard(Arret1, Arret2, _, Horaire).

itinTard(Arret1, Arret2, Horaire, [Arret1, Horaire, ArretX | Rest]) :-
    ligtard(Arret1, ArretX, _, Horaire),
    itinTard(ArretX, Arret2, _, [ArretX, _, Arret2 | Rest]).

% Base case: If the list is empty, no stations are extracted.
extractStations([], []).

% Extracts station names from the list of stops
extractStations([[StationName, _] | Rest], [StationName | StationList]) :-
    extractStations(Rest, StationList).


afficheStations(_Lignes) :-
    forall(
        ligne(Nom, _, Arrets, _, _),
        (
            write('Ligne '), write(Nom), write(': '),
            extractStations(Arrets, Stations),
            write(Stations), nl
        )
    ).

interfaceUtilisateur :-
    write('Stations desservies par les transports publics:'), nl,
    afficheStations(_), nl,
    write('Choisissez une station de d�part: '),
    read_line_to_string(user_input, StationDepart), % Read input as a string
    nl,
    write('Choisissez une station d\'arriv�e: '),
    read_line_to_string(user_input, StationArrivee), % Read input as a string
    nl,
    % Add other options if necessary
    % Use the defined predicates to find the route

    % Placeholder logic to find the route
    (ligtard(StationDepart, StationArrivee, Ligne, Horaire) ; ligtot(StationDepart, StationArrivee, Ligne, Horaire)),
    write('Trajet trouv�: '), write([StationDepart, 'to', StationArrivee, 'via', Ligne, 'at', Horaire]).
