USE [ifcSQL]
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

UPDATE [ifcSQL].[ifcSchema].[Type] SET [ParentTypeId]=-15 WHERE [TypeName]='Root' -- assign Root-Entity to root of ENTITY

DELETE FROM [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] WHERE TypeId=-13
DELETE FROM [ifcSQL].[ifcSchema].[Type] WHERE [TypeName]='root of TYPE' -- wich is TypeId=-13 and real root is 'root of BASETYPE'

DELETE FROM [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] WHERE TypeId=-18
DELETE FROM [ifcSQL].[ifcSchema].[Type] WHERE [TypeName]='root of SelectBaseType' -- wich is TypeId=-18 and and is not used

