-- Database-schema of ifcSQL, Copyright (c) 2021, Bernhard Simon Bock, Friedrich Eder, MIT License (see https://github.com/IfcSharp/IfcSharpLibrary/tree/master/Licence)
-- this database runs on Microsoft SQL Server 2019, earlier versions don't support UTF-8
-- this database was testet on Microsoft SQL Server 2019 EXPRESS
USE [ifcSQL]
GO

CREATE FUNCTION [cp].[ProjectId]()
RETURNS int AS
BEGIN
return (SELECT ifcUser.UserProjectAssignment.ProjectId
FROM   ifcUser.[Login] INNER JOIN  ifcUser.UserProjectAssignment ON ifcUser.[Login].UserId = ifcUser.UserProjectAssignment.UserId
WHERE (ifcUser.[Login].Login = SYSTEM_USER) AND (ifcUser.UserProjectAssignment.UserProjectOrdinalPosition = 0))
END
GO

CREATE FUNCTION [cp].[UserId]()
RETURNS int AS
BEGIN
return (SELECT UserId
FROM   ifcUser.[Login] 
WHERE ([Login]  = SYSTEM_USER) )
END
GO

CREATE FUNCTION [cs].[SpecificationId]()
RETURNS int AS
BEGIN
return (SELECT  [SpecificationId] FROM [ifcSQL].[ifcSpecification].[Current])
END
GO


CREATE FUNCTION [ifcInstance].[EntityAttributeFormatted]  (@GlobalEntityInstanceId as [ifcInstance].[Id])
RETURNS @Attributes TABLE([GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL, [OrdinalPosition] [ifcOrder].[Position] NOT NULL,     [TypeId] [ifcSchema].[Id] NOT NULL, [ValueStr] NVARCHAR(MAX) )
AS BEGIN
INSERT INTO @Attributes
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],[ifcInstance].[EntityAttributeListElementFormattedString]([GlobalEntityInstanceId],[OrdinalPosition]) as [ValueStr] FROM [ifcInstance].[EntityAttributeOfList] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId  union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeOfBinary] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],'.T. or .F.'+CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeOfBoolean] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],'#'+CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeOfEntityRef] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId union
SELECT a.GlobalEntityInstanceId,a.OrdinalPosition,a.TypeId,'.'+e.[EnumItemName]+'.' as [ValueStr] FROM [ifcInstance].[EntityAttributeOfEnum] a inner join [ifcSQL].[ifcSchema].[EnumItem] e on (a.TypeId=e.TypeId and a.Value=e.EnumItemId) where [GlobalEntityInstanceId]=@GlobalEntityInstanceId union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeOfFloat] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeOfInteger] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId], IIF([TypeId]<0,'/*','''')+CONVERT(nvarchar(max),[Value]+IIF([TypeId]<0,'*/','''')) as [ValueStr] FROM [ifcInstance].[EntityAttributeOfString] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],'('+CONVERT(nvarchar(max),CONVERT(nvarchar(max),[X])+','+CONVERT(nvarchar(max),[Y])  +IIF([Z] is not null,','+CONVERT(nvarchar(max),[Z]),'')+')' ) as [ValueStr] FROM [ifcInstance].[EntityAttributeOfVector] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId
RETURN
END
GO

CREATE FUNCTION [ifcInstance].[EntityAttributeListElementFormatted]  (@GlobalEntityInstanceId as [ifcInstance].[Id], @OrdinalPosition [ifcOrder].[Position])
RETURNS @Attributes TABLE([GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL, [OrdinalPosition] [ifcOrder].[Position] NOT NULL, [ValueStr] NVARCHAR(MAX) )
AS BEGIN
INSERT INTO @Attributes
-- EntityAttributeListElementOfList
SELECT [GlobalEntityInstanceId],[OrdinalPosition],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeListElementOfBinary] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId and [OrdinalPosition]=@OrdinalPosition union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],'#'+CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeListElementOfEntityRef] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId and [OrdinalPosition]=@OrdinalPosition  union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeListElementOfFloat] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId and [OrdinalPosition]=@OrdinalPosition  union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeListElementOfInteger] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId and [OrdinalPosition]=@OrdinalPosition  union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],''''+CONVERT(nvarchar(max),[Value]+'''') as [ValueStr] FROM [ifcInstance].[EntityAttributeListElementOfString] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId and [OrdinalPosition]=@OrdinalPosition 
RETURN
END
GO

