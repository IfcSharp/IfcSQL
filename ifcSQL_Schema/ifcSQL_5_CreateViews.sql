-- Database-schema of ifcSQL, Copyright (c) 2021, Bernhard Simon Bock, Friedrich Eder, MIT License (see https://github.com/IfcSharp/IfcSharpLibrary/tree/master/Licence)
-- this database runs on Microsoft SQL Server 2019, earlier versions don't support UTF-8
-- this database was testet on Microsoft SQL Server 2019 EXPRESS
USE [ifcSQL]
GO

CREATE VIEW [cp].[Project] AS SELECT * FROM ifcProject.Project where (ProjectId = cp.ProjectId())
GO

CREATE VIEW [cs].[SelectItem_not_SelectTypeId_bound] as
SELECT cs.* FROM [ifcSchema].[SelectItem] cs inner join [ifcSpecification].[TypeSpecificationAssignment] ts on(cs.TypeId=ts.TypeId) 
inner join [cp].[Project] p on (ts.SpecificationId=p.SpecificationId )
GO

CREATE VIEW [cs].[EntityInverseAssignment_not_OfEntityTypeId_bound] as
SELECT cs.* FROM [ifcSchema].[EntityInverseAssignment] cs inner join [ifcSpecification].[TypeSpecificationAssignment] ts on(cs.EntityTypeId=ts.TypeId) 
-- inner join [ifcSpecification].[TypeSpecificationAssignment] ts2 on(cs.OfEntityTypeId=ts2.TypeId) 
inner join [cp].[Project] p on (ts.SpecificationId=p.SpecificationId 
--and ts2.SpecificationId=p.SpecificationId
)
GO

CREATE VIEW [ifcSpecification].[Current]
AS
SELECT s.*
FROM   [ifcSpecification].[Specification] AS s INNER JOIN [cp].[Project] AS p ON s.SpecificationId = p.SpecificationId
GO

CREATE VIEW [cs].[Type] as
SELECT cs.* FROM [ifcSchema].[Type] cs inner join [ifcSpecification].[TypeSpecificationAssignment] ts on(cs.TypeId=ts.TypeId) 
inner join [cp].[Project] p on (ts.SpecificationId=p.SpecificationId)
GO

CREATE VIEW [cs].[EntityAttribute] as
SELECT cs.* FROM [ifcSchema].[EntityAttribute] cs inner join [ifcSpecification].[TypeSpecificationAssignment] ts on(cs.EntityTypeId=ts.TypeId) 
inner join [cp].[Project] p on (ts.SpecificationId=p.SpecificationId)
GO

CREATE VIEW [cs].[EntityInverseAssignment] as
SELECT cs.* FROM [ifcSchema].[EntityInverseAssignment] cs inner join [ifcSpecification].[TypeSpecificationAssignment] ts on(cs.EntityTypeId=ts.TypeId) 
inner join [ifcSpecification].[TypeSpecificationAssignment] ts2 on(cs.OfEntityTypeId=ts2.TypeId) 
inner join [cp].[Project] p on (ts.SpecificationId=p.SpecificationId and ts2.SpecificationId=p.SpecificationId)
GO

CREATE VIEW [cs].[EnumItem] as
SELECT cs.* FROM [ifcSchema].[EnumItem] cs inner join [ifcSpecification].[TypeSpecificationAssignment] ts on(cs.TypeId=ts.TypeId) 
inner join [cp].[Project] p on (ts.SpecificationId=p.SpecificationId)
GO

CREATE VIEW [cs].[SelectItem] as
SELECT cs.* FROM [ifcSchema].[SelectItem] cs inner join [ifcSpecification].[TypeSpecificationAssignment] ts on(cs.TypeId=ts.TypeId) 
--
inner join [ifcSpecification].[TypeSpecificationAssignment] ts2 on(cs.SelectTypeId=ts2.TypeId) 
--
inner join [cp].[Project] p on (ts.SpecificationId=p.SpecificationId 
and ts2.SpecificationId=p.SpecificationId
)
GO

CREATE VIEW [ifcSchemaTool].[CheckParentTypeSpecificationAssigment] as
SELECT distinct t.ParentTypeId,SpecificationId
  FROM [cs].[Type] t
  left join [cs].[Type] parent_t on (t.ParentTypeId=parent_t.TypeId),ifcSpecification.[Current]
  where t.ParentTypeId is not null and parent_t.TypeId is null
GO

CREATE VIEW [ifcSchemaTool].[CheckEntityAttributeTypeSpecificationAssigment] as
SELECT distinct t.AttributeTypeId,SpecificationId
  FROM [cs].[EntityAttribute] t
  left join [cs].[Type] attrib_t on (t.AttributeTypeId=attrib_t.TypeId),ifcSpecification.[Current]
  where  attrib_t.TypeId is null
GO

CREATE VIEW [ifcSchemaTool].[CheckBaseTypeSpecificationAssigment] as
SELECT distinct t.BaseTypeId,SpecificationId
  FROM [cs].[Type] t
  left join [cs].[Type] base_t on (t.BaseTypeId=base_t.TypeId),ifcSpecification.[Current]
  where t.BaseTypeId is not null and base_t.TypeId is null
GO

CREATE VIEW [ifcSchemaTool].[CheckBaseTypesOfTYPE] as
SELECT distinct t.TypeId
  FROM [cs].[Type] t
   where t.TypeGroupId=3 and t.BaseTypeId is  null
GO

CREATE VIEW [ifcSchemaTool].[CheckEntityInverseAssignmentOfEntityTypeSpecificationAssigment] as
SELECT distinct t.OfEntityTypeId,SpecificationId
  FROM [cs].[EntityInverseAssignment] t
  left join [cs].[Type] attrib_t on (t.OfEntityTypeId=attrib_t.TypeId),ifcSpecification.[Current]
  where  attrib_t.TypeId is null
GO

CREATE VIEW [ifcSchemaTool].[CheckSelectItemSpecificationAssigment] as
SELECT distinct t.SelectTypeId,SpecificationId
  FROM [cs].[SelectItem] t
  left join [cs].[Type] base_t on (t.SelectTypeId=base_t.TypeId),ifcSpecification.[Current]
  where  base_t.TypeId is null
GO

CREATE VIEW [cp].[EntityInstanceIdAssignment] AS SELECT *  FROM [ifcProject].[EntityInstanceIdAssignment]  where (ProjectId = cp.ProjectId())
GO

CREATE VIEW [cp].[Entity] AS SELECT Entity.* FROM ifcInstance.Entity AS Entity INNER JOIN cp.EntityInstanceIdAssignment AS ea ON Entity.GlobalEntityInstanceId = ea.GlobalEntityInstanceId
GO


CREATE VIEW [cp].[EntityVariableName]
AS
SELECT        EntityVariableName.*
FROM            ifcInstance.EntityVariableName AS EntityVariableName INNER JOIN cp.EntityInstanceIdAssignment AS ea ON EntityVariableName.GlobalEntityInstanceId = ea.GlobalEntityInstanceId
GO

CREATE VIEW [cp].[EntityAttributeOfBinary] AS SELECT EntityAttributeOfBinary.*  FROM [ifcInstance].[EntityAttributeOfBinary] EntityAttributeOfBinary inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeOfBinary.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeOfBoolean] AS SELECT EntityAttributeOfBoolean.*  FROM [ifcInstance].[EntityAttributeOfBoolean] EntityAttributeOfBoolean inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeOfBoolean.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeOfEntityRef] AS SELECT EntityAttributeOfEntityRef.*  FROM [ifcInstance].[EntityAttributeOfEntityRef] EntityAttributeOfEntityRef inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeOfEntityRef.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeOfEnum] AS SELECT EntityAttributeOfEnum.*  FROM [ifcInstance].[EntityAttributeOfEnum] EntityAttributeOfEnum inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeOfEnum.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeOfFloat] AS SELECT EntityAttributeOfFloat.*  FROM [ifcInstance].[EntityAttributeOfFloat] EntityAttributeOfFloat inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeOfFloat.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeOfInteger] AS SELECT EntityAttributeOfInteger.*  FROM [ifcInstance].[EntityAttributeOfInteger] EntityAttributeOfInteger inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeOfInteger.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeOfList] AS SELECT EntityAttributeOfList.*  FROM [ifcInstance].[EntityAttributeOfList] EntityAttributeOfList inner join [cp].[EntityInstanceIdAssignment] ea on ([EntityAttributeOfList].[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeOfString] AS SELECT EntityAttributeOfString.*  FROM [ifcInstance].[EntityAttributeOfString] EntityAttributeOfString inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeOfString.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeFormatted] AS
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],null as [ValueStr] FROM [cp].[EntityAttributeOfList] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfBinary] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],'.T. or .F.'+CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfBoolean] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],'#'+CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfEntityRef] union
SELECT a.GlobalEntityInstanceId,a.OrdinalPosition,a.TypeId,'.'+e.[EnumItemName]+'.' as [ValueStr] FROM [cp].[EntityAttributeOfEnum] a inner join [ifcSQL].[ifcSchema].[EnumItem] e on (a.TypeId=e.TypeId and a.Value=e.EnumItemId) union

SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfFloat] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfInteger] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],''''+CONVERT(nvarchar(max),[Value]+'''') as [ValueStr] FROM [cp].[EntityAttributeOfString]
GO

CREATE VIEW [cp].[EntityAttributeListElementOfListElementOfEntityRef] AS SELECT EntityAttributeListElementOfListElementOfEntityRef.*  FROM [ifcInstance].[EntityAttributeListElementOfListElementOfEntityRef] EntityAttributeListElementOfListElementOfEntityRef inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeListElementOfListElementOfEntityRef.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeListElementOfListElementOfFloat] AS SELECT EntityAttributeListElementOfListElementOfFloat.*  FROM [ifcInstance].[EntityAttributeListElementOfListElementOfFloat] EntityAttributeListElementOfListElementOfFloat inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeListElementOfListElementOfFloat.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeListElementOfListElementOfInteger] AS SELECT EntityAttributeListElementOfListElementOfInteger.*  FROM [ifcInstance].[EntityAttributeListElementOfListElementOfInteger] EntityAttributeListElementOfListElementOfInteger inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeListElementOfListElementOfInteger.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeListElementOfListElement] AS
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[ListDim1Position],[ListDim2Position],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeListElementOfListElementOfEntityRef] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[ListDim1Position],[ListDim2Position],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeListElementOfListElementOfFloat] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[ListDim1Position],[ListDim2Position],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeListElementOfListElementOfInteger]
GO

