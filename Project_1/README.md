# Calculation_of_Public_Transport_Routes

Overview
-This program calculates public transport routes between stations based on predefined schedules and stops.

Prerequisites
- Prolog installed on your system. [Download Prolog](https://www.swi-prolog.org/Download.html)

Running the Program
1.Clone the Repository:
   
   git clone https://github.com/DAVIDS4A/Prolog/Project_1/Calculation_of_Public_Transport_Routes.git
   
   
2.Navigate to the Directory:
   
   cd public-transport-route-calculator
   

3.Launch Prolog:
   
   swipl
   

4.Load the Program:
   In the Prolog console, load the main file:
   
   [main_file_name]. % Replace 'main_file_name' with the actual name of the Prolog file
   

5.Run the Program:
   Once the file is loaded, execute the `interfaceUtilisateur/0` predicate:

   interfaceUtilisateur.
   

6.Follow On-Screen Instructions:
   - The program will display available stations served by public transport.
   - Enter the desired departure and arrival stations as prompted.
   - The program will calculate and display the route between the specified stations.

7.Exiting the Program:
   - To exit the Prolog console, type `halt.` or use the appropriate exit command for your system.

Note:
- Ensure that the input station names match the station names listed in the program's data.
- If no route is found, the program will display a corresponding message.
- For any issues or questions, refer to the provided documentation or contact the maintainer.

Example Queries:
Here are some sample queries you can try in the Prolog console:
- Query 1: `interfaceUtilisateur.`

--Output--

?- interfaceUtilisateur.
Stations desservies par les transports publics:
Ligne 1: [arret1,arret2,arret3,arret4]
Ligne a: [stationA,stationB,stationC,stationD]
Ligne 256: [stop1,stop2,stop3,stop4]

Choisissez une station de départ: stattionA

Choisissez une station d'arrivée: stattionB

false.
Choisissez une station de départ:
- Query 2: `addh([13, 34], 30, [14, 4]).` then `addh([13, 34], 30, [13, 4]).`

--Output--

?- addh([13, 34], 30, [14, 4]).
true.

?- addh([13, 34], 30, [13, 4]).
false.
- Query 2: `ligtard(stationA, stationB, Line, Time).`

--Output--

?- ligtard(stationA, stationB, Line, Time).
false.

- Query 3: `itinTot(station1, station2, [7, 0], Route).`

--Output--

?- itinTot(station1, station2, [7, 0], Route).
false.

Contributing
Contributions are welcome! Fork the repository, make changes, and submit a pull request.

License
This project is licensed under the [MIT License](LICENSE).

