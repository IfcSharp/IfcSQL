echo // ifcSQL_for_PrjSel_db_generated.cs, Copyright (c) 2020, Bernhard Simon Bock, Friedrich Eder, MIT License (see https://github.com/IfcSharp/IfcSharpLibrary/tree/master/Licence) > ifcSQL_for_PrjSel_db_generated.cs
sqlcmd -S%SqlServer%  -dSchemaEvaluation -Q"EXECUTE [SchemaEvaluation].[dbo].[print_CS] 'ifcSQL',7,'ifcSQL_PrjSel','_ifcSQL_for_PrjSel','ifcSQL'" >> ifcSQL_for_PrjSel_db_generated.cs

pause

