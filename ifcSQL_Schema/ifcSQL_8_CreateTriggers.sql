-- Database-schema of ifcSQL, Copyright (c) 2021, Bernhard Simon Bock, Friedrich Eder, MIT License (see https://github.com/IfcSharp/IfcSharpLibrary/tree/master/Licence)
-- this database runs on Microsoft SQL Server 2019, earlier versions don't support UTF-8
-- this database was testet on Microsoft SQL Server 2019 EXPRESS

USE [ifcSQL]
GO

CREATE TRIGGER [ifcAPI].[ComputerLanguage_AfterDeleteTrigger] ON [ifcAPI].[ComputerLanguage]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcAPI','ComputerLanguage'
END
GO 

CREATE TRIGGER [ifcAPI].[ComputerLanguage_AfterInsertTrigger] ON [ifcAPI].[ComputerLanguage]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcAPI','ComputerLanguage'
END
GO 

CREATE TRIGGER [ifcAPI].[ComputerLanguage_AfterUpdateTrigger] ON [ifcAPI].[ComputerLanguage]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcAPI','ComputerLanguage'
END
GO 


CREATE TRIGGER [ifcAPI].[TypeComputerLanguageAssignment_AfterDeleteTrigger] ON [ifcAPI].[TypeComputerLanguageAssignment]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcAPI','TypeComputerLanguageAssignment'
END
GO

CREATE TRIGGER [ifcAPI].[TypeComputerLanguageAssignment_AfterInsertTrigger] ON [ifcAPI].[TypeComputerLanguageAssignment]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcAPI','TypeComputerLanguageAssignment'
END
GO 


CREATE TRIGGER [ifcAPI].[TypeComputerLanguageAssignment_AfterUpdateTrigger] ON [ifcAPI].[TypeComputerLanguageAssignment]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcAPI','TypeComputerLanguageAssignment'
END
GO 


CREATE TRIGGER [ifcDocumentation].[HumanLanguage_AfterDeleteTrigger] ON [ifcDocumentation].[NaturalLanguage]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcDocumentation','HumanLanguage'
END
GO 


CREATE TRIGGER [ifcDocumentation].[HumanLanguage_AfterInsertTrigger] ON [ifcDocumentation].[NaturalLanguage]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcDocumentation','HumanLanguage'
END
GO 


CREATE TRIGGER [ifcDocumentation].[HumanLanguage_AfterUpdateTrigger] ON [ifcDocumentation].[NaturalLanguage]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcDocumentation','HumanLanguage'
END
GO 


CREATE TRIGGER [ifcDocumentation].[Type_AfterDeleteTrigger] ON [ifcDocumentation].[Type]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcDocumentation','Type'
END
GO 


CREATE TRIGGER [ifcDocumentation].[Type_AfterInsertTrigger] ON [ifcDocumentation].[Type]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcDocumentation','Type'
END
GO 


CREATE TRIGGER [ifcDocumentation].[Type_AfterUpdateTrigger] ON [ifcDocumentation].[Type]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcDocumentation','Type'
END

GO
CREATE TRIGGER [ifcInstance].[EntityAfterUpdateTrigger] ON [ifcInstance].[Entity]
AFTER UPDATE
AS
BEGIN
IF ( UPDATE (EntityTypeId) )   BEGIN
IF NOT EXISTS(SELECT EntityTypeId  FROM inserted i inner join ifcSchema.Type t on i.EntityTypeId=t.TypeId where t.TypeGroupId=5) 
BEGIN -- #################################################################################
declare @msg as nvarchar(max); set @msg = 'EntityTypeId=' +  CAST((select EntityTypeId from  inserted) AS NVARCHAR(MAX)) + ' not allowed'
RAISERROR (@msg, 16, 10);  
END
 
END


END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [ifcInstance].[EntityInsteadOfInsertTrigger] ON [ifcInstance].[Entity]
INSTEAD OF INSERT
AS
BEGIN
IF EXISTS(SELECT EntityTypeId  FROM inserted i inner join ifcSchema.Type t on i.EntityTypeId=t.TypeId where t.TypeGroupId=5) 
BEGIN -- #################################################################################
INSERT INTO [ifcInstance].[Entity] SELECT * FROM inserted
END -- ###################################################################################
else
begin
declare @msg as nvarchar(max); set @msg = 'EntityTypeId=' +  CAST((select EntityTypeId from  inserted) AS NVARCHAR(MAX)) + ' not allowed'
RAISERROR (@msg, 16, 10);  
 
end
 
END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [ifcInstance].[EntityAttributeOfBinaryAfterUpdateTrigger] ON [ifcInstance].[EntityAttributeOfBinary]
AFTER UPDATE
AS
BEGIN
IF ( UPDATE (TypeId) )   BEGIN
IF NOT EXISTS(SELECT i.TypeId  FROM inserted i inner join ifcSchema.Type t on i.TypeId=t.TypeId where t.[EntityAttributeTableId]=1) 
BEGIN -- #################################################################################
declare @msg as nvarchar(max); set @msg = 'TypeId=' +  CAST((select TypeId from  inserted) AS NVARCHAR(MAX)) + ' not allowed for EntityAttributeOfBinary'
RAISERROR (@msg, 16, 10);  
END
 
END


END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [ifcInstance].[EntityAttributeOfBinaryInsteadOfInsertTrigger] ON [ifcInstance].[EntityAttributeOfBinary]
INSTEAD OF INSERT
AS
BEGIN

-- hier noch Dimensionsprüfung

IF EXISTS(SELECT i.TypeId  FROM inserted i inner join ifcSchema.Type t on i.TypeId=t.TypeId where t.[EntityAttributeTableId]=1) 
BEGIN -- #################################################################################
INSERT INTO [ifcInstance].[EntityAttributeOfBinary] SELECT * FROM inserted
END -- ###################################################################################
else
begin
declare @msg as nvarchar(max); set @msg = 'TypeId=' +  CAST((select TypeId from  inserted) AS NVARCHAR(MAX)) + ' not allowed for EntityAttributeOfBinary'
RAISERROR (@msg, 16, 10);  
 
end
 
END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [ifcInstance].[EntityAttributeOfBooleanAfterUpdateTrigger] ON [ifcInstance].[EntityAttributeOfBoolean]
AFTER UPDATE
AS
BEGIN
IF ( UPDATE (TypeId) )   BEGIN
IF NOT EXISTS(SELECT i.TypeId  FROM inserted i inner join ifcSchema.Type t on i.TypeId=t.TypeId where t.[EntityAttributeTableId]=2) 
BEGIN -- #################################################################################
declare @msg as nvarchar(max); set @msg = 'TypeId=' +  CAST((select TypeId from  inserted) AS NVARCHAR(MAX)) + ' not allowed for EntityAttributeOfBoolean'
RAISERROR (@msg, 16, 10);  
END
 
END

END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [ifcInstance].[EntityAttributeOfBooleanInsteadOfInsertTrigger] ON [ifcInstance].[EntityAttributeOfBoolean]
INSTEAD OF INSERT
AS
BEGIN

-- hier noch Dimensionsprüfung

IF EXISTS(SELECT i.TypeId  FROM inserted i inner join ifcSchema.Type t on i.TypeId=t.TypeId where t.[EntityAttributeTableId]=2) 
BEGIN -- #################################################################################
INSERT INTO [ifcInstance].[EntityAttributeOfBoolean] SELECT * FROM inserted
END -- ###################################################################################
else
begin
declare @msg as nvarchar(max); set @msg = 'TypeId=' +  CAST((select TypeId from  inserted) AS NVARCHAR(MAX)) + ' not allowed for EntityAttributeOfBoolean'
RAISERROR (@msg, 16, 10);  
 
end
 
END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [ifcInstance].[EntityAttributeOfEntityRefAfterUpdateTrigger] ON [ifcInstance].[EntityAttributeOfEntityRef]
AFTER UPDATE
AS
BEGIN
IF ( UPDATE (TypeId) )   BEGIN
IF NOT EXISTS(SELECT i.TypeId  FROM inserted i inner join ifcSchema.Type t on i.TypeId=t.TypeId where t.[EntityAttributeTableId]=3) 
BEGIN -- #################################################################################
declare @msg as nvarchar(max); set @msg = 'TypeId=' +  CAST((select TypeId from  inserted) AS NVARCHAR(MAX)) + ' not allowed for EntityAttributeOfEntityRef'
RAISERROR (@msg, 16, 10);  
END
 
END

END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [ifcInstance].[EntityAttributeOfEntityRefInsteadOfInsertTrigger] ON [ifcInstance].[EntityAttributeOfEntityRef]
INSTEAD OF INSERT
AS
BEGIN

-- hier noch Dimensionsprüfung

IF EXISTS(SELECT i.TypeId  FROM inserted i inner join ifcSchema.Type t on i.TypeId=t.TypeId where t.[EntityAttributeTableId]=3) 
BEGIN -- #################################################################################
INSERT INTO [ifcInstance].[EntityAttributeOfEntityRef] SELECT * FROM inserted
END -- ###################################################################################
else
begin
declare @msg as nvarchar(max); set @msg = 'TypeId=' +  CAST((select TypeId from  inserted) AS NVARCHAR(MAX)) + ' not allowed for EntityAttributeOfEntityRef'
RAISERROR (@msg, 16, 10);  
 
end
 
END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [ifcInstance].[EntityAttributeOfEnumAfterUpdateTrigger] ON [ifcInstance].[EntityAttributeOfEnum]
AFTER UPDATE
AS
BEGIN
IF ( UPDATE (TypeId) )   BEGIN
IF NOT EXISTS(SELECT i.TypeId  FROM inserted i inner join ifcSchema.Type t on i.TypeId=t.TypeId where t.[EntityAttributeTableId]=4) 
BEGIN -- #################################################################################
declare @msg as nvarchar(max); set @msg = 'TypeId=' +  CAST((select TypeId from  inserted) AS NVARCHAR(MAX)) + ' not allowed for EntityAttributeOfEnum'
RAISERROR (@msg, 16, 10);  
END
 
END

END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [ifcInstance].[EntityAttributeOfEnumInsteadOfInsertTrigger] ON [ifcInstance].[EntityAttributeOfEnum]
INSTEAD OF INSERT
AS
BEGIN

-- hier noch Dimensionsprüfung

IF EXISTS(SELECT i.TypeId  FROM inserted i inner join ifcSchema.Type t on i.TypeId=t.TypeId where t.[EntityAttributeTableId]=4) 
BEGIN -- #################################################################################
INSERT INTO [ifcInstance].[EntityAttributeOfEnum] SELECT * FROM inserted
END -- ###################################################################################
else
begin
declare @msg as nvarchar(max); set @msg = 'TypeId=' +  CAST((select TypeId from  inserted) AS NVARCHAR(MAX)) + ' not allowed for EntityAttributeOfEnum'
RAISERROR (@msg, 16, 10);  
 
end
 
END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [ifcInstance].[EntityAttributeOfIntegerAfterUpdateTrigger] ON [ifcInstance].[EntityAttributeOfInteger]
AFTER UPDATE
AS
BEGIN
IF ( UPDATE (TypeId) )   BEGIN
IF NOT EXISTS(SELECT i.TypeId  FROM inserted i inner join ifcSchema.Type t on i.TypeId=t.TypeId where t.[EntityAttributeTableId]=6) 
BEGIN -- #################################################################################
declare @msg as nvarchar(max); set @msg = 'TypeId=' +  CAST((select TypeId from  inserted) AS NVARCHAR(MAX)) + ' not allowed for EntityAttributeOfInteger'
RAISERROR (@msg, 16, 10);  
END
 
END

END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [ifcInstance].[EntityAttributeOfIntegerInsteadOfInsertTrigger] ON [ifcInstance].[EntityAttributeOfInteger]
INSTEAD OF INSERT
AS
BEGIN

-- hier noch Dimensionsprüfung

IF EXISTS(SELECT i.TypeId  FROM inserted i inner join ifcSchema.Type t on i.TypeId=t.TypeId where t.[EntityAttributeTableId]=6) 
BEGIN -- #################################################################################
INSERT INTO [ifcInstance].[EntityAttributeOfInteger] SELECT * FROM inserted
END -- ###################################################################################
else
begin
declare @msg as nvarchar(max); set @msg = 'TypeId=' +  CAST((select TypeId from  inserted) AS NVARCHAR(MAX)) + ' not allowed for EntityAttributeOfInteger'
RAISERROR (@msg, 16, 10);  
 
end
 
END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [ifcInstance].[EntityAttributeOfStringAfterUpdateTrigger] ON [ifcInstance].[EntityAttributeOfString]
AFTER UPDATE
AS
BEGIN
  IF ( UPDATE (TypeId) )   BEGIN
    IF NOT EXISTS(SELECT i.TypeId  FROM inserted i inner join ifcSchema.Type t on i.TypeId=t.TypeId where t.[EntityAttributeTableId]=7) 
      BEGIN declare @msg as nvarchar(max); set @msg = 'TypeId=' +  CAST((select TypeId from  inserted) AS NVARCHAR(MAX)) + ' not allowed for EntityAttributeOfString'
            RAISERROR (@msg, 16, 10);  
      END
  END
END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [ifcInstance].[EntityAttributeOfStringInsteadOfInsertTrigger] ON [ifcInstance].[EntityAttributeOfString]
INSTEAD OF INSERT
AS
BEGIN
  declare @GlobalEntityInstanceId [ifcInstance].[Id]=(select GlobalEntityInstanceId from inserted)
  declare @OrdinalPosition [ifcOrder].[Position]=(select OrdinalPosition from inserted)
  declare @TypeId [ifcSchema].[Id]=(select TypeId from inserted)
  IF ([ifcSchemaTool].[ValidEntityAtrributeType](@GlobalEntityInstanceId,@OrdinalPosition,@TypeId)=-1)
       INSERT INTO [ifcInstance].[EntityAttributeOfString] SELECT * FROM inserted
  ELSE EXEC [ifcSchemaTool].[ErrorEntityAtrributeType] @GlobalEntityInstanceId,@OrdinalPosition,@TypeId
END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 


CREATE TRIGGER [ifcProperty].[Def_AfterDeleteTrigger] ON [ifcProperty].[Def]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcProperty','Def'
END
GO 


CREATE TRIGGER [ifcProperty].[Def_AfterInsertTrigger] ON [ifcProperty].[Def]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcProperty','Def'
END
GO 


CREATE TRIGGER [ifcProperty].[Def_AfterUpdateTrigger] ON [ifcProperty].[Def]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcProperty','Def'
END
GO 


CREATE TRIGGER [ifcProperty].[DefAlias_AfterDeleteTrigger] ON [ifcProperty].[DefAlias]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcProperty','DefAlias'
END
GO 


CREATE TRIGGER [ifcProperty].[DefAlias_AfterInsertTrigger] ON [ifcProperty].[DefAlias]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcProperty','DefAlias'
END
GO 


CREATE TRIGGER [ifcProperty].[DefAlias_AfterUpdateTrigger] ON [ifcProperty].[DefAlias]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcProperty','DefAlias'
END
GO 


CREATE TRIGGER [ifcProperty].[SetDef_AfterDeleteTrigger] ON [ifcProperty].[SetDef]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcProperty','SetDef'
END
GO 


CREATE TRIGGER [ifcProperty].[SetDef_AfterInsertTrigger] ON [ifcProperty].[SetDef]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcProperty','SetDef'
END
GO 


CREATE TRIGGER [ifcProperty].[SetDef_AfterUpdateTrigger] ON [ifcProperty].[SetDef]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcProperty','SetDef'
END
GO 


CREATE TRIGGER [ifcProperty].[TypeComplexProperty_AfterDeleteTrigger] ON [ifcProperty].[TypeComplexProperty]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcProperty','TypeComplexProperty'
END
GO 


CREATE TRIGGER [ifcProperty].[TypeComplexProperty_AfterInsertTrigger] ON [ifcProperty].[TypeComplexProperty]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcProperty','TypeComplexProperty'
END
GO 


CREATE TRIGGER [ifcProperty].[TypeComplexProperty_AfterUpdateTrigger] ON [ifcProperty].[TypeComplexProperty]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcProperty','TypeComplexProperty'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertyBoundedValue_AfterDeleteTrigger] ON [ifcProperty].[TypePropertyBoundedValue]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcProperty','TypePropertyBoundedValue'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertyBoundedValue_AfterInsertTrigger] ON [ifcProperty].[TypePropertyBoundedValue]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcProperty','TypePropertyBoundedValue'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertyBoundedValue_AfterUpdateTrigger] ON [ifcProperty].[TypePropertyBoundedValue]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcProperty','TypePropertyBoundedValue'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertyEnumeratedValue_AfterDeleteTrigger] ON [ifcProperty].[TypePropertyEnumeratedValue]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcProperty','TypePropertyEnumeratedValue'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertyEnumeratedValue_AfterInsertTrigger] ON [ifcProperty].[TypePropertyEnumeratedValue]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcProperty','TypePropertyEnumeratedValue'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertyEnumeratedValue_AfterUpdateTrigger] ON [ifcProperty].[TypePropertyEnumeratedValue]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcProperty','TypePropertyEnumeratedValue'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertyListValue_AfterDeleteTrigger] ON [ifcProperty].[TypePropertyListValue]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcProperty','TypePropertyListValue'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertyListValue_AfterInsertTrigger] ON [ifcProperty].[TypePropertyListValue]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcProperty','TypePropertyListValue'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertyListValue_AfterUpdateTrigger] ON [ifcProperty].[TypePropertyListValue]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcProperty','TypePropertyListValue'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertyReferenceValue_AfterDeleteTrigger] ON [ifcProperty].[TypePropertyReferenceValue]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcProperty','TypePropertyReferenceValue'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertyReferenceValue_AfterInsertTrigger] ON [ifcProperty].[TypePropertyReferenceValue]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcProperty','TypePropertyReferenceValue'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertyReferenceValue_AfterUpdateTrigger] ON [ifcProperty].[TypePropertyReferenceValue]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcProperty','TypePropertyReferenceValue'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertySingleValue_AfterDeleteTrigger] ON [ifcProperty].[TypePropertySingleValue]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcProperty','TypePropertySingleValue'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertySingleValue_AfterInsertTrigger] ON [ifcProperty].[TypePropertySingleValue]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcProperty','TypePropertySingleValue'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertySingleValue_AfterUpdateTrigger] ON [ifcProperty].[TypePropertySingleValue]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcProperty','TypePropertySingleValue'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertyTableValue_AfterDeleteTrigger] ON [ifcProperty].[TypePropertyTableValue]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcProperty','TypePropertyTableValue'
END
GO 