CREATE FUNCTION [ifcInstance].[EntityAttributeListElementFormattedString](@GlobalEntityInstanceId as [ifcInstance].[Id], @OrdinalPosition [ifcOrder].[Position])
RETURNS VARCHAR(MAX) AS
BEGIN
DECLARE @IfcLine VARCHAR(MAX)= '('
DECLARE @ValueStr nvarchar(max)
DECLARE CursorView CURSOR FOR SELECT ValueStr FROM [ifcInstance].[EntityAttributeListElementFormatted](@GlobalEntityInstanceId, @OrdinalPosition)
OPEN CursorView; FETCH NEXT FROM CursorView into @ValueStr
WHILE @@FETCH_STATUS = 0  BEGIN  SET @IfcLine=@IfcLine+@ValueStr+','
                                 FETCH NEXT FROM CursorView into @ValueStr
                                    END;                                                    
CLOSE CursorView; DEALLOCATE CursorView
return @IfcLine+')'
END
GO

CREATE FUNCTION [ifcInstance].[EntityAttributeListElementOfListElementFormatted]  (@GlobalEntityInstanceId as [ifcInstance].[Id], @OrdinalPosition [ifcOrder].[Position], @ListDim1Position [ifcOrder].[Position])
RETURNS @Attributes TABLE([GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL, [OrdinalPosition] [ifcOrder].[Position] NOT NULL, [ValueStr] NVARCHAR(MAX) )
AS BEGIN
INSERT INTO @Attributes
SELECT [GlobalEntityInstanceId],[OrdinalPosition],'#'+CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeListElementOfListElementOfEntityRef] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId and [OrdinalPosition]=@OrdinalPosition and [ListDim1Position]=@ListDim1Position union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeListElementOfListElementOfFloat] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId and [OrdinalPosition]=@OrdinalPosition and [ListDim1Position]=@ListDim1Position union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [ifcInstance].[EntityAttributeListElementOfListElementOfInteger] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId and [OrdinalPosition]=@OrdinalPosition and [ListDim1Position]=@ListDim1Position
RETURN
END
GO

CREATE FUNCTION [ifcInstance].[ToIfcStepLine](@GlobalEntityInstanceId as [ifcInstance].[Id])
RETURNS VARCHAR(MAX) AS
BEGIN
DECLARE @IfcTypeStr VARCHAR(MAX)=(SELECT UPPER(t.TypeName) from ifcSchema.Type t inner join ifcInstance.Entity e on (e.EntityTypeId=t.TypeId) where e.[GlobalEntityInstanceId]=@GlobalEntityInstanceId)
DECLARE @EntityTypeId INT=(SELECT EntityTypeId from  ifcInstance.Entity where GlobalEntityInstanceId=@GlobalEntityInstanceId)
DECLARE @IfcLine VARCHAR(MAX)=''
DECLARE @IfcLineEnd VARCHAR(2)=''
if (@IfcTypeStr<>'ENTITYCOMMENT') begin SET @IfcLine= '#'+(SELECT CONVERT(VARCHAR(MAX),[ProjectEntityInstanceId])+'=' FROM [ifcSQL].[ifcProject].[EntityInstanceIdAssignment] where [GlobalEntityInstanceId]=@GlobalEntityInstanceId)
                                                         + (SELECT 'IFC'+ UPPER(t.TypeName)+'(' from ifcSchema.Type t inner join ifcInstance.Entity e on (e.EntityTypeId=t.TypeId) where e.[GlobalEntityInstanceId]=@GlobalEntityInstanceId)
                                        SET @IfcLineEnd=')'
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
GO


CREATE FUNCTION [ifcProject].[LastGlobalId](@ProjectId as int)
RETURNS [ifcInstance].[Id] AS
BEGIN
return (SELECT max([GlobalEntityInstanceId])  FROM [ifcProject].[LastGlobalEntityInstanceId] where [ProjectId]=@ProjectId  )
END
GO

CREATE FUNCTION [ifcSchema].[AttributeNames](@EntityTypeId as [ifcSchema].[Id])
RETURNS VARCHAR(MAX) AS
BEGIN
DECLARE @EntityArgs nvarchar(max)=''
DECLARE @ValueStr nvarchar(max)
DECLARE @TypeStr nvarchar(max)
DECLARE @ValueSeparator nvarchar(1)=''
DECLARE CursorView CURSOR FOR 
SELECT TypeName, [AttributeName] FROM [ifcSQL].[ifcSchema].[EntityAttribute] ea inner join [ifcSQL].[ifcSchema].[Type] t on (t.TypeId=ea.AttributeTypeId) where ea.EntityTypeId=@EntityTypeId 
order by ea.OrdinalPosition

OPEN CursorView; FETCH NEXT FROM CursorView into @TypeStr, @ValueStr
WHILE @@FETCH_STATUS = 0  BEGIN  SET @EntityArgs=@EntityArgs+@ValueSeparator+@ValueStr
                                 SET @ValueSeparator=','
                                 FETCH NEXT FROM CursorView into @TypeStr,@ValueStr
                                    END;                                                    
