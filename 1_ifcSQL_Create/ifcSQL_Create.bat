REM Database-schema of ifcSQL, Copyright (c) 2021, Bernhard Simon Bock, Friedrich Eder, MIT License (see https://github.com/IfcSharp/IfcSharpLibrary/tree/master/Licence)
REM This database runs on Microsoft SQL Server 2019 or higher, earlier versions don't support UTF-8
REM The database was testet on Microsoft SQL Server 2019 EXPRESS and 2022 EXPRESS 

SET ifcSQL=ifcSQL
if "%SqlServer%"=="" GOTO UseYourServerName
if "%ifcSQL%" NEQ "ifcSQL" echo "The DatabaseName should be ifcSQL"
pause
REM set a REM before the following line, if the ifcSQL-database allready exist
sqlcmd -S %SqlServer% -i ifcSQL_1_CreateDatabase.sql
pause
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSQL_2_CreateSchemata_and_types.sql
pause
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSQL_3_CreateFunctions.sql
pause
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSQL_4_CreateTables.sql
pause
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSQL_5_CreateViews.sql
pause
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSQL_6_CreateTableConstraints.sql
pause
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSQL_7_CreateProcedures.sql
pause
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSQL_8_CreateTriggers.sql
pause
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSQL_9_DisableTrigger.sql
pause
goto end
:UseYourServerName
echo Please set the enviroment variable "SqlServer" to your SqlServername. Use "sqlcmd /L" to get the installed servernames.
:end
pause