CREATE VIEW [cp].[EntityAttributeListElementOfBinary] AS SELECT EntityAttributeListElementOfBinary.*  FROM [ifcInstance].[EntityAttributeListElementOfBinary] EntityAttributeListElementOfBinary inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeListElementOfBinary.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeListElementOfEntityRef] AS SELECT EntityAttributeListElementOfEntityRef.*  FROM [ifcInstance].[EntityAttributeListElementOfEntityRef] EntityAttributeListElementOfEntityRef inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeListElementOfEntityRef.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeListElementOfFloat] AS SELECT EntityAttributeListElementOfFloat.*  FROM [ifcInstance].[EntityAttributeListElementOfFloat] EntityAttributeListElementOfFloat inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeListElementOfFloat.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeListElementOfInteger] AS SELECT EntityAttributeListElementOfInteger.*  FROM [ifcInstance].[EntityAttributeListElementOfInteger] EntityAttributeListElementOfInteger inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeListElementOfInteger.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeListElementOfList] AS SELECT EntityAttributeListElementOfList.*  FROM [ifcInstance].[EntityAttributeListElementOfList] EntityAttributeListElementOfList inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeListElementOfList.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeListElementOfString] AS SELECT EntityAttributeListElementOfString.*  FROM [ifcInstance].[EntityAttributeListElementOfString] EntityAttributeListElementOfString inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeListElementOfString.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [cp].[EntityAttributeListElement] AS
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[ListDim1Position],null as [ValueStr] FROM [cp].[EntityAttributeListElementOfList] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[ListDim1Position],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeListElementOfBinary] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[ListDim1Position],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeListElementOfEntityRef] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[ListDim1Position],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeListElementOfFloat] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[ListDim1Position],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeListElementOfInteger] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[ListDim1Position],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeListElementOfString]
GO

CREATE VIEW [cp].[EntityAttribute] AS
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],null as [ValueStr] FROM [cp].[EntityAttributeOfList] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfBinary] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfBoolean] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfEntityRef] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfEnum] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfFloat] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfInteger] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfString]
GO

CREATE VIEW [cp].[EntityAttributeOfEntityRef_WithProjectEntityRef] AS 
SELECT ear.[GlobalEntityInstanceId],ear.[OrdinalPosition],ear.[TypeId],ea.[ProjectEntityInstanceId] as [Value] 
FROM [cp].[EntityAttributeOfEntityRef] ear inner join [cp].[EntityInstanceIdAssignment] ea  on (ear.Value=ea.GlobalEntityInstanceId)
GO