CLOSE CursorView; DEALLOCATE CursorView

return @EntityArgs
END
GO


CREATE FUNCTION [ifcSchema].[Attributes](@EntityTypeId as [ifcSchema].[Id])
RETURNS VARCHAR(MAX) AS
BEGIN
DECLARE @EntityArgs nvarchar(max)=''
DECLARE @ValueStr nvarchar(max)
DECLARE @TypeStr nvarchar(max)
DECLARE @ValueSeparator nvarchar(1)=''
DECLARE CursorView CURSOR FOR 
SELECT TypeName, [AttributeName] FROM [ifcSQL].[ifcSchema].[EntityAttribute] ea inner join [ifcSQL].[ifcSchema].[Type] t on (t.TypeId=ea.AttributeTypeId) where ea.EntityTypeId=@EntityTypeId 
order by ea.OrdinalPosition

OPEN CursorView; FETCH NEXT FROM CursorView into @TypeStr, @ValueStr
WHILE @@FETCH_STATUS = 0  BEGIN  SET @EntityArgs=@EntityArgs+@ValueSeparator+@TypeStr+' '+@ValueStr
                                 SET @ValueSeparator=','
                                 FETCH NEXT FROM CursorView into @TypeStr,@ValueStr
                                    END;                                                    
CLOSE CursorView; DEALLOCATE CursorView

return @EntityArgs
END
GO

CREATE FUNCTION [ifcSchema].[AttributeTypes](@EntityTypeId as [ifcSchema].[Id])
RETURNS VARCHAR(MAX) AS
BEGIN
DECLARE @EntityArgs nvarchar(max)=''
DECLARE @ValueStr nvarchar(max)
DECLARE @TypeStr nvarchar(max)
DECLARE @ValueSeparator nvarchar(1)=''
DECLARE CursorView CURSOR FOR 
SELECT TypeName, [AttributeName] FROM [ifcSQL].[ifcSchema].[EntityAttribute] ea inner join [ifcSQL].[ifcSchema].[Type] t on (t.TypeId=ea.AttributeTypeId) where ea.EntityTypeId=@EntityTypeId 
order by ea.OrdinalPosition

OPEN CursorView; FETCH NEXT FROM CursorView into @TypeStr, @ValueStr
WHILE @@FETCH_STATUS = 0  BEGIN  SET @EntityArgs=@EntityArgs+@ValueSeparator+@TypeStr
                                 SET @ValueSeparator=','
                                 FETCH NEXT FROM CursorView into @TypeStr,@ValueStr
                                    END;                                                    
CLOSE CursorView; DEALLOCATE CursorView

return @EntityArgs
END
GO

CREATE FUNCTION [ifcSchema].[DerivedAttributeNames](@EntityTypeId as [ifcSchema].[Id])
RETURNS VARCHAR(MAX) AS
BEGIN
DECLARE @EntityArgs nvarchar(max)=''
DECLARE @ValueStr nvarchar(max)
DECLARE @TypeStr nvarchar(max)
DECLARE @ValueSeparator nvarchar(1)=''
DECLARE CursorView CURSOR FOR 
SELECT TypeName, [AttributeName] FROM [ifcSQL].[ifcSchema].[EntityAttribute] ea inner join [ifcSQL].[ifcSchema].[Type] t on (t.TypeId=ea.AttributeTypeId) where ea.EntityTypeId=@EntityTypeId and [AttributeIsFromBaseClass]<>0
order by ea.OrdinalPosition

OPEN CursorView; FETCH NEXT FROM CursorView into @TypeStr, @ValueStr
WHILE @@FETCH_STATUS = 0  BEGIN  SET @EntityArgs=@EntityArgs+@ValueSeparator+@ValueStr
                                 SET @ValueSeparator=','
                                 FETCH NEXT FROM CursorView into @TypeStr,@ValueStr
                                    END;                                                    
CLOSE CursorView; DEALLOCATE CursorView

return @EntityArgs
END
GO

CREATE FUNCTION [ifcSchema].[DerivedAttributes](@EntityTypeId as [ifcSchema].[Id])
RETURNS VARCHAR(MAX) AS
BEGIN
DECLARE @EntityArgs nvarchar(max)=''
DECLARE @ValueStr nvarchar(max)
DECLARE @TypeStr nvarchar(max)
DECLARE @ValueSeparator nvarchar(1)=''

DECLARE CursorView CURSOR FOR 
SELECT TypeName, [AttributeName] FROM [ifcSQL].[ifcSchema].[EntityAttribute] ea inner join [ifcSQL].[ifcSchema].[Type] t on (t.TypeId=ea.AttributeTypeId) where ea.EntityTypeId=@EntityTypeId and [AttributeIsFromBaseClass]<>0
order by ea.OrdinalPosition