CREATE TRIGGER [ifcProperty].[TypePropertyTableValue_AfterInsertTrigger] ON [ifcProperty].[TypePropertyTableValue]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcProperty','TypePropertyTableValue'
END
GO

CREATE TRIGGER [ifcProperty].[TypePropertyTableValue_AfterUpdateTrigger] ON [ifcProperty].[TypePropertyTableValue]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcProperty','TypePropertyTableValue'
END
GO 


CREATE TRIGGER [ifcQuantityTakeOff].[Def_AfterDeleteTrigger] ON [ifcQuantityTakeOff].[Def]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcQuantityTakeOff','Def'
END
GO 


CREATE TRIGGER [ifcQuantityTakeOff].[Def_AfterInsertTrigger] ON [ifcQuantityTakeOff].[Def]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcQuantityTakeOff','Def'
END
GO 


CREATE TRIGGER [ifcQuantityTakeOff].[Def_AfterUpdateTrigger] ON [ifcQuantityTakeOff].[Def]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcQuantityTakeOff','Def'
END
GO 


CREATE TRIGGER [ifcQuantityTakeOff].[DefAlias_AfterDeleteTrigger] ON [ifcQuantityTakeOff].[DefAlias]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcQuantityTakeOff','DefAlias'
END
GO 


CREATE TRIGGER [ifcQuantityTakeOff].[DefAlias_AfterInsertTrigger] ON [ifcQuantityTakeOff].[DefAlias]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcQuantityTakeOff','DefAlias'
END
GO 