CREATE VIEW [cp].[EntityAttribute_WithProjectEntityRef] AS
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],null as [ValueStr] FROM [cp].[EntityAttributeOfList] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfBinary] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfBoolean] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfEntityRef_WithProjectEntityRef] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfEnum] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfFloat] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfInteger] union
SELECT [GlobalEntityInstanceId],[OrdinalPosition],[TypeId],CONVERT(nvarchar(max),[Value]) as [ValueStr] FROM [cp].[EntityAttributeOfString]
GO

CREATE VIEW [cp].[EntityAttributeOfVector] AS SELECT EntityAttributeOfVector.*  FROM [ifcInstance].[EntityAttributeOfVector] EntityAttributeOfVector inner join [cp].[EntityInstanceIdAssignment] ea on (EntityAttributeOfVector.[GlobalEntityInstanceId]=ea.[GlobalEntityInstanceId])
GO

CREATE VIEW [ifcSchemaTool].[SelectTypes] as
SELECT ts.TypeName as SelectTypeName,tgs.TypeGroupName as SelectTypeGroupName, tt.TypeName as SelectedTypeName,tgt.TypeGroupName as SelectedTypeGroupName
  FROM [ifcSQL].[ifcSchema].[SelectItem] si
  inner join [ifcSQL].[ifcSchema].[Type] ts on (si.[TypeId]=ts.TypeId)
  inner join [ifcSQL].[ifcSchema].[Type] tt on (si.[SelectTypeId]=tt.TypeId)
  inner join   [ifcSQL].[ifcSchema].[TypeGroup] tgs on (si.TypeGroupId=tgs.TypeGroupId)
  inner join   [ifcSQL].[ifcSchema].[TypeGroup] tgt on (tt.TypeGroupId=tgt.TypeGroupId)
GO

CREATE VIEW [ifcSchemaTool].[SelectTypesAndSelectedTypeGroups] as
SELECT distinct [SelectTypeName]
      ,[SelectedTypeGroupName]
  FROM [ifcSQL].[ifcSchemaTool].[SelectTypes]
GO

CREATE VIEW [ifcSchemaTool].[SelectTypesAndSelectedTypeGroupsWithDifferentSelectedTypes] as
SELECT  [SelectTypeName],
count([SelectedTypeGroupName]) as cnt  ,
Min([SelectedTypeGroupName]) as MinSelectedTypeGroupName,
Max([SelectedTypeGroupName]) as MaxSelectedTypeGroupName
  FROM [ifcSQL].[ifcSchemaTool].[SelectTypesAndSelectedTypeGroups]
  group by [SelectTypeName]
    having count([SelectedTypeGroupName])>1
GO

CREATE VIEW [ifcSchemaTool].[SelectTypesAndSelectedTypeGroupsWithSingleSelectedType] as
SELECT  [SelectTypeName],
count([SelectedTypeGroupName]) as cnt  ,
Min([SelectedTypeGroupName]) as SelectedTypeGroupName

  FROM [ifcSQL].[ifcSchemaTool].[SelectTypesAndSelectedTypeGroups]
  group by [SelectTypeName]
    having count([SelectedTypeGroupName])=1
GO

CREATE VIEW [cp].[Login] AS
SELECT * from [ifcUser].[Login] 
where ([Login] = SYSTEM_USER)
GO

CREATE VIEW [cp].[User] AS
SELECT U.* FROM ifcUser.[User] U inner join [ifcUser].[Login] L on (U.UserId=L.UserId)
where (L.[Login] = SYSTEM_USER)
GO

CREATE VIEW [cp].[UserProjectAssignment] AS
SELECT * FROM ifcUser.[UserProjectAssignment] 
where (ifcUser.[UserProjectAssignment].UserId = [cp].UserId())
GO


CREATE VIEW [ifcSchemaTool].[ChangeLogScript_for_order_by_Date_and_use_ifcSQL_go_before]
AS
SELECT [Date],'/*'+ CONVERT(NVARCHAR(MAX)  ,[Date])  COLLATE Latin1_General_CS_AS+', '+[Login]+'*/ '+CHAR(13)+CHAR(10)+ [CommandText]+CHAR(13)+CHAR(10)+'GO'+CHAR(13)+CHAR(10) as ScriptLine
  FROM [ifcSchemaTool].[ChangeLog]
