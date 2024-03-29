﻿USE [ifcSQL]
GO


-- LocalEntityId, float-format with comma and no science-fromat
ALTER FUNCTION [ifcInstance].[EntityAttributeFormatted]  (@GlobalEntityInstanceId as [ifcInstance].[Id])
RETURNS @Attributes TABLE([GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL, [OrdinalPosition] [ifcOrder].[Position] NOT NULL,     [TypeId] [ifcSchema].[Id] NOT NULL, [ValueStr] NVARCHAR(MAX) )
AS BEGIN
INSERT INTO @Attributes
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],[ifcInstance].[EntityAttributeListElementFormattedString]([GlobalEntityInstanceId],[OrdinalPosition]) as [ValueStr] FROM [ifcInstance].[EntityAttributeOfList] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId  union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeOfBinary] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],'.T. or .F.'+CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeOfBoolean] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId union
SELECT R.[GlobalEntityInstanceId],[OrdinalPosition],[TypeId],'#'+CONVERT(VARCHAR(MAX),A.[ProjectEntityInstanceId]) as [ValueStr] FROM [ifcInstance].[EntityAttributeOfEntityRef] R inner join [ifcSQL].[ifcProject].[EntityInstanceIdAssignment] A on(R.[Value]=A.[GlobalEntityInstanceId]) where R.[GlobalEntityInstanceId]=@GlobalEntityInstanceId union
SELECT a.GlobalEntityInstanceId,a.OrdinalPosition,a.TypeId,'.'+e.[EnumItemName]+'.' as [ValueStr] FROM [ifcInstance].[EntityAttributeOfEnum] a inner join [ifcSQL].[ifcSchema].[EnumItem] e on (a.TypeId=e.TypeId and a.Value=e.EnumItemId) where [GlobalEntityInstanceId]=@GlobalEntityInstanceId union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],FORMAT([Value], '0.000', 'en-us') as [ValueStr] FROM [ifcInstance].[EntityAttributeOfFloat] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeOfInteger] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId], IIF([TypeId]<0,'/*','''')+CONVERT(nvarchar(max),[Value]+IIF([TypeId]<0,'*/','''')) as [ValueStr] FROM [ifcInstance].[EntityAttributeOfString] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],'('+CONVERT(nvarchar(max),CONVERT(nvarchar(max),[X])+','+CONVERT(nvarchar(max),[Y])  +IIF([Z] is not null,','+CONVERT(nvarchar(max),[Z]),'')+')' ) as [ValueStr] FROM [ifcInstance].[EntityAttributeOfVector] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId
RETURN
END
go

-- LocalEntityId, float-format with comma and no science-format in lists
ALTER FUNCTION [ifcInstance].[EntityAttributeListElementFormatted]  (@GlobalEntityInstanceId as [ifcInstance].[Id], @OrdinalPosition [ifcOrder].[Position])
RETURNS @Attributes TABLE([GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL, [OrdinalPosition] [ifcOrder].[Position] NOT NULL, [ValueStr] NVARCHAR(MAX) )
AS BEGIN
INSERT INTO @Attributes
-- EntityAttributeListElementOfList
SELECT [GlobalEntityInstanceId],[OrdinalPosition],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeListElementOfBinary] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId and [OrdinalPosition]=@OrdinalPosition union
SELECT R.[GlobalEntityInstanceId],[OrdinalPosition],'#'+CONVERT(VARCHAR(MAX),A.[ProjectEntityInstanceId]) as [ValueStr] FROM [ifcInstance].[EntityAttributeListElementOfEntityRef] R inner join [ifcSQL].[ifcProject].[EntityInstanceIdAssignment] A on(R.[Value]=A.[GlobalEntityInstanceId]) where R.[GlobalEntityInstanceId]=@GlobalEntityInstanceId and R.[OrdinalPosition]=@OrdinalPosition union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],FORMAT([Value], '0.000', 'en-us')  as [ValueStr] FROM [ifcInstance].[EntityAttributeListElementOfFloat] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId and [OrdinalPosition]=@OrdinalPosition  union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeListElementOfInteger] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId and [OrdinalPosition]=@OrdinalPosition  union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],''''+CONVERT(nvarchar(max),[Value]+'''') as [ValueStr] FROM [ifcInstance].[EntityAttributeListElementOfString] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId and [OrdinalPosition]=@OrdinalPosition 
RETURN
END
go