CREATE TRIGGER [ifcQuantityTakeOff].[DefAlias_AfterUpdateTrigger] ON [ifcQuantityTakeOff].[DefAlias]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcQuantityTakeOff','DefAlias'
END
GO 


CREATE TRIGGER [ifcQuantityTakeOff].[SetDef_AfterDeleteTrigger] ON [ifcQuantityTakeOff].[SetDef]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcQuantityTakeOff','SetDef'
END
GO 


CREATE TRIGGER [ifcQuantityTakeOff].[SetDef_AfterInsertTrigger] ON [ifcQuantityTakeOff].[SetDef]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcQuantityTakeOff','SetDef'
END
GO 


CREATE TRIGGER [ifcQuantityTakeOff].[SetDef_AfterUpdateTrigger] ON [ifcQuantityTakeOff].[SetDef]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcQuantityTakeOff','SetDef'
END
GO 


CREATE TRIGGER [ifcQuantityTakeOff].[SetDefApplicableClass_AfterDeleteTrigger] ON [ifcQuantityTakeOff].[SetDefApplicableClass]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcQuantityTakeOff','SetDefApplicableClass'
END
GO 


CREATE TRIGGER [ifcQuantityTakeOff].[SetDefApplicableClass_AfterInsertTrigger] ON [ifcQuantityTakeOff].[SetDefApplicableClass]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcQuantityTakeOff','SetDefApplicableClass'
END
GO 