GO

CREATE VIEW [ifcSchemaTool].[SelectTypesWithDerivedAttributes] as
SELECT  t.TypeName, a.*
  FROM [ifcSQL].[ifcSchema].[EntityAttribute] a
  inner join [ifcSQL].[ifcSchema].Type t on (a.EntityTypeId=t.TypeId)
  where a.[Derived]<>0
GO

CREATE VIEW [ifcSpecification].[TypeSpecificationMatrix]
AS
SELECT * from (
SELECT t.[TypeId] as TypeId
      ,t.[TypeName],tp.[TypeName] as ParentTypeName,[TypeGroupName]
      ,s.[SchemaName]  as SchemaName

  FROM [ifcSQL].[ifcSchema].[Type] t
inner join [ifcSQL].[ifcSchema].[Type] tp on (tp.TypeId=t.ParentTypeId)
inner join [ifcSQL].[ifcSchema].[TypeGroup] tg on (tg.TypeGroupId=t.TypeGroupId)
inner join [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] ts on (t.[TypeId]=ts.[TypeId])
inner join [ifcSQL].[ifcSpecification].[Specification] s on (ts.SpecificationId=s.SpecificationId)
) tbl
PIVOT(COUNT(tbl.TypeId) 
FOR tbl.SchemaName in([IFC2X3],[IFC4],[IFC4X1],[IFC4X2],[IFC4X3_RC1],[IFC4X3_RC2])
) as pv
GO

CREATE VIEW [ifcSpecification].[TypeSpecificationMatrix_IFC4X1_to_IFC4X3_RC2] AS
SELECT * from (
SELECT t.[TypeId] as TypeId
      ,t.[TypeName]
	 -- ,tp.[TypeName] as ParentTypeName
	  ,[TypeGroupName]
	  ,l.LayerName
      ,s.[SchemaName]  as SchemaName

  FROM [ifcSQL].[ifcSchema].[Type] t
inner join [ifcSQL].[ifcSchema].[Type] tp on (tp.TypeId=t.ParentTypeId)
inner join [ifcSQL].[ifcSchema].[TypeGroup] tg on (tg.TypeGroupId=t.TypeGroupId)
inner join [ifcSQL].[ifcSchema].[Layer] l on (l.LayerId=t.LayerId)
inner join [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] ts on (t.[TypeId]=ts.[TypeId])
inner join [ifcSQL].[ifcSpecification].[Specification] s on (ts.SpecificationId=s.SpecificationId)
) tbl
PIVOT(COUNT(tbl.TypeId) 
FOR tbl.SchemaName in([IFC4X1],[IFC4X3_RC2])
) as pv
GO

CREATE VIEW [ifcSpecification].[UnUsedTypes]
AS
SELECT t.*
      ,ts.SpecificationId
FROM [ifcSQL].[ifcSchema].[Type] t
left join [ifcSQL].[ifcSpecification].[TypeSpecificationAssignment] ts on (t.[TypeId]=ts.[TypeId])
where ts.SpecificationId is null and t.TypeGroupId>2 and t.TypeGroupId<7
GO
 
CREATE VIEW [ifcSQL].[CurrentRelease] AS SELECT * FROM ifcSQL.Release where (ReleaseKey=ifcSQL.CurrentReleaseKey())
GO