-- no comma and the end of the list
ALTER FUNCTION [ifcInstance].[EntityAttributeListElementFormattedString](@GlobalEntityInstanceId as [ifcInstance].[Id], @OrdinalPosition [ifcOrder].[Position])
RETURNS VARCHAR(MAX) AS
BEGIN
DECLARE @IfcLine VARCHAR(MAX)= '('
DECLARE @ValueStr nvarchar(max)
DECLARE @ValueSeparator nvarchar(1)=''
DECLARE CursorView CURSOR FOR SELECT ValueStr FROM [ifcInstance].[EntityAttributeListElementFormatted](@GlobalEntityInstanceId, @OrdinalPosition)
OPEN CursorView; FETCH NEXT FROM CursorView into @ValueStr
WHILE @@FETCH_STATUS = 0  BEGIN  SET @IfcLine=@IfcLine+@ValueSeparator+@ValueStr
                                 SET @ValueSeparator=',' 
                                 FETCH NEXT FROM CursorView into @ValueStr
                          END;                                                    
CLOSE CursorView; DEALLOCATE CursorView
return @IfcLine+')'
END
go

-- end of line with semicolon
ALTER FUNCTION [ifcInstance].[ToIfcStepLine](@GlobalEntityInstanceId as [ifcInstance].[Id])
RETURNS VARCHAR(MAX) AS
BEGIN
DECLARE @IfcTypeStr VARCHAR(MAX)=(SELECT UPPER(t.TypeName) from ifcSchema.Type t inner join ifcInstance.Entity e on (e.EntityTypeId=t.TypeId) where e.[GlobalEntityInstanceId]=@GlobalEntityInstanceId)
DECLARE @EntityTypeId INT=(SELECT EntityTypeId from  ifcInstance.Entity where GlobalEntityInstanceId=@GlobalEntityInstanceId)
DECLARE @IfcLine VARCHAR(MAX)=''
DECLARE @IfcLineEnd VARCHAR(2)=''
if (@IfcTypeStr<>'ENTITYCOMMENT') begin SET @IfcLine= '#'+(SELECT CONVERT(VARCHAR(MAX),[ProjectEntityInstanceId])+'=' FROM [ifcSQL].[ifcProject].[EntityInstanceIdAssignment] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId)
                                                         + (SELECT 'IFC'+ UPPER(t.TypeName)+'(' from ifcSchema.Type t inner join ifcInstance.Entity e on (e.EntityTypeId=t.TypeId) where e.[GlobalEntityInstanceId]=@GlobalEntityInstanceId)
                                        SET @IfcLineEnd=');'
                                  end                                                         


DECLARE @ValueStr nvarchar(max)
DECLARE @ValueSeparator nvarchar(1)=''
DECLARE CursorView CURSOR FOR 
SELECT  iif(ValueStr is null,'$',ValueStr) FROM [ifcInstance].[EntityAttributeFormatted](@GlobalEntityInstanceId) eaf
right outer join [ifcSQL].[ifcSchema].[EntityAttribute] ea on(eaf.OrdinalPosition=ea.OrdinalPosition) 
where ea.EntityTypeId=@EntityTypeId     
order by ea.OrdinalPosition

OPEN CursorView; FETCH NEXT FROM CursorView into @ValueStr
WHILE @@FETCH_STATUS = 0  BEGIN  SET @IfcLine=@IfcLine+@ValueSeparator+@ValueStr
                                 SET @ValueSeparator=','
                                 FETCH NEXT FROM CursorView into @ValueStr
                                    END;                                                    