CREATE TRIGGER [ifcQuantityTakeOff].[SetDefApplicableClass_AfterUpdateTrigger] ON [ifcQuantityTakeOff].[SetDefApplicableClass]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcQuantityTakeOff','SetDefApplicableClass'
END
GO 


CREATE TRIGGER [ifcQuantityTakeOff].[Type_AfterDeleteTrigger] ON [ifcQuantityTakeOff].[Type]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcQuantityTakeOff','Type'
END
GO 


CREATE TRIGGER [ifcQuantityTakeOff].[Type_AfterInsertTrigger] ON [ifcQuantityTakeOff].[Type]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcQuantityTakeOff','Type'
END
GO 


CREATE TRIGGER [ifcQuantityTakeOff].[Type_AfterUpdateTrigger] ON [ifcQuantityTakeOff].[Type]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcQuantityTakeOff','Type'
END
GO 


CREATE TRIGGER [ifcSchema].[EntityAttribute_AfterDeleteTrigger] ON [ifcSchema].[EntityAttribute]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcSchema','EntityAttribute'
END
GO 


CREATE TRIGGER [ifcSchema].[EntityAttribute_AfterInsertTrigger] ON [ifcSchema].[EntityAttribute]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcSchema','EntityAttribute'
END
GO 


CREATE TRIGGER [ifcSchema].[EntityAttribute_AfterUpdateTrigger] ON [ifcSchema].[EntityAttribute]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcSchema','EntityAttribute'
END
GO 


