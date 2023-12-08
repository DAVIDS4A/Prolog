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
oneOf(Index1, Index2, List, Element1, Element2) :-
    (member([Element1, _], List), member([Element2, _], List),
     (nth1(Index1, List, [Element1, _]), nth1(Index2, List, [Element2, _]), Index1 < Index2) ;
     (nth1(Index2, List, [Element1, _]), nth1(Index1, List, [Element2, _]), Index2 < Index1)).

% function to check when the line leaves the earliest from one stop to
% another
ligtot(Arret1, Arret2, Ligne, Horaire) :-
    ligne(Ligne, _, Arrets, [Depart, Intervalle, DernierDepart], _),
    member([Arret1, _], Arrets),
    member([Arret2, _], Arrets),
    oneOf(Index1, Index2, Arrets, Arret1, Arret2),
    addh(Depart, Intervalle, NextDepart),
    addh(NextDepart, -Intervalle, _LastPossibleDepart),
    addh(DernierDepart, -Intervalle, LastPossibleDepartRev),
    addh(Horaire, 0, HorairePlus0),
    addh(Horaire, 1439, HorairePlus1Day),
    (HorairePlus0 @=< NextDepart ; HorairePlus0 > 24) ;
    (HorairePlus0 @=< LastPossibleDepartRev ; HorairePlus1Day @>= DernierDepart),
    (Index1 == Index2 ; Index1 < Index2).


% function to check when the line leaves the latest from one stop to
% another
ligtard(Arret1, Arret2, Ligne, Horaire) :-
    ligne(Ligne, _, Arrets, [_, Intervalle, DernierDepart], _Retour),
    member([Arret1, _], Arrets),
    member([Arret2, _], Arrets),
    oneOf(Index1, Index2, Arrets, Arret1, Arret2),
    addh(DernierDepart, 0, LastPossibleDepart),
    addh(LastPossibleDepart, -Intervalle, FirstPossibleDepart),
    addh(Horaire, 0, HorairePlus0),
    addh(Horaire, 1439, HorairePlus1Day),
    addh(FirstPossibleDepart, 0, _FirstPossibleDepartPlus0),
    (HorairePlus0 @>= FirstPossibleDepart ; HorairePlus1Day @=< DernierDepart),
    (Index1 == Index2 ; Index1 < Index2).


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
  write('Choisissez une station de départ: '),
  read_line_to_string(user_input, StationDepart),
  nl,
  write('Choisissez une station d\'arrivée: '),
  read_line_to_string(user_input, StationArrivee),
  nl,
  write('Choisissez une ligne: '),
  read_line_to_string(user_input, Ligne),
  nl,
  write('A quelle Heure: '),
  read_line_to_string(user_input, Temps),
  nl,
  %departure time to a single integer
  [Heure, Minute] = Temps,
  TotalMinutes is Heure * 60 + Minute,
  Departure is TotalMinutes,

  (ligtard(StationDepart, StationArrivee, Ligne, Departure) ; ligtot(StationDepart, StationArrivee, Ligne, Departure)),
  write('Trajet trouvé: '), write([StationDepart, 'to', StationArrivee, 'via', Ligne, 'at', Temps]).
