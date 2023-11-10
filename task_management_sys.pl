:-dynamic  task/4.

createTask(Id,Desc,User,Status):-
    \+ task(Id,Desc,User,Status),
    writeln("creating task"),
    assertz(task(Id,Desc,User,Status)), !.

createTask(Id,Desc,User,Status):-
    task(Id,Desc,User,Status),
    writeln("task has already been created").


assignTask(Id,User):-
    retract(task(Id,Desc,_,Status)),
    assertz(task(Id,Desc,User,Status)),
    writeln("Assigned new user").

markTrue(Id):-
    retract(task(Id,Desc,User,_)),
    assertz(task(Id,Desc,User,true)),
    writeln("Marked status as true").

displayUserTasks(User):-
    task(Id,Desc,User,Status),
    writeln("Id"+Id),
    writeln("Desc"+Desc),
    writeln("User"+User),
    writeln("Status"+Status),
    nl,
    fail.
displayUserTasks(_).

displayCompleteTasks(Status):-
    task(Id,Desc,User,Status),
    writeln("Id"+Id),
    writeln("Desc"+Desc),
    writeln("User"+User),
    writeln("Status"+Status),
    nl,
    fail.
displayCompleteTasks(_).