CREATE TRIGGER [ifcSchema].[EntityInverseAssignment_AfterDeleteTrigger] ON [ifcSchema].[EntityInverseAssignment]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcSchema','EntityInverseAssignment'
END
GO 


CREATE TRIGGER [ifcSchema].[EntityInverseAssignment_AfterInsertTrigger] ON [ifcSchema].[EntityInverseAssignment]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcSchema','EntityInverseAssignment'
END
GO 


CREATE TRIGGER [ifcSchema].[EntityInverseAssignment_AfterUpdateTrigger] ON [ifcSchema].[EntityInverseAssignment]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcSchema','EntityInverseAssignment'
END
GO 


CREATE TRIGGER [ifcSchema].[EnumItem_AfterDeleteTrigger] ON [ifcSchema].[EnumItem]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcSchema','EnumItem'
END
GO 


CREATE TRIGGER [ifcSchema].[EnumItem_AfterInsertTrigger] ON [ifcSchema].[EnumItem]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcSchema','EnumItem'
END
GO 


CREATE TRIGGER [ifcSchema].[EnumItem_AfterUpdateTrigger] ON [ifcSchema].[EnumItem]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcSchema','EnumItem'
END
GO 


CREATE TRIGGER [ifcSchema].[Layer_AfterDeleteTrigger] ON [ifcSchema].[Layer]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcSchema','Layer'
END
GO 