CREATE VIEW [cs].[Layer] as
SELECT distinct l.* FROM [ifcSchema].[Layer] l inner join [cs].[Type] t on(l.LayerId=t.LayerId) 
GO
CREATE VIEW [cs].[LayerGroup] as
SELECT distinct lg.* FROM [ifcSchema].[LayerGroup] lg inner join [cs].[Layer] l on (lg.LayerGroupId=l.LayerGroupId) 
GO
CREATE VIEW [cs].[QuantityTakeOffSetDef] as
SELECT t.* FROM [ifcQuantityTakeOff].[QuantityTakeOffSetDef] t where t.SpecificationId=[cs].[SpecificationId] ()
GO
CREATE VIEW [cs].[QuantityTakeOffDef] as
SELECT a.* FROM [cs].[QuantityTakeOffSetDef] t inner join [ifcQuantityTakeOff].[QuantityTakeOffDef] a on (t.SetDefId=a.SetDefId)
GO
CREATE VIEW [cs].[QuantityTakeOffDefAlias] as
SELECT a.* FROM [cs].[QuantityTakeOffDef] d inner join [ifcQuantityTakeOff].[QuantityTakeOffDefAlias] a on (d.DefId=a.DefId)
GO
CREATE VIEW [cs].[QuantityTakeOffSetDefApplicableClass] as
SELECT a.* FROM [cs].[QuantityTakeOffDef] t inner join [ifcQuantityTakeOff].[QuantityTakeOffSetDefApplicableClass] a on (t.SetDefId=a.SetDefId)
GO
CREATE VIEW [cs].[PropertySetDef] as
SELECT p.* FROM [ifcProperty].[PropertySetDef] p where p.SpecificationId=[cs].[SpecificationId] ()
GO
CREATE VIEW [cs].[PropertyDef] as
SELECT a.* FROM [cs].[PropertySetDef] t inner join [ifcProperty].[PropertyDef] a on (t.SetDefId=a.SetDefId)
GO
CREATE VIEW [cs].[PropertySetDefApplicable] as
SELECT a.* FROM [cs].[PropertySetDef] t inner join [ifcProperty].[PropertySetDefApplicable] a on (t.SetDefId=a.SetDefId)
GO
CREATE VIEW [cs].[PropertyDefAlias] as
SELECT a.* FROM [cs].[PropertyDef] t inner join [ifcProperty].[PropertyDefAlias] a on (t.DefId=a.DefId)
GO
CREATE VIEW [cs].[PropertySetDefAlias] as
SELECT a.* FROM [cs].[PropertySetDef] t inner join [ifcProperty].[PropertySetDefAlias] a on (t.SetDefId=a.SetDefId)
GO
CREATE VIEW [cs].[TypeComplexProperty] as
SELECT a.* FROM [cs].[PropertyDef] t inner join [ifcProperty].[TypeComplexProperty] a on (t.DefId=a.DefId)
GO
CREATE VIEW [cs].[TypePropertyBoundedValue] as
SELECT a.* FROM [cs].[PropertyDef] t inner join [ifcProperty].[TypePropertyBoundedValue] a on (t.DefId=a.DefId)
GO
CREATE VIEW [cs].[TypePropertyEnumeratedValue] as
SELECT a.* FROM [cs].[PropertyDef] t inner join [ifcProperty].[TypePropertyEnumeratedValue] a on (t.DefId=a.DefId)
GO
CREATE VIEW [cs].[TypePropertyListValue] as
SELECT a.* FROM [cs].[PropertyDef] t inner join [ifcProperty].[TypePropertyListValue] a on (t.DefId=a.DefId)
GO
CREATE VIEW [cs].[TypePropertyReferenceValue] as
SELECT a.* FROM [cs].[PropertyDef] t inner join [ifcProperty].[TypePropertyReferenceValue] a on (t.DefId=a.DefId)
GO
CREATE VIEW [cs].[TypePropertySingleValue] as
SELECT a.* FROM [cs].[PropertyDef] t inner join [ifcProperty].[TypePropertySingleValue] a on (t.DefId=a.DefId)
GO
CREATE VIEW [cs].[TypePropertyTableValue] as
SELECT a.* FROM [cs].[PropertyDef] t inner join [ifcProperty].[TypePropertyTableValue] a on (t.DefId=a.DefId)
GO
CREATE VIEW [cs].[EntityAttributeDefaultvalue] as
SELECT distinct e.* FROM [ifcSchema].[EntityAttributeDefaultvalue] e inner join [cs].[Type] t on(e.EntityTypeId=t.TypeId) 
GO
CREATE VIEW [cs].[EntityAttributeInstance] as
SELECT distinct e.* FROM [ifcSchemaDerived].[EntityAttributeInstance] e inner join [cs].[Type] t on(e.EntityTypeId=t.TypeId) 
GO
CREATE VIEW [cs].[EnumItemAlias] as
SELECT distinct e.* FROM [ifcSchema].[EnumItemAlias] e inner join [cs].[Type] t on(e.TypeId=t.TypeId) 
GO
CREATE VIEW [cs].[TypeSpecificationAssignment] as
SELECT * FROM  [ifcSpecification].[TypeSpecificationAssignment] where (SpecificationId=[cs].[SpecificationId]())
GO

