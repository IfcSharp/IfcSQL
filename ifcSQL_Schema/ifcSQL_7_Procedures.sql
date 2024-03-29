-- Database-schema of ifcSQL, Copyright (c) 2021, Bernhard Simon Bock, Friedrich Eder, MIT License (see https://github.com/IfcSharp/IfcSharpLibrary/tree/master/Licence)
-- this database runs on Microsoft SQL Server 2019, earlier versions don't support UTF-8
-- this database was testet on Microsoft SQL Server 2019 EXPRESS

USE [ifcSQL]
GO

CREATE PROCEDURE [app].[CreateNewUserIfNotExist]
AS
BEGIN
SET NOCOUNT ON;
if ((select Max([Login]) from [ifcSQL].[ifcUser].[Login] where [Login]=SYSTEM_USER) is null ) 
  begin DECLARE @NextUserId int =(SELECT Max([UserId])+1 FROM [ifcSQL].[ifcUser].[User])
        if (@NextUserId is null) SET @NextUserId=1
        DECLARE @MaxProjectId int =(SELECT Max([ProjectId]) FROM [ifcSQL].[ifcProject].[Project])   
        INSERT INTO [ifcSQL].[ifcUser].[User]([UserId],[FamilyName],[FirstName],[Email]) VALUES(@NextUserId, 'FamilyName'+CONVERT(nvarchar(max),@NextUserId),'FirstName'+CONVERT(nvarchar(max),@NextUserId),'User'+CONVERT(nvarchar(max),@NextUserId)+'@example.com')
        INSERT INTO [ifcSQL].[ifcUser].[Login]([UserId],[Login]) VALUES(@NextUserId,SYSTEM_USER)

		DECLARE @cnt INT = 0;
		WHILE @cnt < 10 BEGIN INSERT INTO [ifcSQL].[ifcUser].[UserProjectAssignment]([UserId],[UserProjectOrdinalPosition],[ProjectId]) VALUES(@NextUserId,@cnt,@MaxProjectId)  
		                      SET @cnt = @cnt + 1; 
		                END;
  end
END
GO

CREATE PROCEDURE [app].[DeleteCurrentProjectData]
AS
BEGIN
SELECT * INTO #P FROM [cp].[EntityInstanceIdAssignment]
UPDATE [ifcSQL].[cp].[EntityAttributeOfEntityRef] SET [Value]=NULL -- um EntityRefElemente löschen zu können
DELETE FROM [cp].[EntityInstanceIdAssignment]
DELETE e FROM [ifcInstance].[Entity] e inner join #P on (#P.GlobalEntityInstanceId=e.GlobalEntityInstanceId)
END
GO

CREATE PROCEDURE [app].[DeleteProject]
@DelProjectId as int
AS
BEGIN
SET NOCOUNT ON;
DECLARE @MinProjectId AS INT; SET @MinProjectId = (SELECT Min([ProjectId]) FROM ifcProject.Project)
UPDATE ifcProject.UserProject SET ProjectId=@MinProjectId
-- delete Entities here
DELETE FROM ifcProject.Project WHERE ProjectId=@DelProjectId
END
GO

CREATE PROCEDURE [app].[DeleteProjectEntities]
@ProjectId as int
AS
BEGIN
SET NOCOUNT ON;
select ea.* into #ea from [ifcProject].[EntityInstanceIdAssignment] ea where ea.ProjectId=@ProjectId
delete ea from [ifcProject].[EntityInstanceIdAssignment] ea where ea.ProjectId=@ProjectId
delete e from #ea ea inner join [ifcInstance].[Entity] e on (ea.GlobalEntityInstanceId=e.GlobalEntityInstanceId) where ea.ProjectId=@ProjectId
END
GO



CREATE PROCEDURE [app].[SelectProject]
@SelectProjectId as int
AS
BEGIN
SET NOCOUNT ON;


DECLARE @CurrentProjectId int =(SELECT [ProjectId] FROM [cp].[UserProjectAssignment] where [UserProjectOrdinalPosition] =0)

if (@SelectProjectId<>@CurrentProjectId) 
   begin

DECLARE @UserId int
DECLARE @UserProjectOrdinalPosition int
DECLARE @ProjectId int 

DECLARE @LastProjectId int = @SelectProjectId

DECLARE CursorView CURSOR FOR SELECT [UserId],[UserProjectOrdinalPosition] ,[ProjectId] FROM [cp].[UserProjectAssignment]  ORDER BY [UserProjectOrdinalPosition] ASC
OPEN CursorView; FETCH NEXT FROM CursorView into @UserId,@UserProjectOrdinalPosition,@ProjectId
WHILE @@FETCH_STATUS = 0  BEGIN  update [cp].[UserProjectAssignment] set ProjectId= @LastProjectId where UserId=@UserId and UserProjectOrdinalPosition=@UserProjectOrdinalPosition
                                 SET @LastProjectId=@ProjectId
                                 FETCH NEXT FROM CursorView into  @UserId,@UserProjectOrdinalPosition,@ProjectId
				          END;								
CLOSE CursorView; DEALLOCATE CursorView
   end

END
GO

CREATE PROCEDURE [app].[MoveProject]
@ProjectId as int,
@ProjectGroupId as int
AS
BEGIN
SET NOCOUNT ON;
UPDATE [ifcSQL].[ifcProject].[Project] SET [ProjectGroupId]=@ProjectGroupId WHERE [ProjectId]=@ProjectId
END
GO

CREATE PROCEDURE [app].[MoveProjectGroup]
@ProjectGroupId as int,
@ParentProjectGroupId as int
AS
BEGIN
SET NOCOUNT ON;
UPDATE [ifcSQL].[ifcProject].[ProjectGroup] SET [ParentProjectGroupId]=@ParentProjectGroupId WHERE [ProjectGroupId]=@ProjectGroupId
END
GO

CREATE PROCEDURE [app].[NewProject]
--@SelectProjectId as int,
@NewName as nvarchar(max)
AS
BEGIN
SET NOCOUNT ON;
DECLARE @NewProjectId int =(SELECT Max([ProjectId]) FROM [ifcProject].[Project])
SET @NewProjectId =@NewProjectId +1;

SELECT * into #prj  FROM [cp].[Project]
update #prj set [ProjectId]=@NewProjectId
update #prj set  [ProjectName]=@NewName
update #prj set  [ProjectDescription]=@NewName

insert into [ifcProject].[Project] select * from  #prj

EXECUTE [app].[SelectProject] @NewProjectId
END
GO



CREATE PROCEDURE [cp].[ToIfcStep]
AS
BEGIN
-- sqlcmd -S%SqlServer% -difcSQL -Q"cp.ToIfcStep" > test.ifc
DECLARE @ProjectName VARCHAR(MAX)=(SELECT [ProjectName] FROM [ifcSQL].[cp].[Project])
DECLARE @ProjectDescription VARCHAR(MAX)=(SELECT [ProjectDescription] FROM [ifcSQL].[cp].[Project])
DECLARE @SpecificationId INT=(SELECT [SpecificationId] FROM [ifcSQL].[cp].[Project])
DECLARE @SpecificationName VARCHAR(MAX)=(SELECT [SpecificationName] FROM [ifcSQL].[ifcSpecification].[Specification] where [SpecificationId]=@SpecificationId)

DECLARE @UserName VARCHAR(MAX)=(SELECT [FirstName]+' '+[FamilyName] FROM [ifcSQL].[cp].[User])


print 'ISO-10303-21;'
print 'HEADER;'
print 'FILE_DESCRIPTION (('''+@ProjectDescription+'''), ''2;1'');'
print 'FILE_NAME ('''+@ProjectName+'.ifc'', '''+FORMAT(CURRENT_TIMESTAMP, 'yyyy-MM-ddThh\:mm\:ss' ) +''', ('''+@UserName+'''), (''''), '''+ 'ifcSQL'+''', '''', '''');'
print 'FILE_SCHEMA (('''+@SpecificationName+'''));'
print 'ENDSEC;'
print 'DATA;'


DECLARE @IfcLine VARCHAR(MAX)


DECLARE CursorView CURSOR FOR SELECT [ifcSQL].[ifcInstance].[ToIfcStepLine]([GlobalEntityInstanceId])  FROM [ifcSQL].[cp].[Entity] order by GlobalEntityInstanceId
OPEN CursorView; FETCH NEXT FROM CursorView into @IfcLine
WHILE @@FETCH_STATUS = 0  BEGIN  print @IfcLine
                                 FETCH NEXT FROM CursorView into @IfcLine
                                    END;                                                    
CLOSE CursorView; DEALLOCATE CursorView


print 'ENDSEC;'
print 'END-ISO-10303-21;'

END
GO

CREATE PROCEDURE [app].[ToIfcStepFromProjectId]
@ProjectId as int
AS
BEGIN
SET NOCOUNT ON;
-- sqlcmd -S%SqlServer% -difcSQL -Q"app.ToIfcStepFromProjectId 5"
exec [app].[SelectProject] @ProjectId
exec [cp].[ToIfcStep]
END
GO



CREATE PROCEDURE [app].[ToIfcStepFromProjectName] @ProjectName as NVARCHAR(MAX)
AS
BEGIN
SET NOCOUNT ON;
-- sqlcmd -S%SqlServer% -difcSQL -Q"app.ToIfcStepFrom ProjectId 5"

DECLARE @ProjectId as int =(SELECT [ProjectId] FROM [ifcSQL].[ifcProject].[Project] where ProjectName=@ProjectName)
exec [app].[ToIfcStepFromProjectId] @ProjectId
END
GO



CREATE PROCEDURE [ExpressImport].[BaseTypeId_Update] 
    @MinExclTypeId [ifcSchema].[Id],
	@MaxInclTypeId [ifcSchema].[Id]
AS
BEGIN
UPDATE t SET t.BaseTypeId=t2.TypeId
FROM       [ifcSchema].[Type] t 
inner join [ifcSchema].[Type] t2 on (t2.TypeName=t.BaseTypeName)
where t.[TypeId]>@MinExclTypeId and t.[TypeId]<=@MaxInclTypeId and t.BaseTypeId=0
 and ((t2.[TypeId]>@MinExclTypeId and t2.[TypeId]<=@MaxInclTypeId) or t2.TypeGroupId=0)
END
GO


CREATE PROCEDURE [ExpressImport].[EntityAttributeTableId_Update] 
    @MinExclTypeId [ifcSchema].[Id],
	@MaxInclTypeId [ifcSchema].[Id]
AS
BEGIN
UPDATE t SET t.[EntityAttributeTableId]=t2.[EntityAttributeTableId]
FROM       [ifcSchema].[Type] t 
inner join [ifcSchema].[Type] t2 on  (t.ParentTypeId=t2.TypeId)
where t.[TypeId]>@MinExclTypeId and t.[TypeId]<=@MaxInclTypeId and t.[EntityAttributeTableId]=-2
END
GO

CREATE PROCEDURE [ExpressImport].[SelectItem_Insert_Nested] 
    @BaseNestLevel int,
    @Current_SpecificationId [ifcSchema].[GroupId]
AS
BEGIN
INSERT INTO [ifcSQL].[ifcSchema].[SelectItem] ([TypeId],[SelectTypeId],[TypeGroupId],[NestLevel],[Abstract])
SELECT distinct si.[TypeId],t.TypeId as [SelectTypeId],si.[TypeGroupId],@BaseNestLevel+1 as  [NestLevel], 0 as [Abstract] 
FROM [ifcSQL].[ifcSchema].[SelectItem] si 
inner join [ifcSQL].[ifcSchema].[Type] t  on (si.SelectTypeId=t.ParentTypeId)
inner join [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] s on (s.TypeId=t.TypeId)
WHERE si.NestLevel=@BaseNestLevel and s.[SpecificationId]=@Current_SpecificationId
and t.TypeId not in (SELECT[SelectTypeId] from  [ifcSQL].[ifcSchema].[SelectItem] si2 where (si.[TypeId]=si2.[TypeId]))
--and si.[TypeId]=230407
END
GO

CREATE PROCEDURE [ExpressImport].[SelectItem_Insert_NestedSelectItem] 
    @BaseNestLevel int,
    @MinExclTypeId [ifcSchema].[Id],
	@MaxInclTypeId [ifcSchema].[Id]
AS
BEGIN
INSERT INTO [ifcSQL].[ifcSchema].[SelectItem] ([TypeId],[SelectTypeId],[TypeGroupId],[NestLevel],[Abstract])
SELECT distinct si.TypeId as [TypeId],si2.SelectTypeId as [SelectTypeId],si.[TypeGroupId],@BaseNestLevel+1 as  [NestLevel], 0 as [Abstract] 
FROM       [ifcSQL].[ifcSchema].[SelectItem] si 
inner join [ifcSQL].[ifcSchema].[SelectItem] si2   on (si.SelectTypeId=si2.TypeId)
where si.[NestLevel]=@BaseNestLevel
 and  si.[TypeId]>@MinExclTypeId 
 and  si.[TypeId]<=@MaxInclTypeId
  and  si2.SelectTypeId  not in (SELECT [SelectTypeId] from  [ifcSQL].[ifcSchema].[SelectItem] si3 where (si3.[TypeId]=si.[TypeId]))
END
GO



CREATE PROCEDURE [ExpressImport].[SelectItem_Update_Abstract] 
    @Current_SpecificationId [ifcSchema].[GroupId]
AS
BEGIN

  UPDATE si SET si. [Abstract]=t.[Abstract]
  FROM [ifcSQL].[ifcSchema].[SelectItem] si 
  inner join [ifcSQL].[ifcSchema].[Type] t on (si.SelectTypeId=t.TypeId)
  inner join [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] s on (s.TypeId=t.TypeId)
  where   s.[SpecificationId]=@Current_SpecificationId and t.[Abstract] is not null
END
GO

CREATE PROCEDURE [ifcInstance].[InsertAttribute] 
	@GlobalEntityInstanceId [ifcInstance].[Id],
	@EntityTypeId [ifcSchema].[Id],
	@OrdinalPosition [ifcOrder].[Position],
	@AttributeTypeId [ifcSchema].[Id],
	@Dim1Position  [ifcOrder].[Position],
	@Dim2Position [ifcOrder].[Position],
    @AttributeValue [Text].[ToString]
AS
BEGIN
	SET NOCOUNT ON;
		DECLARE @EntityAttributeTableId AS INT = (
	select t.EntityAttributeTableId from [ifcSchema].[EntityAttributeInstance] ai 
	                          inner join [ifcSchema].[Type] t on(ai.AttributeInstanceTypeId=t.TypeId)
	where ai.[EntityTypeId]=@EntityTypeId and ai.[OrdinalPosition]=@OrdinalPosition and ai.[AttributeInstanceTypeId]=@AttributeTypeId
	)

if (@AttributeTypeId<0) SET @EntityAttributeTableId=7

	--print 'A'
	--print @AttributeValue

if (@EntityAttributeTableId is null) begin
declare @msg as nvarchar(max); 
--set @msg = 'TypeId=' +  CAST((select TypeId from  inserted) AS NVARCHAR(MAX)) + ' not allowed for EntityAttributeOfString'
set @msg='InsertAttribute: TypeId='+CONVERT(nvarchar(max),@AttributeTypeId)+' not allowed on Position='+CONVERT(nvarchar(max),@OrdinalPosition)+' for Entity-TypeId='+CONVERT(nvarchar(max),@EntityTypeId)
RAISERROR (@msg, 16, 10);  
end
	--print 'B'
if (@Dim1Position is null) set @Dim1Position=1
if (@Dim2Position is null) set @Dim2Position=1
	--print 'C'
if (@EntityAttributeTableId=1) INSERT INTO [ifcInstance].[EntityAttributeOfBinary]   ([GlobalEntityInstanceId],[OrdinalPosition],[TypeId],[Value]) VALUES (@GlobalEntityInstanceId,@OrdinalPosition,@AttributeTypeId,CONVERT(varbinary(max),@AttributeValue))
	--print 'C1'
if (@EntityAttributeTableId=2) INSERT INTO [ifcInstance].[EntityAttributeOfBoolean]  ([GlobalEntityInstanceId],[OrdinalPosition],[TypeId],[Value]) VALUES (@GlobalEntityInstanceId,@OrdinalPosition,@AttributeTypeId,CONVERT(bit,@AttributeValue))
	--print 'C2'
if (@EntityAttributeTableId=3) INSERT INTO [ifcInstance].[EntityAttributeOfEntityRef]([GlobalEntityInstanceId],[OrdinalPosition],[TypeId],[Value]) VALUES (@GlobalEntityInstanceId,@OrdinalPosition,@AttributeTypeId,CONVERT(bigint,@AttributeValue))
	--print 'C3'
if (@EntityAttributeTableId=4) INSERT INTO [ifcInstance].[EntityAttributeOfEnum]     ([GlobalEntityInstanceId],[OrdinalPosition],[TypeId],[Value]) VALUES (@GlobalEntityInstanceId,@OrdinalPosition,@AttributeTypeId,CONVERT(bigint,@AttributeValue))
	--print 'C4'
if (@EntityAttributeTableId=5) INSERT INTO [ifcInstance].[EntityAttributeOfFloat]    ([GlobalEntityInstanceId],[OrdinalPosition],[TypeId],[Value]) VALUES (@GlobalEntityInstanceId,@OrdinalPosition,@AttributeTypeId,CONVERT(float,@AttributeValue))
	--print 'C5'
if (@EntityAttributeTableId=6) INSERT INTO [ifcInstance].[EntityAttributeOfInteger]  ([GlobalEntityInstanceId],[OrdinalPosition],[TypeId],[Value]) VALUES (@GlobalEntityInstanceId,@OrdinalPosition,@AttributeTypeId,CONVERT(bigint,@AttributeValue))
	--print 'C6'
if (@EntityAttributeTableId=7) INSERT INTO [ifcInstance].[EntityAttributeOfString]   ([GlobalEntityInstanceId],[OrdinalPosition],[TypeId],[Value]) VALUES (@GlobalEntityInstanceId,@OrdinalPosition,@AttributeTypeId,@AttributeValue)
--	[EntityAttributeTableId] ,[EntityAttributeTableName] FROM [ifcSQL].[ifcSchema].[EntityAttributeTable]
	--print 'D'
END
GO



CREATE PROCEDURE [ifcInstance].[InsertEntity]
    @GlobalEntityInstanceId [ifcInstance].[Id],
	@ProjectId [ifcProject].[Id],
	@ProjectEntityInstanceId [ifcInstance].[Id],
	@EntityTypeId [ifcSchema].[Id]
AS
BEGIN
	SET NOCOUNT ON;
-- DECLARE @GlobalEntityInstanceId AS INT = (select MAX(GlobalEntityInstanceId)+1 from ifcInstance.Entity)
INSERT INTO ifcInstance.Entity([GlobalEntityInstanceId],[EntityTypeId])vALUES(@GlobalEntityInstanceId,@EntityTypeId)
INSERT INTO [ifcProject].[EntityInstanceIdAssignment]([ProjectId],[ProjectEntityInstanceId],[GlobalEntityInstanceId]) VALUES(@ProjectId,@ProjectEntityInstanceId,@GlobalEntityInstanceId)
END
GO





CREATE PROCEDURE [ifcProject].[NewLastGlobalId](@ProjectId as int, @IdCount as [ifcInstance].[Id])
AS
BEGIN
-- ab hier müsste gesperrt werden 
DECLARE @LastMaxGlobalId int =(SELECT max([GlobalEntityInstanceId])  FROM [ifcProject].[LastGlobalEntityInstanceId])
DELETE FROM [ifcProject].[LastGlobalEntityInstanceId] WHERE [ProjectId]=@ProjectId
INSERT [ifcProject].[LastGlobalEntityInstanceId]([GlobalEntityInstanceId],[ProjectId]) VALUES  (@LastMaxGlobalId+@IdCount,@ProjectId)
-- bis hier müsste gesperrt werden 
END
GO



CREATE PROCEDURE [ifcSchemaTool].[AfterDeleteProc]
@TableSchema nvarchar(max),
@TableName   nvarchar(max) 
AS
BEGIN
declare @msg as nvarchar(max);
declare @ColumnName nvarchar(max)
declare @ColumnValue nvarchar(max)
declare @Cmd nvarchar(max)
declare @InsStr as nvarchar(max) = '/*DEL*/ INSERT INTO ['+@TableSchema+'].['+@Tablename+'] VALUES(' 

DECLARE CursorView CURSOR FOR SELECT [COLUMN_NAME] FROM [INFORMATION_SCHEMA].[COLUMNS] where [TABLE_SCHEMA]=@TableSchema and [TABLE_NAME]=@TableName order by [ORDINAL_POSITION] 
OPEN CursorView; FETCH NEXT FROM CursorView into @ColumnName
WHILE @@FETCH_STATUS = 0  BEGIN  
      set @Cmd='select @ColumnValue=CAST(' + @ColumnName + ' AS NVARCHAR(MAX)) from #deleted'
      exec sp_executesql @Cmd, N'@ColumnValue nvarchar(max) output',@ColumnValue output;
      set @InsStr=@InsStr+@ColumnValue+ ','
      FETCH NEXT FROM CursorView into  @ColumnName
END;                                                    
CLOSE CursorView; DEALLOCATE CursorView

set @InsStr=STUFF(@InsStr, LEN(@InsStr), 1, ')')
INSERT into [ifcSchemaTool].[ChangeLog] SELECT CURRENT_TIMESTAMP, SYSTEM_USER,@InsStr,2

END
GO
 


CREATE PROCEDURE [ifcSchemaTool].[AfterInsertProc]
@TableSchema nvarchar(max),
@TableName   nvarchar(max) 
AS
BEGIN
declare @msg as nvarchar(max);
declare @ColumnName nvarchar(max)
declare @ColumnValue nvarchar(max)
declare @Cmd nvarchar(max)
declare @InsStr as nvarchar(max) = '/*INS*/ INSERT INTO ['+@TableSchema+'].['+@Tablename+'] VALUES(' 

DECLARE CursorView CURSOR FOR SELECT [COLUMN_NAME] FROM [INFORMATION_SCHEMA].[COLUMNS] where [TABLE_SCHEMA]=@TableSchema and [TABLE_NAME]=@TableName order by [ORDINAL_POSITION] 
OPEN CursorView; FETCH NEXT FROM CursorView into @ColumnName
WHILE @@FETCH_STATUS = 0  BEGIN  
      set @Cmd='select @ColumnValue=CAST(' + @ColumnName + ' AS NVARCHAR(MAX)) from #inserted'
      exec sp_executesql @Cmd, N'@ColumnValue nvarchar(max) output',@ColumnValue output;
      set @InsStr=@InsStr+@ColumnValue+ ','
      FETCH NEXT FROM CursorView into  @ColumnName
END;                                                    
CLOSE CursorView; DEALLOCATE CursorView

set @InsStr=STUFF(@InsStr, LEN(@InsStr), 1, ')')
INSERT into [ifcSchemaTool].[ChangeLog] SELECT CURRENT_TIMESTAMP, SYSTEM_USER,@InsStr,3
END
GO
 

CREATE PROCEDURE [ifcSchemaTool].[AfterUpdateProc]
@TableSchema nvarchar(max),
@TableName   nvarchar(max) 
AS
BEGIN
declare @msg as nvarchar(max);
declare @ColumnName nvarchar(max)
declare @ColumnValue nvarchar(max)
declare @Cmd nvarchar(max)
declare @InsStr as nvarchar(max) = '/*INS*/ INSERT INTO ['+@TableSchema+'].['+@Tablename+'] VALUES(' 

DECLARE CursorView CURSOR FOR SELECT [COLUMN_NAME] FROM [INFORMATION_SCHEMA].[COLUMNS] where [TABLE_SCHEMA]=@TableSchema and [TABLE_NAME]=@TableName order by [ORDINAL_POSITION] 
OPEN CursorView; FETCH NEXT FROM CursorView into @ColumnName
WHILE @@FETCH_STATUS = 0  BEGIN  
      set @Cmd='select @ColumnValue=CAST(' + @ColumnName + ' AS NVARCHAR(MAX)) from #inserted'
      exec sp_executesql @Cmd, N'@ColumnValue nvarchar(max) output',@ColumnValue output;
      set @InsStr=@InsStr+@ColumnValue+ ','
      FETCH NEXT FROM CursorView into  @ColumnName
END;                                                    
CLOSE CursorView; DEALLOCATE CursorView

set @InsStr=STUFF(@InsStr, LEN(@InsStr), 1, ')')
INSERT into [ifcSchemaTool].[ChangeLog] SELECT CURRENT_TIMESTAMP, SYSTEM_USER,@InsStr,4
END
GO
 



CREATE PROCEDURE [ifcSchemaTool].[ChangeLogScriptCreate] 
@MinDateTime as DateTime
AS
BEGIN

declare @Comment nvarchar(max)
declare @CommandText nvarchar(max)

print '-- changes since ' + CONVERT(NVARCHAR(MAX),@MinDateTime,120) -- @MinDateTime

print 'use ifcSQL'
print 'GO'

DECLARE CursorView CURSOR FOR SELECT '/* ' + CONVERT(nvarchar(max),[Date],20)+': '+[Login] +' */'+ CHAR(13) + CHAR(10) as [Comment], [CommandText]    FROM [ifcSQL].[ifcSchemaTool].[ChangeLog]  where Date>=@MinDateTime  order by [Date]
OPEN CursorView; FETCH NEXT FROM CursorView into @Comment,@CommandText
WHILE @@FETCH_STATUS = 0  BEGIN  print @Comment
                                 print @CommandText
                                                           print 'GO' 
                                 FETCH NEXT FROM CursorView into  @Comment,@CommandText
                          END;                                                    
CLOSE CursorView; DEALLOCATE CursorView
/* Example: exec [ifcSchemaTool].[ChangeLogScriptCreate] '2019-09-02' */
END
GO



CREATE PROCEDURE [ifcSchemaTool].[ChangeLogScriptDelete] 
@BeforeDateTime as DateTime
AS
BEGIN
DELETE FROM [ifcSQL].[ifcSchemaTool].[ChangeLog]  where Date<@BeforeDateTime
/* Example: exec [ifcSchemaTool].[ChangeLogScriptDelete] '2019-09-02' */
END
GO




CREATE PROCEDURE [ifcSchemaTool].[CreateDmlTriggers]
@TableSchema nvarchar(max),
@TableName   nvarchar(max) 
AS
BEGIN

exec('
CREATE TRIGGER ['+@TableSchema+'].['+@TableName+'_AfterInsertTrigger] ON ['+@TableSchema+'].['+@TableName+']
AFTER INSERT
AS
BEGIN

IF OBJECT_ID(''tempdb..#inserted'') IS NOT NULL DROP TABLE #inserted
select * into #inserted from inserted

exec ifcSchemaTool.AfterInsertProc '''+@TableSchema+''','''+@TableName+'''
END
')

exec('
CREATE TRIGGER ['+@TableSchema+'].['+@TableName+'_AfterUpdateTrigger] ON ['+@TableSchema+'].['+@TableName+']
AFTER UPDATE
AS
BEGIN

IF OBJECT_ID(''tempdb..#deleted'') IS NOT NULL DROP TABLE #deleted 
IF OBJECT_ID(''tempdb..#inserted'') IS NOT NULL DROP TABLE #inserted
select * into #deleted from deleted
select * into #inserted from inserted

exec ifcSchemaTool.AfterUpdateProc '''+@TableSchema+''','''+@TableName+'''
END
')

exec('
CREATE TRIGGER ['+@TableSchema+'].['+@TableName+'_AfterDeleteTrigger] ON ['+@TableSchema+'].['+@TableName+']
AFTER DELETE
AS
BEGIN

IF OBJECT_ID(''tempdb..#deleted'') IS NOT NULL DROP TABLE #deleted 
select * into #deleted from deleted

exec ifcSchemaTool.AfterDeleteProc '''+@TableSchema+''','''+@TableName+'''
END
')

END
GO

CREATE PROCEDURE [ifcSchemaTool].[CreateAllDmlTriggers]
@TableSchema nvarchar(max)
AS
BEGIN
declare @TableName nvarchar(max)

DECLARE CursorView CURSOR FOR SELECT [TABLE_NAME]  FROM [INFORMATION_SCHEMA].[TABLES] WHERE [TABLE_SCHEMA]=@TableSchema and [TABLE_TYPE]='BASE TABLE'
OPEN CursorView; FETCH NEXT FROM CursorView into @TableName
WHILE @@FETCH_STATUS = 0  BEGIN  exec [ifcSchemaTool].[CreateDmlTriggers] @TableSchema, @TableName
                                 FETCH NEXT FROM CursorView into  @TableName
                          END;                                                    
CLOSE CursorView; DEALLOCATE CursorView
END
GO





CREATE PROCEDURE [ifcSchemaTool].[DropDmlTriggers]
@TableSchema nvarchar(max),
@TableName   nvarchar(max) 
AS
BEGIN
exec('DROP TRIGGER IF EXISTS ['+@TableSchema+'].['+@TableName+'_AfterInsertTrigger]')
exec('DROP TRIGGER IF EXISTS ['+@TableSchema+'].['+@TableName+'_AfterUpdateTrigger]')
exec('DROP TRIGGER IF EXISTS ['+@TableSchema+'].['+@TableName+'_AfterDeleteTrigger]')
END
GO


CREATE PROCEDURE [ifcSchemaTool].[DropAllSchemaDmlTriggers]
@TableSchema nvarchar(max)
AS
BEGIN

declare @TableName nvarchar(max)

DECLARE CursorView CURSOR FOR SELECT [TABLE_NAME]  FROM [INFORMATION_SCHEMA].[TABLES] WHERE [TABLE_SCHEMA]=@TableSchema
OPEN CursorView; FETCH NEXT FROM CursorView into @TableName
WHILE @@FETCH_STATUS = 0  BEGIN  exec [ifcSchemaTool].[DropDmlTriggers] @TableSchema, @TableName
                                 FETCH NEXT FROM CursorView into  @TableName
                          END;                                                    
CLOSE CursorView; DEALLOCATE CursorView
END
GO



CREATE PROCEDURE [ifcSchemaTool].[DropAndCreateDmlTriggers]
@TableSchema nvarchar(max),
@TableName   nvarchar(max) 
AS
BEGIN
exec [ifcSchemaTool].[DropDmlTriggers] @TableSchema, @TableName
exec [ifcSchemaTool].[CreateDmlTriggers] @TableSchema, @TableName
END
GO


CREATE PROCEDURE [ifcSchemaTool].[DropAndCreateAllSchemaDmlTriggers]
@TableSchema nvarchar(max)
AS
BEGIN
declare @TableName nvarchar(max)

DECLARE CursorView CURSOR FOR SELECT [TABLE_NAME]  FROM [INFORMATION_SCHEMA].[TABLES] WHERE [TABLE_SCHEMA]=@TableSchema
OPEN CursorView; FETCH NEXT FROM CursorView into @TableName
WHILE @@FETCH_STATUS = 0  BEGIN  exec [ifcSchemaTool].[DropAndCreateDmlTriggers] @TableSchema, @TableName
                                 FETCH NEXT FROM CursorView into  @TableName
                          END;                                                    
CLOSE CursorView; DEALLOCATE CursorView
END
GO





CREATE PROCEDURE [ifcSchemaTool].[DropAndCreateAllSchemaDmlTriggers_Template]
AS
BEGIN
exec [ifcSchemaTool].[DropAndCreateAllSchemaDmlTriggers] 'ifcSchema'
exec [ifcSchemaTool].[DropAndCreateAllSchemaDmlTriggers] 'ifcUnit'
exec [ifcSchemaTool].[DropAndCreateAllSchemaDmlTriggers] 'ifcAPI'
exec [ifcSchemaTool].[DropAndCreateAllSchemaDmlTriggers] 'ifcDocumentation'
exec [ifcSchemaTool].[DropAndCreateAllSchemaDmlTriggers] 'ifcProperty'
exec [ifcSchemaTool].[DropAndCreateAllSchemaDmlTriggers] 'ifcQuantityTakeOff'
exec [ifcSchemaTool].[DropAndCreateAllSchemaDmlTriggers] 'ifcSchema'
exec [ifcSchemaTool].[DropAndCreateAllSchemaDmlTriggers] 'ifcSpecification'
exec [ifcSchemaTool].[DropAndCreateAllSchemaDmlTriggers] 'ifcSQL'
END
GO




CREATE PROCEDURE [ifcSchemaTool].[ErrorEntityAtrributeType]
(
@GlobalEntityInstanceId [ifcInstance].[Id],
@OrdinalPosition [ifcOrder].[Position],
@TypeId [ifcSchema].[Id]
)
AS BEGIN
DECLARE @EntityTypeId as int=(SELECT EntityTypeId from ifcInstance.Entity WHERE GlobalEntityInstanceId=@GlobalEntityInstanceId)
DECLARE @EntityTypeName as nvarchar(max)=(SELECT TypeName from ifcSchema.Type WHERE TypeId=@EntityTypeId)
 DECLARE @msg as nvarchar(max) = 'TypeId=' +  CAST((select @TypeId) AS NVARCHAR(MAX)) 
                                         + ' on OrdinalPosition=' +  CAST((select @OrdinalPosition) AS NVARCHAR(MAX)) 
                                         + ' not allowed for EntityType ifc' + @EntityTypeName 
           RAISERROR (@msg, 16, 10);  
END
GO



CREATE PROCEDURE [ifcSchemaTool].[PrintChangeLog]
@USER nvarchar(max)=null
AS
BEGIN
if (@USER IS NULL) SET @USER=SYSTEM_USER

declare @LastDate as [DateTime]=(SELECT Max([Date]) as LastNotOwnDate  FROM [ifcSQL].[ifcSchemaTool].[ChangeLog] where [Login]<>@USER )
if (@LastDate is NULL) SET @LastDate =(SELECT Min([Date]) as LastNotOwnDate  FROM [ifcSQL].[ifcSchemaTool].[ChangeLog])-1

print 'USE ifcSQL'
print 'go'
print ''


DECLARE @Date datetime
DECLARE @Login VARCHAR(MAX)
DECLARE @CommandText VARCHAR(MAX)


DECLARE CursorView CURSOR FOR SELECT [Date], [Login] ,[CommandText]  FROM [ifcSchemaTool].[ChangeLog] WHERE [Date]>@LastDate order by [Date]
OPEN CursorView; FETCH NEXT FROM CursorView into @Date, @Login ,@CommandText
WHILE @@FETCH_STATUS = 0  BEGIN  print '/*'+ CONVERT(NVARCHAR(MAX),@Date)+', '+@Login+'*/ '
                                 print @CommandText
                                                      print ''
                                                      print  'go'
                                                      print ''

                                 FETCH NEXT FROM CursorView into @Date, @Login ,@CommandText
                                    END;                                                    
CLOSE CursorView; DEALLOCATE CursorView
END
GO



CREATE PROCEDURE [ifcSchemaTool].[ReFill_ifcSchemaDerived_EntityAttributeInstance]
AS
BEGIN
SET NOCOUNT ON;
delete from [ifcSchemaDerived].[EntityAttributeInstance]

-- Nicht-SELECT-Elemente auffüllen (ohne Vererbung)
insert into [ifcSchemaDerived].[EntityAttributeInstance] ([EntityTypeId],[OrdinalPosition],[AttributeInstanceTypeId],[EntityAttributeTableId])
SELECT at.[EntityTypeId],at.[OrdinalPosition],at.AttributeTypeId,t.[EntityAttributeTableId]
  FROM [ifcSQL].[ifcSchema].[EntityAttribute] at 
 inner join [ifcSQL].[ifcSchema].[Type] t 
 on at.AttributeTypeId=t.TypeId
where t.TypeGroupId<>6


-- 1. Vererbungsebene
SELECT ati.[EntityTypeId],ati.[OrdinalPosition],t.TypeId,t.[EntityAttributeTableId]
into #t
  FROM [ifcSQL].[ifcSchemaDerived].[EntityAttributeInstance] ati
inner join [ifcSQL].[ifcSchema].[Type] t 
 on ati.AttributeInstanceTypeId=t.ParentTypeId

insert into [ifcSchemaDerived].[EntityAttributeInstance] select [EntityTypeId],[OrdinalPosition],TypeId,EntityAttributeTableId from #t

-- 2. Vererbungsebene
SELECT ati.[EntityTypeId],ati.[OrdinalPosition],t.TypeId,t.[EntityAttributeTableId]
into #t2
  FROM #t ati
inner join [ifcSQL].[ifcSchema].[Type] t 
 on ati.TypeId=t.ParentTypeId

insert into [ifcSchemaDerived].[EntityAttributeInstance] select [EntityTypeId],[OrdinalPosition],TypeId,EntityAttributeTableId from #t2

-- 3. Vererbungsebene (leer)
SELECT ati.[EntityTypeId],ati.[OrdinalPosition],t.TypeId,t.[EntityAttributeTableId]
into #t3
  FROM #t2 ati
inner join [ifcSQL].[ifcSchema].[Type] t 
 on ati.TypeId=t.ParentTypeId

insert into [ifcSchemaDerived].[EntityAttributeInstance] select [EntityTypeId],[OrdinalPosition],TypeId,EntityAttributeTableId from #t3

-- SELECT-Elemente auffüllen
insert into [ifcSchemaDerived].[EntityAttributeInstance] ([EntityTypeId],[OrdinalPosition],[AttributeInstanceTypeId],[EntityAttributeTableId])
SELECT at.[EntityTypeId],at.[OrdinalPosition],st.SelectTypeId,t.[EntityAttributeTableId]
  FROM [ifcSQL].[ifcSchema].[EntityAttribute] at 
 inner join [ifcSchema].[SelectItem] st 
   inner join [ifcSQL].[ifcSchema].[Type] t on (t.TypeId=st.TypeId) 
 on at.AttributeTypeId=t.TypeId

-- SELECT-Multi-Elemente auffüllen
insert into [ifcSchemaDerived].[EntityAttributeInstance] ([EntityTypeId],[OrdinalPosition],[AttributeInstanceTypeId],[EntityAttributeTableId])
SELECT [EntityTypeId]
      ,[OrdinalPosition]
                --  , t.BaseTypeId
                  ,si.SelectTypeId as [AttributeInstanceTypeId],t.[EntityAttributeTableId]
  FROM ([ifcSQL].[ifcSchema].[EntityAttribute] ea 
  inner join [ifcSQL].[ifcSchema].[Type] t on ea.AttributeTypeId=t.TypeId) 
  inner join  [ifcSchema].[SelectItem] si on t.BaseTypeId=si.TypeId


END
GO




CREATE PROCEDURE [ifcSpecification].[CheckAllDependencies]
AS
BEGIN


UPDATE [ifcSQL].[ifcUser].[UserProjectAssignment] SET [ProjectId] = 1001  WHERE [UserId] =1 and [UserProjectOrdinalPosition] = 0
SELECT SpecificationId, ea.*,t.*  FROM  [ifcSQL].[cp].[Project] , [ifcSQL].[cs].[EntityAttribute] ea left outer join  [ifcSQL].[cs].[Type] t on (ea.AttributeTypeId=t.TypeId) WHERE t.TypeId IS NULL
SELECT SpecificationId, tp.*,t.*  FROM  [ifcSQL].[cp].[Project] , [ifcSQL].[cs].[Type] tp left outer join  [ifcSQL].[cs].[Type] t on (tp.ParentTypeId=t.TypeId) WHERE t.TypeId IS NULL
-- SELECT SpecificationId, si.*,t.*  FROM  [ifcSQL].[cp].[Project] , [ifcSQL].[cs].[SelectItem] si left outer join  [ifcSQL].[cs].[Type] t on (si.SelectTypeId=t.TypeId) WHERE t.TypeId IS NULL
-- SELECT *  FROM [ifcSQL].[cs].[EntityInverseAssignment] inv  left outer join  [ifcSQL].[cs].[Type] t on (inv.OfEntityTypeId=t.TypeId) WHERE t.TypeId IS NULL


UPDATE [ifcSQL].[ifcUser].[UserProjectAssignment] SET [ProjectId] = 1002  WHERE [UserId] =1 and [UserProjectOrdinalPosition] = 0
SELECT SpecificationId, ea.*,t.*  FROM  [ifcSQL].[cp].[Project] , [ifcSQL].[cs].[EntityAttribute] ea left outer join  [ifcSQL].[cs].[Type] t on (ea.AttributeTypeId=t.TypeId) WHERE t.TypeId IS NULL
SELECT SpecificationId, tp.*,t.*  FROM  [ifcSQL].[cp].[Project] , [ifcSQL].[cs].[Type] tp left outer join  [ifcSQL].[cs].[Type] t on (tp.ParentTypeId=t.TypeId) WHERE t.TypeId IS NULL
-- SELECT SpecificationId, si.*,t.*  FROM  [ifcSQL].[cp].[Project] , [ifcSQL].[cs].[SelectItem] si left outer join  [ifcSQL].[cs].[Type] t on (si.SelectTypeId=t.TypeId) WHERE t.TypeId IS NULL
-- SELECT *  FROM [ifcSQL].[cs].[EntityInverseAssignment] inv  left outer join  [ifcSQL].[cs].[Type] t on (inv.OfEntityTypeId=t.TypeId) WHERE t.TypeId IS NULL


UPDATE [ifcSQL].[ifcUser].[UserProjectAssignment] SET [ProjectId] = 1003  WHERE [UserId] =1 and [UserProjectOrdinalPosition] = 0
SELECT SpecificationId, ea.*,t.*  FROM  [ifcSQL].[cp].[Project] , [ifcSQL].[cs].[EntityAttribute] ea left outer join  [ifcSQL].[cs].[Type] t on (ea.AttributeTypeId=t.TypeId) WHERE t.TypeId IS NULL
SELECT SpecificationId, tp.*,t.*  FROM  [ifcSQL].[cp].[Project] , [ifcSQL].[cs].[Type] tp left outer join  [ifcSQL].[cs].[Type] t on (tp.ParentTypeId=t.TypeId) WHERE t.TypeId IS NULL
-- SELECT SpecificationId, si.*,t.*  FROM  [ifcSQL].[cp].[Project] , [ifcSQL].[cs].[SelectItem] si left outer join  [ifcSQL].[cs].[Type] t on (si.SelectTypeId=t.TypeId) WHERE t.TypeId IS NULL
-- SELECT *  FROM [ifcSQL].[cs].[EntityInverseAssignment] inv  left outer join  [ifcSQL].[cs].[Type] t on (inv.OfEntityTypeId=t.TypeId) WHERE t.TypeId IS NULL


UPDATE [ifcSQL].[ifcUser].[UserProjectAssignment] SET [ProjectId] = 1004  WHERE [UserId] =1 and [UserProjectOrdinalPosition] = 0
SELECT SpecificationId, ea.*,t.*  FROM  [ifcSQL].[cp].[Project] , [ifcSQL].[cs].[EntityAttribute] ea left outer join  [ifcSQL].[cs].[Type] t on (ea.AttributeTypeId=t.TypeId) WHERE t.TypeId IS NULL
SELECT SpecificationId, tp.*,t.*  FROM  [ifcSQL].[cp].[Project] , [ifcSQL].[cs].[Type] tp left outer join  [ifcSQL].[cs].[Type] t on (tp.ParentTypeId=t.TypeId) WHERE t.TypeId IS NULL
-- SELECT SpecificationId, si.*,t.*  FROM  [ifcSQL].[cp].[Project] , [ifcSQL].[cs].[SelectItem] si left outer join  [ifcSQL].[cs].[Type] t on (si.SelectTypeId=t.TypeId) WHERE t.TypeId IS NULL
-- SELECT *  FROM [ifcSQL].[cs].[EntityInverseAssignment] inv  left outer join  [ifcSQL].[cs].[Type] t on (inv.OfEntityTypeId=t.TypeId) WHERE t.TypeId IS NULL


UPDATE [ifcSQL].[ifcUser].[UserProjectAssignment] SET [ProjectId] = 1005  WHERE [UserId] =1 and [UserProjectOrdinalPosition] = 0
SELECT SpecificationId, ea.*,t.*  FROM  [ifcSQL].[cp].[Project] , [ifcSQL].[cs].[EntityAttribute] ea left outer join  [ifcSQL].[cs].[Type] t on (ea.AttributeTypeId=t.TypeId) WHERE t.TypeId IS NULL
SELECT SpecificationId, tp.*,t.*  FROM  [ifcSQL].[cp].[Project] , [ifcSQL].[cs].[Type] tp left outer join  [ifcSQL].[cs].[Type] t on (tp.ParentTypeId=t.TypeId) WHERE t.TypeId IS NULL
-- SELECT SpecificationId, si.*,t.*  FROM  [ifcSQL].[cp].[Project] , [ifcSQL].[cs].[SelectItem] si left outer join  [ifcSQL].[cs].[Type] t on (si.SelectTypeId=t.TypeId) WHERE t.TypeId IS NULL
-- SELECT *  FROM [ifcSQL].[cs].[EntityInverseAssignment] inv  left outer join  [ifcSQL].[cs].[Type] t on (inv.OfEntityTypeId=t.TypeId) WHERE t.TypeId IS NULL

END
GO

CREATE PROCEDURE [_____TEST_____].[exec_ToIfcStep_of_example_project]
AS
BEGIN
exec [app].[ToIfcStepFromProjectId] 1006
END
GO

CREATE PROCEDURE [_____TEST_____].[InheritanceOfEntityType]
AS
BEGIN
SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('RepresentationItem','      .') where NestLevel <2 order by sort
SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('GeometricRepresentationItem','      .') where NestLevel <2 order by sort
SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('SolidModel','      .')  order by sort
SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('BooleanResult','      .')  order by sort
SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('CsgPrimitive3D','      .')  order by sort

SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('Product','      .')  order by sort
SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('TypeProduct','      .')  order by sort
SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('Root of entity','      .') where NestLevel <2  order by sort

END
GO

CREATE PROCEDURE [_____TEST_____].[Store_modify_and_retrieve_IFC_data]
AS
BEGIN

EXECUTE [app].[NewProject] 'My new Project'
DECLARE @NewProjectId int =(SELECT [ProjectId] FROM [cp].[Project])
UPDATE [cp].[Project] SET [ProjectGroupId]=5 -- assign to Other Examples Group
UPDATE [cp].[Project] SET [SpecificationId]=44 -- assign to specification IFC4x3.rc.2

DECLARE @EntityCount int =1  -- we use just 1 new entity
EXECUTE [ifcProject].[NewLastGlobalId] @NewProjectId, @EntityCount -- preserve space for the new entities
DECLARE @LastGlobalId int =(SELECT ifcProject.LastGlobalId(@NewProjectId)) -- get the last new GlobalId
DECLARE @StartGlobalId int= @LastGlobalId - @EntityCount +1
DECLARE @CurrentGlobalId int= @StartGlobalId
DECLARE @CurrentLocalId int= 1

-- STORE
DECLARE @ProjectTypeId int =(SELECT [TypeId] FROM [cs].[Type] where [TypeName]='Project')
INSERT INTO [ifcInstance].[Entity] ([GlobalEntityInstanceId], [EntityTypeId]) VALUES (@CurrentGlobalId,@ProjectTypeId)
INSERT INTO [cp].[EntityInstanceIdAssignment] ([ProjectId], [ProjectEntityInstanceId], [GlobalEntityInstanceId]) VALUES (@NewProjectId,@CurrentLocalId,@CurrentGlobalId)
SET @CurrentGlobalId=@CurrentGlobalId+1
SET @CurrentLocalId=@CurrentLocalId+1


DECLARE @GlobalIdAttributeTypeId int =(SELECT [AttributeTypeId] FROM [cs].[EntityAttribute] where [EntityTypeId]=441125 and [AttributeName]='GlobalId')
DECLARE @GlobalIdOrdinalPosition int =(SELECT [OrdinalPosition] FROM [cs].[EntityAttribute] where [EntityTypeId]=441125 and [AttributeName]='GlobalId')
DECLARE @GlobalIdValue nvarchar(15)='1XMjTL$x9AvxoNhhNGFKxn'
INSERT INTO [ifcInstance].[EntityAttributeOfString] ([GlobalEntityInstanceId], [OrdinalPosition], [TypeId], [Value]) VALUES (@CurrentGlobalId,@GlobalIdOrdinalPosition,@GlobalIdAttributeTypeId,@GlobalIdValue)

DECLARE @NameAttributeTypeId     int =(SELECT [AttributeTypeId] FROM [cs].[EntityAttribute] where [EntityTypeId]=441125 and [AttributeName]='Name')
DECLARE @NameOrdinalPosition     int =(SELECT [OrdinalPosition] FROM [cs].[EntityAttribute] where [EntityTypeId]=441125 and [AttributeName]='Name')
DECLARE @NameValue nvarchar(max)='My projectname'
INSERT INTO [ifcInstance].[EntityAttributeOfString] ([GlobalEntityInstanceId], [OrdinalPosition], [TypeId], [Value]) VALUES (@CurrentGlobalId,@NameOrdinalPosition,@NameAttributeTypeId,@NameValue)

-- RETRIEVE
EXECUTE [app].[ToIfcStepFromProjectId] @NewProjectId -- print out the STEP-file

-- MODIFY
DECLARE @ProjectEntityId int =(SELECT [GlobalEntityInstanceId] FROM [cp].[Entity] E INNER JOIN [ifcSQL].[ifcSchema].[Type] T on (E.EntityTypeId=T.TypeId) WHERE T.[TypeName]='Project')
UPDATE [ifcSQL].[cp].[EntityAttributeOfString] SET Value='My modified projectname' WHERE GlobalEntityInstanceId=@ProjectEntityId and OrdinalPosition=@NameOrdinalPosition
EXECUTE [app].[ToIfcStepFromProjectId] @NewProjectId -- print out the STEP-file again

-- RULE-CHECKING
PRINT 'Now an error should occur:'
UPDATE [ifcSQL].[cp].[EntityAttributeOfString] SET Value='projectname at the wrong position' WHERE GlobalEntityInstanceId=@ProjectEntityId and OrdinalPosition=2

END
GO