CREATE TRIGGER [ifcSchema].[Layer_AfterInsertTrigger] ON [ifcSchema].[Layer]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcSchema','Layer'
END
GO 


CREATE TRIGGER [ifcSchema].[Layer_AfterUpdateTrigger] ON [ifcSchema].[Layer]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcSchema','Layer'
END
GO 


CREATE TRIGGER [ifcSchema].[SelectItem_AfterDeleteTrigger] ON [ifcSchema].[SelectItem]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcSchema','SelectItem'
END
GO 


CREATE TRIGGER [ifcSchema].[SelectItem_AfterInsertTrigger] ON [ifcSchema].[SelectItem]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcSchema','SelectItem'
END
GO 


CREATE TRIGGER [ifcSchema].[SelectItem_AfterUpdateTrigger] ON [ifcSchema].[SelectItem]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcSchema','SelectItem'
END
GO 


CREATE TRIGGER [ifcSchema].[Type_AfterDeleteTrigger] ON [ifcSchema].[Type]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcSchema','Type'
END
GO 


CREATE TRIGGER [ifcSchema].[Type_AfterInsertTrigger] ON [ifcSchema].[Type]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcSchema','Type'
END
GO 


CREATE TRIGGER [ifcSchema].[Type_AfterUpdateTrigger] ON [ifcSchema].[Type]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcSchema','Type'
END
GO 


