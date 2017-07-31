-- for Inner Join purpose, we can use JOIN or INNER JOIN

SELECT 
	players.name AS name,
	players.school AS school,
	teams.conferences AS conference
FROM testDB_player players 
JOIN testDB_teams teams
ON teams.school = players.school
WHERE teams.devision = 'Division SouthEast'
ORDER BY school
/*
for above query
If there are multiple schools in the teams table with the same name, each one of those rows will get joined to matching rows in the players table. 
If there were three rows in the teams table with same school_name, the join query above would return three rows with corresponding player name.

e.g.
Aaron Bailey	    Illinois	  Big Ten
Aaron Bailey	    Missouri	  SEC
Aaron Bailey	    Washington	  Knight
...
Aaron Del Grosso	Indiana	      Big Ten
Aaron Del Grosso	Indiana	      Big Ten
Aaron Del Grosso	Indiana	      Big Ten
...
*/