OPEN CursorView; FETCH NEXT FROM CursorView into @TypeStr, @ValueStr
WHILE @@FETCH_STATUS = 0  BEGIN  SET @EntityArgs=@EntityArgs+@ValueSeparator+@TypeStr+' '+@ValueStr
                                 SET @ValueSeparator=','
                                 FETCH NEXT FROM CursorView into @TypeStr,@ValueStr
                                    END;                                                    
CLOSE CursorView; DEALLOCATE CursorView

return @EntityArgs
END
GO

CREATE FUNCTION [ifcSchema].[DerivedAttributeTypes](@EntityTypeId as [ifcSchema].[Id])
RETURNS VARCHAR(MAX) AS
BEGIN
DECLARE @EntityArgs nvarchar(max)=''
DECLARE @ValueStr nvarchar(max)
DECLARE @TypeStr nvarchar(max)
DECLARE @ValueSeparator nvarchar(1)=''
DECLARE CursorView CURSOR FOR 
SELECT TypeName, [AttributeName] FROM [ifcSQL].[ifcSchema].[EntityAttribute] ea inner join [ifcSQL].[ifcSchema].[Type] t on (t.TypeId=ea.AttributeTypeId) where ea.EntityTypeId=@EntityTypeId and [AttributeIsFromBaseClass]<>0
order by ea.OrdinalPosition

OPEN CursorView; FETCH NEXT FROM CursorView into @TypeStr, @ValueStr
WHILE @@FETCH_STATUS = 0  BEGIN  SET @EntityArgs=@EntityArgs+@ValueSeparator+@TypeStr
                                 SET @ValueSeparator=','
                                 FETCH NEXT FROM CursorView into @TypeStr,@ValueStr
                                    END;                                                    
CLOSE CursorView; DEALLOCATE CursorView

return @EntityArgs
END
GO


CREATE FUNCTION [ifcSchema].[NonDerivedAttributeNames](@EntityTypeId as [ifcSchema].[Id])
RETURNS VARCHAR(MAX) AS
BEGIN
DECLARE @EntityArgs nvarchar(max)=''
DECLARE @ValueStr nvarchar(max)
DECLARE @TypeStr nvarchar(max)
DECLARE @ValueSeparator nvarchar(1)=''
DECLARE CursorView CURSOR FOR 
SELECT TypeName, [AttributeName] FROM [ifcSQL].[ifcSchema].[EntityAttribute] ea inner join [ifcSQL].[ifcSchema].[Type] t on (t.TypeId=ea.AttributeTypeId) where ea.EntityTypeId=@EntityTypeId and [AttributeIsFromBaseClass]=0
order by ea.OrdinalPosition

OPEN CursorView; FETCH NEXT FROM CursorView into @TypeStr, @ValueStr
WHILE @@FETCH_STATUS = 0  BEGIN  SET @EntityArgs=@EntityArgs+@ValueSeparator+@ValueStr
                                 SET @ValueSeparator=','
                                 FETCH NEXT FROM CursorView into @TypeStr,@ValueStr
                                    END;                                                    
CLOSE CursorView; DEALLOCATE CursorView

return @EntityArgs
END
GO

CREATE FUNCTION [ifcSchema].[NonDerivedAttributes](@EntityTypeId as [ifcSchema].[Id])
RETURNS VARCHAR(MAX) AS
BEGIN
DECLARE @EntityArgs nvarchar(max)=''
DECLARE @ValueStr nvarchar(max)
DECLARE @TypeStr nvarchar(max)
DECLARE @ValueSeparator nvarchar(1)=''
DECLARE CursorView CURSOR FOR 
SELECT TypeName, [AttributeName] FROM [ifcSQL].[ifcSchema].[EntityAttribute] ea inner join [ifcSQL].[ifcSchema].[Type] t on (t.TypeId=ea.AttributeTypeId) where ea.EntityTypeId=@EntityTypeId and [AttributeIsFromBaseClass]=0
order by ea.OrdinalPosition

OPEN CursorView; FETCH NEXT FROM CursorView into @TypeStr, @ValueStr
WHILE @@FETCH_STATUS = 0  BEGIN  SET @EntityArgs=@EntityArgs+@ValueSeparator+@TypeStr+' '+@ValueStr
                                 SET @ValueSeparator=','
                                 FETCH NEXT FROM CursorView into @TypeStr,@ValueStr
                                    END;                                                    
CLOSE CursorView; DEALLOCATE CursorView

return @EntityArgs
END
GO