CREATE TRIGGER [ifcSchema].[TypeGroup_AfterDeleteTrigger] ON [ifcSchema].[TypeGroup]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcSchema','TypeGroup'
END
GO 


CREATE TRIGGER [ifcSchema].[TypeGroup_AfterInsertTrigger] ON [ifcSchema].[TypeGroup]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcSchema','TypeGroup'
END
GO 


CREATE TRIGGER [ifcSchema].[TypeGroup_AfterUpdateTrigger] ON [ifcSchema].[TypeGroup]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcSchema','TypeGroup'
END
GO
CREATE TRIGGER [ifcSchemaTool].[ChangeLogType_AfterDeleteTrigger] ON [ifcSchemaTool].[ChangeLogType]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec ifcSchemaTool.AfterDeleteProc 'ifcSchemaTool','ChangeLogType'
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [ifcSchemaTool].[ChangeLogType_AfterInsertTrigger] ON [ifcSchemaTool].[ChangeLogType]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec ifcSchemaTool.AfterInsertProc 'ifcSchemaTool','ChangeLogType'
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [ifcSchemaTool].[ChangeLogType_AfterUpdateTrigger] ON [ifcSchemaTool].[ChangeLogType]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec ifcSchemaTool.AfterUpdateProc 'ifcSchemaTool','ChangeLogType'
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 


CREATE TRIGGER [ifcSpecification].[Specification_AfterDeleteTrigger] ON [ifcSpecification].[Specification]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcSpecification','Specification'
END
GO 


CREATE TRIGGER [ifcSpecification].[Specification_AfterInsertTrigger] ON [ifcSpecification].[Specification]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcSpecification','Specification'
END
GO 


CREATE TRIGGER [ifcSpecification].[Specification_AfterUpdateTrigger] ON [ifcSpecification].[Specification]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcSpecification','Specification'
END
GO 


CREATE TRIGGER [ifcSpecification].[SpecificationGroup_AfterDeleteTrigger] ON [ifcSpecification].[SpecificationGroup]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcSpecification','SpecificationGroup'
END
GO 


CREATE TRIGGER [ifcSpecification].[SpecificationGroup_AfterInsertTrigger] ON [ifcSpecification].[SpecificationGroup]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcSpecification','SpecificationGroup'
END
GO 


CREATE TRIGGER [ifcSpecification].[SpecificationGroup_AfterUpdateTrigger] ON [ifcSpecification].[SpecificationGroup]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcSpecification','SpecificationGroup'
END
GO 