CLOSE CursorView; DEALLOCATE CursorView

DECLARE @CommentStr nvarchar(max)=''
DECLARE CursorView CURSOR FOR SELECT ValueStr FROM [ifcInstance].[EntityAttributeFormatted](@GlobalEntityInstanceId) where OrdinalPosition<0
OPEN CursorView; FETCH NEXT FROM CursorView into @CommentStr
--WHILE @@FETCH_STATUS = 0  BEGIN  SET @IfcLine=@IfcLine+@ValueStr
                                 --FETCH NEXT FROM CursorView into @ValueStr
                                    --END;                                                  
CLOSE CursorView; DEALLOCATE CursorView

return @IfcLine+@IfcLineEnd+ @CommentStr
END
go

<<<<<<< HEAD
//---------------------------------------------------------------------------------------

CREATE SCHEMA [api]
GO

CREATE TABLE [api].[Application](
	[ApplicationId] [int] NOT NULL,
	[ApplicationName] [nvarchar](80) NOT NULL,
	[InterfaceNamespace] [nvarchar](80) NOT NULL,
	[InterfaceClassName] [nvarchar](80) NOT NULL,
	[InterfaceFileName] [nvarchar](80) NOT NULL,
 CONSTRAINT [PK_Application] PRIMARY KEY CLUSTERED 
(
	[ApplicationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
=======
UPDATE [ifcSQL].[ifcSchema].[Type] SET [ParentTypeId]=-15 WHERE [ParentTypeId] is null and TypeGroupId=5 -- assign to root of ENTITY
GO
DROP FUNCTION [ifcSchema].[Type_Root] -- no longer needed, use SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('root of all types','      .') where NestLevel <3 order by sort
GO
DROP FUNCTION [ifcSchema].[Type_RootEntity] -- no longer needed
GO

DELETE FROM [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] WHERE TypeId=-13
DELETE FROM [ifcSQL].[ifcSchema].[Type] WHERE [TypeName]='root of TYPE' -- wich is TypeId=-13 and real root is 'root of BASETYPE'

DELETE FROM [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] WHERE TypeId=-18
DELETE FROM [ifcSQL].[ifcSchema].[Type] WHERE [TypeName]='root of SelectBaseType' -- wich is TypeId=-18 and and is not used

/* project extensions 19.06.2022 */

ALTER TABLE [ifcSQL].[ifcProject].[Project] ADD [Author] [Text].[ToString] NULL
go
ALTER TABLE [ifcSQL].[ifcProject].[Project] ADD [Organization] [Text].[ToString] NULL
go
ALTER TABLE [ifcSQL].[ifcProject].[Project] ADD [OriginatingSystem] [Text].[ToString] NULL
go
ALTER TABLE [ifcSQL].[ifcProject].[Project] ADD [Documentation] [Text].[ToString] NULL
go
ALTER VIEW [ifcSQL].[cp].[Project] AS SELECT * FROM ifcProject.Project where (ProjectId = cp.ProjectId())
GO


CREATE procedure [ifcSQL].[app].[NewProjectId]
	@ProjectName as [Text].[ToString],
	@ProjectDescription as [Text].[Description],
	@ProjectGroupId as [ifcProject].[Id] ,
	@SpecificationId as [ifcSchema].[GroupId],
	@Author as [Text].[ToString],
	@Organization as [Text].[ToString],
	@OriginatingSystem as [Text].[ToString],
	@Documentation as [Text].[ToString]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @NewProjectId int =(SELECT Max([ProjectId]) FROM [ifcProject].[Project])
SET @NewProjectId =@NewProjectId +1;
insert into [ifcProject].[Project] (ProjectId,ProjectName,ProjectDescription,ProjectGroupId,SpecificationId,Author,Organization,OriginatingSystem,Documentation) VALUES (@NewProjectId,	@ProjectName,@ProjectDescription,@ProjectGroupId,@SpecificationId,@Author,@Organization,@OriginatingSystem,@Documentation)
EXECUTE [app].[SelectProject] @NewProjectId
return @NewProjectId
END
GO

/* vorgotten triggers 19.06.2022 */

exec [ifcSQL].[ifcSchemaTool].[CreateDmlTriggers] 'ifcProperty','SetDefAlias'
go
exec [ifcSQL].[ifcSchemaTool].[CreateDmlTriggers] 'ifcProperty','SetDefApplicable'
go

DISABLE TRIGGER [ifcProperty].[SetDefAlias_AfterDeleteTrigger] ON [ifcProperty].[SetDefAlias]
GO
DISABLE TRIGGER [ifcProperty].[SetDefAlias_AfterInsertTrigger] ON [ifcProperty].[SetDefAlias]
GO
DISABLE TRIGGER [ifcProperty].[SetDefAlias_AfterUpdateTrigger] ON [ifcProperty].[SetDefAlias]
GO

DISABLE TRIGGER [ifcProperty].[SetDefApplicable_AfterDeleteTrigger] ON [ifcProperty].[SetDefApplicable]
GO
DISABLE TRIGGER [ifcProperty].[SetDefApplicable_AfterInsertTrigger] ON [ifcProperty].[SetDefApplicable]
GO
DISABLE TRIGGER [ifcProperty].[SetDefApplicable_AfterUpdateTrigger] ON [ifcProperty].[SetDefApplicable]
>>>>>>> b312046d5e7cc97d609678fc57806fd04b3fe288
GO


CREATE TABLE [api].[ApplicationInterface](
	[ApplicationId] [int] NOT NULL,
	[ViewSchemaName] [nvarchar](80) NOT NULL,
	[ViewName] [nvarchar](250) NOT NULL,
	[TableSchemaName] [nvarchar](80) NOT NULL,
	[TableName] [nvarchar](250) NOT NULL,
	[OptionalFilterAndOrderCommandPart] [nvarchar](250) NOT NULL,
	[CreateDictionary] [bit] NOT NULL,
 CONSTRAINT [PK_ApplicationInterface] PRIMARY KEY CLUSTERED 
(
	[ApplicationId] ASC,
	[ViewSchemaName] ASC,
	[ViewName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

ALTER TABLE [api].[ApplicationInterface]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationInterface_Application] FOREIGN KEY([ApplicationId])
REFERENCES [api].[Application] ([ApplicationId])
GO

ALTER TABLE [api].[ApplicationInterface] CHECK CONSTRAINT [FK_ApplicationInterface_Application]
GO

CREATE VIEW [cs].[Specification] as
SELECT s.* FROM  [ifcSpecification].[Specification] s inner join [cp].[Project] p on (s.SpecificationId=p.SpecificationId)
GO

exec sp_rename 'ifcDocumentation.Type', 'DocumentationType'
exec sp_rename 'ifcProperty.Def', 'PropertyDef'
exec sp_rename 'ifcProperty.DefAlias', 'PropertyDefAlias'
exec sp_rename 'ifcProperty.SetDef', 'PropertySetDef'
exec sp_rename 'ifcQuantityTakeOff.Def', 'QuantityTakeOffDef'
exec sp_rename 'ifcQuantityTakeOff.DefAlias', 'QuantityTakeOffDefAlias'
exec sp_rename 'ifcQuantityTakeOff.SetDef', 'QuantityTakeOffSetDef'
exec sp_rename 'ifcQuantityTakeOff.Type', 'QuantityTakeOffType'
exec sp_rename 'ifcProperty.SetDefAlias', 'PropertySetDefAlias'
exec sp_rename 'ifcProperty.SetDefApplicable', 'PropertySetDefApplicable'
exec sp_rename 'ifcQuantityTakeOff.SetDefApplicableClass', 'QuantityTakeOffSetDefApplicableClass'

//---------------------------------------------------------------------------------------