CREATE FUNCTION [ifcSchema].[NonDerivedAttributeTypes](@EntityTypeId as [ifcSchema].[Id])
RETURNS VARCHAR(MAX) AS
BEGIN
DECLARE @EntityArgs nvarchar(max)=''
DECLARE @ValueStr nvarchar(max)
DECLARE @TypeStr nvarchar(max)
DECLARE @ValueSeparator nvarchar(1)=''
DECLARE CursorView CURSOR FOR 
SELECT TypeName, [AttributeName] FROM [ifcSQL].[ifcSchema].[EntityAttribute] ea inner join [ifcSQL].[ifcSchema].[Type] t on (t.TypeId=ea.AttributeTypeId) where ea.EntityTypeId=@EntityTypeId and [AttributeIsFromBaseClass]=0
order by ea.OrdinalPosition

OPEN CursorView; FETCH NEXT FROM CursorView into @TypeStr, @ValueStr
WHILE @@FETCH_STATUS = 0  BEGIN  SET @EntityArgs=@EntityArgs+@ValueSeparator+@TypeStr
                                 SET @ValueSeparator=','
                                 FETCH NEXT FROM CursorView into @TypeStr,@ValueStr
                                    END;                                                    
CLOSE CursorView; DEALLOCATE CursorView

return @EntityArgs
END
GO

CREATE FUNCTION [ifcSchema].[Type_Ancestor](@TypeId AS INT) 
    RETURNS @TREE TABLE
(
    TypeId   [ifcSchema].[Id] NOT NULL
    ,TypeName [ifcSchema].[IndexableName] NOT NULL
    ,ParentTypeId   [ifcSchema].[Id] NULL -- parent
    ,NestLevel  INT NOT NULL
)
AS
BEGIN
  
  INSERT INTO @TREE
    SELECT * FROM  [ifcSchema].[Type_AncestorOrSelf](@TypeId)  where TypeId <> @TypeId;
  RETURN
END
GO

CREATE FUNCTION [ifcSchema].[Type_AncestorByName](@TypeName AS [ifcSchema].[IndexableName]) 
    RETURNS @TREE TABLE
(
    TypeId   [ifcSchema].[Id] NOT NULL
    ,TypeName [ifcSchema].[IndexableName] NOT NULL
    ,ParentTypeId   [ifcSchema].[Id] NULL -- parent
    ,NestLevel  INT NOT NULL
)
AS
BEGIN
  WITH Type_Uptree(TypeId,TypeName,ParentTypeId,NestLevel)
  AS
  (
    -- Anchor TypeId
    SELECT t.TypeId,TypeName,ParentTypeId,0
    FROM [ifcSchema].[Type] t inner join [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] s on (t.TypeId=s.TypeId)
    WHERE TypeName = @TypeName COLLATE Latin1_General_CS_AS and s.SpecificationId=[cs].[SpecificationId]()

    UNION all

    -- Recursive Types
    SELECT t.TypeId,t.TypeName,t.ParentTypeId,st.NestLevel-1
    FROM [ifcSchema].[Type] AS t
      JOIN Type_Uptree AS st
        ON st.ParentTypeId = t.TypeId
  )
  INSERT INTO @TREE  SELECT * FROM Type_Uptree;
  DELETE FROM @TREE  where NestLevel=0

  RETURN
END
GO

CREATE FUNCTION [ifcSchema].[Type_AncestorOrSelf](@TypeId AS INT) 
    RETURNS @TREE TABLE
(
    TypeId   [ifcSchema].[Id] NOT NULL
    ,TypeName [ifcSchema].[IndexableName] NOT NULL
    ,ParentTypeId   [ifcSchema].[Id] NULL -- parent
    ,NestLevel  INT NOT NULL
)
AS
BEGIN
  WITH Type_Uptree(TypeId,TypeName,ParentTypeId,NestLevel)
  AS
  (
    -- Anchor TypeId
    SELECT t.TypeId,TypeName,ParentTypeId,0
    FROM [ifcSchema].[Type] t inner join [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] s on (t.TypeId=s.TypeId)
    WHERE t.TypeId = @TypeId and s.SpecificationId=[cs].[SpecificationId]()

    UNION all

    -- Recursive Types
    SELECT t.TypeId,t.TypeName,t.ParentTypeId,st.NestLevel-1
    FROM [ifcSchema].[Type] AS t
      JOIN Type_Uptree AS st
        ON st.ParentTypeId = t.TypeId
  )
  INSERT INTO @TREE
    SELECT * FROM Type_Uptree;

  RETURN
END
GO

CREATE FUNCTION [ifcSchema].[Type_AncestorOrSelfByName](@TypeName AS [ifcSchema].[IndexableName]) 
    RETURNS @TREE TABLE
