-- Database-schema of ifcSQL, Copyright (c) 2021, Bernhard Simon Bock, Friedrich Eder, MIT License (see https://github.com/IfcSharp/IfcSharpLibrary/tree/master/Licence)
-- this database runs on Microsoft SQL Server 2019, earlier versions don't support UTF-8
-- this database was testet on Microsoft SQL Server 2019 EXPRESS

EXEC [ifcSQL].sys.sp_addextendedproperty @name=N'ifcSQL', @value=N'Release 1.7 (published on ifcSharp in march 2024)' 
GO

USE [ifcSQL]
GO

CREATE SCHEMA [_____TEST_____]
GO
CREATE SCHEMA [app]
GO
CREATE SCHEMA [Bool]
GO
CREATE SCHEMA [bSDD]
GO
CREATE SCHEMA [COBie]
GO
CREATE SCHEMA [cp]
GO
CREATE SCHEMA [cs]
GO
CREATE SCHEMA [Direction3d]
GO
CREATE SCHEMA [ExpressImport]
GO
CREATE SCHEMA [ifcAPI]
GO
CREATE SCHEMA [ifcDocumentation]
GO
CREATE SCHEMA [ifcEnum]
GO
CREATE SCHEMA [ifcInstance]
GO
CREATE SCHEMA [ifcLayer]
GO
CREATE SCHEMA [ifcOrder]
GO
CREATE SCHEMA [ifcProject]
GO
CREATE SCHEMA [ifcProperty]
GO
CREATE SCHEMA [ifcQuantityTakeOff]
GO
CREATE SCHEMA [ifcSchema]
GO
CREATE SCHEMA [ifcSchemaDerived]
GO
CREATE SCHEMA [ifcSchemaEvaluation]
GO
CREATE SCHEMA [ifcSchemaTool]
GO
CREATE SCHEMA [ifcSpecification]
GO
CREATE SCHEMA [ifcSQL]
GO
CREATE SCHEMA [ifcType]
GO
CREATE SCHEMA [ifcUnit]
GO
CREATE SCHEMA [ifcUser]
GO
CREATE SCHEMA [IO]
GO
CREATE SCHEMA [Point3d]
GO
CREATE SCHEMA [Project]
GO
CREATE SCHEMA [Text]
GO
CREATE SCHEMA [Vector2d]
GO
CREATE SCHEMA [Vector3d]
GO
CREATE SCHEMA [html]
GO


CREATE TYPE [Bool].[YesNo] FROM [bit] NOT NULL
GO
CREATE TYPE [Direction3d].[X] FROM [float] NULL
GO
CREATE TYPE [Direction3d].[Y] FROM [float] NULL
GO
CREATE TYPE [Direction3d].[Z] FROM [float] NULL
GO
CREATE TYPE [ifcEnum].[Id] FROM [int] NULL
GO
CREATE TYPE [ifcInstance].[Id] FROM [bigint] NULL
GO
CREATE TYPE [ifcLayer].[Id] FROM [int] NULL
GO
CREATE TYPE [ifcOrder].[Position] FROM [int] NULL
GO
CREATE TYPE [ifcProject].[Id] FROM [int] NULL
GO
CREATE TYPE [ifcProperty].[Id] FROM [int] NULL
GO
CREATE TYPE [ifcSchema].[GroupId] FROM [int] NULL
GO
CREATE TYPE [ifcSchema].[Id] FROM [int] NULL
GO
CREATE TYPE [ifcSchema].[IndexableName] FROM [nvarchar](80) NULL
GO
CREATE TYPE [ifcType].[ifcBINARY] FROM [varbinary](max) NULL
GO
CREATE TYPE [ifcType].[ifcBOOLEAN] FROM [bit] NULL
GO
CREATE TYPE [ifcType].[ifcINTEGER] FROM [int] NULL
GO
CREATE TYPE [ifcType].[ifcREAL] FROM [float] NULL
GO
CREATE TYPE [ifcType].[ifcSTRING] FROM [nvarchar](max) NULL
GO
CREATE TYPE [ifcType].[IfdGuid] FROM [nvarchar](32) NULL
GO
CREATE TYPE [IO].[FileName] FROM [nvarchar](250) NULL
GO
CREATE TYPE [IO].[PathName] FROM [nvarchar](250) NULL
GO
CREATE TYPE [IO].[URL] FROM [nvarchar](250) NULL
GO
CREATE TYPE [Point3d].[X] FROM [float] NULL
GO
CREATE TYPE [Point3d].[Y] FROM [float] NULL
GO
CREATE TYPE [Point3d].[Z] FROM [float] NULL
GO
CREATE TYPE [Text].[Description] FROM [nvarchar](max) NULL
GO
CREATE TYPE [Text].[Email] FROM [nvarchar](max) NULL
GO
CREATE TYPE [Text].[Expression] FROM [nvarchar](max) NULL
GO
CREATE TYPE [Text].[Html] FROM [nvarchar](max) NULL
GO
CREATE TYPE [Text].[Key] FROM [nvarchar](80) NULL
GO
CREATE TYPE [Text].[Login] FROM [nvarchar](80) NULL
GO
CREATE TYPE [Text].[Name] FROM [nvarchar](max) NULL
GO
CREATE TYPE [Text].[ToString] FROM [nvarchar](max) NULL
GO
CREATE TYPE [Vector2d].[X] FROM [float] NULL
GO
CREATE TYPE [Vector2d].[Y] FROM [float] NULL
GO
CREATE TYPE [Vector3d].[X] FROM [float] NULL
GO
CREATE TYPE [Vector3d].[Y] FROM [float] NULL
GO
CREATE TYPE [Vector3d].[Z] FROM [float] NULL
GO
CREATE TYPE [html].[RgbHex] FROM [char](7) NULL
GO
