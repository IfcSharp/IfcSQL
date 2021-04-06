  
-- Database-schema of ifcSQL, Copyright (c) 2021, Bernhard Simon Bock, Friedrich Eder, MIT License (see https://github.com/IfcSharp/IfcSharpLibrary/tree/master/Licence)
-- this database runs on Microsoft SQL Server 2019, earlier versions don't support UTF-8
-- this database was testet on Microsoft SQL Server 2019 EXPRESS

USE master;  
GO  
ALTER DATABASE ifcSQL SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
ALTER DATABASE ifcSQL MODIFY NAME = ifcSQL4 ;
GO  
ALTER DATABASE ifcSQL4 SET MULTI_USER
GO