(
    TypeId   [ifcSchema].[Id] NOT NULL
    ,TypeName [ifcSchema].[IndexableName] NOT NULL
    ,ParentTypeId   [ifcSchema].[Id] NULL -- parent
    ,NestLevel  INT NOT NULL
)
AS
BEGIN
  WITH Type_Uptree(TypeId,TypeName,ParentTypeId,NestLevel)
  AS
  (
    -- Anchor TypeId
    SELECT t.TypeId,TypeName,ParentTypeId,0
    FROM [ifcSchema].[Type] t inner join [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] s on (t.TypeId=s.TypeId)
    WHERE TypeName = @TypeName COLLATE Latin1_General_CS_AS and s.SpecificationId=[cs].[SpecificationId]()

    UNION all

    -- Recursive Types
    SELECT t.TypeId,t.TypeName,t.ParentTypeId,st.NestLevel-1
    FROM [ifcSchema].[Type] AS t
      JOIN Type_Uptree AS st
        ON st.ParentTypeId = t.TypeId
  )
  INSERT INTO @TREE
    SELECT * FROM Type_Uptree;

  RETURN
END
GO

CREATE FUNCTION [ifcSchema].[Type_Descendant](@TypeId AS INT) 
    RETURNS @TREE TABLE
(
    TypeId   [ifcSchema].[Id] NOT NULL
    ,TypeName [ifcSchema].[IndexableName] NOT NULL
    ,ParentTypeId   [ifcSchema].[Id] NULL -- parent
	,Abstract [Bool].[YesNo] NULL
    ,NestLevel  INT NOT NULL
)
AS
BEGIN
  INSERT INTO @TREE
    SELECT * FROM  [ifcSchema].[Type_DescendantOrSelf](@TypeId)  where TypeId <> @TypeId;
  RETURN
END
GO


CREATE FUNCTION [ifcSchema].[Type_DescendantByName](@TypeName AS [ifcSchema].[IndexableName]) 
    RETURNS @TREE TABLE
(
    TypeId   [ifcSchema].[Id] NOT NULL
    ,TypeName [ifcSchema].[IndexableName] NOT NULL
    ,ParentTypeId   [ifcSchema].[Id] NULL -- parent
	,Abstract [Bool].[YesNo] NULL
    ,NestLevel  INT NOT NULL
)
AS
BEGIN
  INSERT INTO @TREE
    SELECT * FROM  [ifcSchema].[Type_DescendantOrSelf](@TypeName)  where TypeName <> @TypeName;
  RETURN
END
GO


CREATE FUNCTION [ifcSchema].[Type_DescendantOrSelf](@TypeId AS INT) 
    RETURNS @TREE TABLE
(
    TypeId   [ifcSchema].[Id] NOT NULL
    ,TypeName [ifcSchema].[IndexableName] NOT NULL
    ,ParentTypeId   [ifcSchema].[Id] NULL -- parent
	,Abstract [Bool].[YesNo] NULL
    ,NestLevel  INT NOT NULL
)
AS
BEGIN
  WITH Type_Subtree(TypeId,TypeName,ParentTypeId,Abstract,NestLevel)
  AS
  (
    -- Anchor TypeId
    SELECT t.TypeId,TypeName,ParentTypeId,Abstract,0
    FROM [ifcSchema].[Type] t inner join [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] s on (t.TypeId=s.TypeId)
    WHERE t.TypeId = @TypeId and s.SpecificationId=[cs].[SpecificationId]()

    UNION all

    -- Recursive Types
    SELECT t.TypeId,t.TypeName,t.ParentTypeId,t.Abstract,st.NestLevel+1
    FROM [ifcSchema].[Type] AS t
      JOIN Type_Subtree AS st
        ON t.ParentTypeId = st.TypeId
  )
  INSERT INTO @TREE
    SELECT * FROM Type_Subtree;

  RETURN
END
GO


CREATE FUNCTION [ifcSchema].[Type_DescendantOrSelfByName](@TypeName AS [ifcSchema].[IndexableName]) 
    RETURNS @TREE TABLE
(
    TypeId   [ifcSchema].[Id] NOT NULL
    ,TypeName [ifcSchema].[IndexableName] NOT NULL
    ,ParentTypeId   [ifcSchema].[Id] NULL -- parent
	,Abstract [Bool].[YesNo] NULL
    ,NestLevel  INT NOT NULL
)
AS
BEGIN
  WITH Type_Subtree(TypeId,TypeName,ParentTypeId,Abstract,NestLevel)
  AS
  (
    -- Anchor TypeId
    SELECT t.TypeId,TypeName,ParentTypeId,Abstract,0
    FROM [ifcSchema].[Type] t inner join [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] s on (t.TypeId=s.TypeId)
    WHERE TypeName = @TypeName COLLATE Latin1_General_CS_AS and s.SpecificationId=[cs].[SpecificationId]()
    

    UNION all

    -- Recursive Types
    SELECT t.TypeId,t.TypeName,t.ParentTypeId,t.Abstract,st.NestLevel+1
    FROM [ifcSchema].[Type] AS t
      JOIN Type_Subtree AS st
        ON t.ParentTypeId = st.TypeId
  )
  INSERT INTO @TREE
    SELECT * FROM Type_Subtree;

  RETURN