CREATE TRIGGER [ifcSpecification].[TypeSpecificationAssignment_AfterDeleteTrigger] ON [ifcSpecification].[TypeSpecificationAssignment]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcSpecification','TypeSpecificationAssignment'
END
GO 


CREATE TRIGGER [ifcSpecification].[TypeSpecificationAssignment_AfterInsertTrigger] ON [ifcSpecification].[TypeSpecificationAssignment]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcSpecification','TypeSpecificationAssignment'
END
GO 


CREATE TRIGGER [ifcSpecification].[TypeSpecificationAssignment_AfterUpdateTrigger] ON [ifcSpecification].[TypeSpecificationAssignment]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcSpecification','TypeSpecificationAssignment'
END
GO 


CREATE TRIGGER [ifcSQL].[BaseTypeGroup_AfterDeleteTrigger] ON [ifcSQL].[BaseTypeGroup]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcSQL','BaseTypeGroup'
END
GO 


CREATE TRIGGER [ifcSQL].[BaseTypeGroup_AfterInsertTrigger] ON [ifcSQL].[BaseTypeGroup]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcSQL','BaseTypeGroup'
END
GO 


CREATE TRIGGER [ifcSQL].[BaseTypeGroup_AfterUpdateTrigger] ON [ifcSQL].[BaseTypeGroup]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcSQL','BaseTypeGroup'
END
GO 


CREATE TRIGGER [ifcSQL].[EntityAttributeTable_AfterDeleteTrigger] ON [ifcSQL].[EntityAttributeTable]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec [ifcSchemaTool].[AfterDeleteProc] 'ifcSQL','EntityAttributeTable'
END
GO 


CREATE TRIGGER [ifcSQL].[EntityAttributeTable_AfterInsertTrigger] ON [ifcSQL].[EntityAttributeTable]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterInsertProc] 'ifcSQL','EntityAttributeTable'
END
GO 


CREATE TRIGGER [ifcSQL].[EntityAttributeTable_AfterUpdateTrigger] ON [ifcSQL].[EntityAttributeTable]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec [ifcSchemaTool].[AfterUpdateProc] 'ifcSQL','EntityAttributeTable'
END
GO

CREATE TRIGGER [ifcSQL].[Licence_AfterDeleteTrigger] ON [ifcSQL].[Licence]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec ifcSchemaTool.AfterDeleteProc 'ifcSQL','Licence'
END


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [ifcSQL].[Licence_AfterInsertTrigger] ON [ifcSQL].[Licence]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec ifcSchemaTool.AfterInsertProc 'ifcSQL','Licence'
END


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [ifcSQL].[Licence_AfterUpdateTrigger] ON [ifcSQL].[Licence]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec ifcSchemaTool.AfterUpdateProc 'ifcSQL','Licence'
END


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 


CREATE TRIGGER [ifcSQL].[Release_AfterDeleteTrigger] ON [ifcSQL].[Release]
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted
exec ifcSchemaTool.AfterDeleteProc 'ifcSQL','Release'
END
GO 


CREATE TRIGGER [ifcSQL].[Release_AfterInsertTrigger] ON [ifcSQL].[Release]
AFTER INSERT
AS
BEGIN
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted
exec ifcSchemaTool.AfterInsertProc 'ifcSQL','Release'
END
GO 


CREATE TRIGGER [ifcSQL].[Release_AfterUpdateTrigger] ON [ifcSQL].[Release]
AFTER UPDATE
AS
BEGIN
IF OBJECT_ID('tempdb..#deleted') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID('tempdb..#inserted') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted
exec ifcSchemaTool.AfterUpdateProc 'ifcSQL','Release'
END
GO


CREATE TRIGGER [DdlChangeLog] 
ON DATABASE  
FOR DDL_DATABASE_LEVEL_EVENTS 
AS  
INSERT into [ifcSchemaTool].[ChangeLog] SELECT CURRENT_TIMESTAMP, SYSTEM_USER,EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'nvarchar(max)'), null
GO
