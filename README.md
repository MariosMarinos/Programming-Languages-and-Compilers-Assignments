# Programming-Languages-and-Compilers-Assignments
This is my assigment due to the course Programming Languages and Compilers in the 8th semester.
The first folder, exec1_netlogo, contains a simlpe LL(1) grammar using the flex tool in order to parse it and make lexical analysis and syntax analysis.

run on ubuntu enviroment : get into the folder, use make command and then run on command line ./netlogo <file_name> and it will return Success if its lexical and syntactical correct according to the grammar defined by the assignemnt.

The second folder, exec2_AgentSpeak, contains a simple LR grammar using the flex in combination with bison tools. Here, the AgentSpeak.l (flex file) it's responsible only for the lexical analysis and the return of the lexical tokens. All the grammar is determined on the AgentSpeak.y (Bison file) and so the syntax errors come from this.     