END
GO

CREATE FUNCTION [ifcSchema].[Type_IsSubclassOf] (@SubClassTypeId AS INT,@ParentTypeId AS INT) RETURNS BIT
AS
BEGIN
declare @res bit=0;
if (EXISTS (( SELECT TypeId FROM [ifcSchema].[Type_AncestorOrSelfByName](@SubClassTypeId) where TypeName=@ParentTypeId ))) set @res=-1
return @res
END
GO

CREATE FUNCTION [ifcSchema].[Type_IsSubclassOfByName] (@SubClassTypeName AS [ifcSchema].[IndexableName],@ParentTypeName AS [ifcSchema].[IndexableName]) RETURNS BIT
AS
BEGIN
declare @res bit=0;
if (EXISTS (( SELECT TypeId FROM [ifcSchema].[Type_AncestorOrSelfByName](@SubClassTypeName) where TypeName=@ParentTypeName ))) set @res=-1
return @res
END
GO

CREATE FUNCTION [ifcSchema].[Type_Root]() 
    RETURNS @TREE TABLE
(
    TypeId   [ifcSchema].[Id] NOT NULL
    ,TypeName [ifcSchema].[IndexableName] NOT NULL
    ,ParentTypeId   [ifcSchema].[Id] NULL -- parent
    ,NestLevel  INT NOT NULL
)
AS
BEGIN
  INSERT INTO @TREE
    SELECT t.TypeId ,TypeName,ParentTypeId,0 as NestLevel 
	FROM [ifcSchema].[Type] t inner join [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] s on (t.TypeId=s.TypeId)
	WHERE ParentTypeId is null and s.SpecificationId=[cs].[SpecificationId]()
  RETURN
END
GO

CREATE FUNCTION [ifcSchema].[Type_RootEntity]() 
    RETURNS @TREE TABLE
(
    TypeId   [ifcSchema].[Id] NOT NULL
    ,TypeName [ifcSchema].[IndexableName] NOT NULL
    ,ParentTypeId   [ifcSchema].[Id] NULL -- parent
    ,NestLevel  INT NOT NULL
)
AS
BEGIN
  INSERT INTO @TREE
    SELECT t.TypeId ,TypeName,ParentTypeId,0 as NestLevel 
	FROM [ifcSchema].[Type] t inner join [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] s on (t.TypeId=s.TypeId)
	WHERE ParentTypeId is null and TypeGroupId=5 and s.SpecificationId=[cs].[SpecificationId]()

  RETURN
END
GO

CREATE FUNCTION [ifcSchema].[Type_Tree](@TypeId AS [ifcSchema].[Id], @InsertString as varchar(MAX)) 
    RETURNS @TREE TABLE
(
    TypeId   [ifcSchema].[Id] NOT NULL
    ,TypeName [ifcSchema].[IndexableName] NOT NULL
    ,ParentTypeId   [ifcSchema].[Id] NULL -- parent
	,Abstract [Bool].[YesNo] NULL
    ,NestLevel  INT NOT NULL
    ,sort varchar(MAX)
	,CountedInsertString varchar(MAX)
)
AS
BEGIN
  WITH Type_Subtree(TypeId,TypeName,ParentTypeId,Abstract,NestLevel,sort,CountedInsertString)
  AS
  (
    -- Anchor TypeId
    SELECT t.TypeId,TypeName,ParentTypeId,Abstract,0,sort=cast(t.TypeId as varchar(max)),replicate(@InsertString,0)
     FROM [ifcSchema].[Type] t inner join [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] s on (t.TypeId=s.TypeId)
    WHERE t.TypeId = @TypeId and s.SpecificationId=[cs].[SpecificationId]()


    UNION all

    -- Recursive Types
    SELECT t.TypeId,t.TypeName,t.ParentTypeId,t.Abstract,st.NestLevel+1,sort=st.sort + cast(t.TypeId as varchar(max)),replicate(@InsertString,st.NestLevel+1)
    FROM [ifcSchema].[Type] AS t
      JOIN Type_Subtree AS st
        ON t.ParentTypeId = st.TypeId
  )
  INSERT INTO @TREE
    SELECT * FROM Type_Subtree;
/*
SELECT CountedInsertString + TypeName +' ( TypeId='+CONVERT(nvarchar(max),TypeId)+')' from [ifcSQL].[ifcSchema].[Type_Tree]  (0,'      .')  order by sort
*/
  RETURN
