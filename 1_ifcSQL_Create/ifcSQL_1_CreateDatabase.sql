-- Database-schema of ifcSQL, Copyright (c) 2021, Bernhard Simon Bock, Friedrich Eder, MIT License (see https://github.com/IfcSharp/IfcSharpLibrary/tree/master/Licence)
-- this database runs on Microsoft SQL Server 2019, earlier versions don't support UTF-8
-- this database was testet on Microsoft SQL Server 2019 EXPRESS

USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE DATABASE [ifcSQL]
COLLATE LATIN1_GENERAL_100_CS_AS_SC_UTF8
GO

USE [ifcSQL]
GO

/*
CREATE DATABASE [ifcSQL]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ifcSQL', FILENAME = N'C:\Program Files\Microsoft SQL Server 2019 Express\MSSQL15.SQLEXPRESS\MSSQL\DATA\ifcSQL4.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ifcSQL_log', FILENAME = N'C:\Program Files\Microsoft SQL Server 2019 Express\MSSQL15.SQLEXPRESS\MSSQL\DATA\ifcSQL4_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
COLLATE LATIN1_GENERAL_100_CS_AS_SC_UTF8
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
*/