END
GO
 
CREATE FUNCTION [ifcSchema].[Type_TreeByName](@TypeName AS [ifcSchema].[IndexableName], @InsertString as varchar(MAX)) 
    RETURNS @TREE TABLE
(
    TypeId   [ifcSchema].[Id] NOT NULL
    ,TypeName [ifcSchema].[IndexableName] NOT NULL
	,Attributes varchar(MAX)
	,AttributeTypes varchar(MAX)
	,AttributeNames varchar(MAX)
    ,ParentTypeId   [ifcSchema].[Id] NULL -- parent
	,Abstract [Bool].[YesNo] NULL
    ,NestLevel  INT NOT NULL
    ,sort varchar(MAX)
	,CountedInsertString varchar(MAX)
)
AS
BEGIN
  WITH Type_Subtree(TypeId,TypeName,Attributes,AttributeTypes,AttributeNames,ParentTypeId,Abstract,NestLevel,sort,CountedInsertString)
  AS
  (
    -- Anchor TypeId
    SELECT t.TypeId as TypeId,TypeName,
	       [ifcSchema].[NonDerivedAttributes](t.TypeId) as Attributes,
		   [ifcSchema].[NonDerivedAttributeTypes](t.TypeId) as AttributeTypes,
		   [ifcSchema].[NonDerivedAttributeNames](t.TypeId) as AttributeNames,
		   ParentTypeId,Abstract,0,sort=cast(t.TypeId as varchar(max)),replicate(@InsertString,0)
    FROM [ifcSchema].[Type] t inner join [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] s on (t.TypeId=s.TypeId)
    WHERE TypeName = @TypeName COLLATE Latin1_General_CS_AS and s.SpecificationId=[cs].[SpecificationId]()

    UNION all

    -- Recursive Types
    SELECT t.TypeId,t.TypeName,
	       [ifcSchema].[NonDerivedAttributes](t.TypeId) as Attributes,
		   [ifcSchema].[NonDerivedAttributeTypes](t.TypeId) as AttributeTypes,
		   [ifcSchema].[NonDerivedAttributeNames](t.TypeId) as AttributeNames,
		   t.ParentTypeId,t.Abstract,st.NestLevel+1,sort=st.sort + cast(t.TypeId as varchar(max)),replicate(@InsertString,st.NestLevel+1)
    FROM [ifcSchema].[Type] AS t
      JOIN Type_Subtree AS st
        ON t.ParentTypeId = st.TypeId
  )
  INSERT INTO @TREE
    SELECT * FROM Type_Subtree;
/*
SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('RepresentationItem','      .') where NestLevel <2 order by sort
SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('GeometricRepresentationItem','      .') where NestLevel <2 order by sort
SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('SolidModel','      .')  order by sort
SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('BooleanResult','      .')  order by sort
SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('CsgPrimitive3D','      .')  order by sort

SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('Product','      .')  order by sort
SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('TypeProduct','      .')  order by sort
SELECT CountedInsertString + TypeName from [ifcSQL].[ifcSchema].[Type_TreeByName]  ('Root of entity','      .') where NestLevel <2  order by sort
*/
  RETURN
END
GO

CREATE FUNCTION [ifcSchema].[TypeId] (@TypeName AS [ifcSchema].[IndexableName]) RETURNS INT
AS
BEGIN
return (SELECT TypeId FROM [cs].[Type] where TypeName=@TypeName) 
END
GO


CREATE FUNCTION [ifcSchemaTool].[ValidEntityAtrributeType]
(
@GlobalEntityInstanceId [ifcInstance].[Id],
@OrdinalPosition [ifcOrder].[Position],
@TypeId [ifcSchema].[Id]
)
RETURNS BIT
AS
BEGIN

DECLARE @EntityTypeId as int=(SELECT EntityTypeId from ifcInstance.Entity WHERE GlobalEntityInstanceId=@GlobalEntityInstanceId)

declare @res bit=0;
if (EXISTS ((SELECT * from ifcSchemaDerived.EntityAttributeInstance WHERE EntityTypeId=@EntityTypeId and AttributeInstanceTypeId= @TypeId and OrdinalPosition=@OrdinalPosition)))
set @res=-1
return @res
END
GO
 
CREATE FUNCTION [ifcSQL].[CurrentReleaseId]()
RETURNS float AS
BEGIN
return (SELECT Max([ReleaseId]) FROM [ifcSQL].[Release])
END
GO
 
CREATE FUNCTION [ifcSQL].[CurrentReleaseKey]()
RETURNS [Text].[Key] AS
BEGIN
return (SELECT Max([ReleaseKey]) FROM [ifcSQL].[Release])
END
GO

