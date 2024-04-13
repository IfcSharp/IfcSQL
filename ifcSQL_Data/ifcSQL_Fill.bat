REM Database-schema of ifcSQL, Copyright (c) 2021, Bernhard Simon Bock, Friedrich Eder, MIT License (see https://github.com/IfcSharp/IfcSharpLibrary/tree/master/Licence)
REM This database runs on Microsoft SQL Server 2019, earlier versions don't support UTF-8
REM The database was testet on Microsoft SQL Server 2019 EXPRESS

SET SqlServer=YourSqlServername
SET ifcSQL=ifcSQL
if "%SqlServer%"=="YourSqlServername" GOTO UseYourServerName
if "%ifcSQL%" NEQ "ifcSQL" echo "The DatabaseName should be ifcSQL"
pause

sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSQL.Licence.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSQL.Release.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSQL.Issues.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSQL.BaseTypeGroup.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSQL.EntityAttributeTable.Table.sql
pause

sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcAPI.ComputerLanguage.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcDocumentation.NaturalLanguage.Table.sql
pause

sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSpecification.SpecificationGroup.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSpecification.Specification.Table.sql

sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSchemaTool.ChangeLogType.Table.sql

sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcProject.ProjectType.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcProject.ProjectGroupType.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcProject.ProjectGroup.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcProject.Project.Table.sql
pause

sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSchema.TypeGroup.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSchema.LayerGroup.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSchema.Layer.Table.sql

sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSchema.Type.DROP_CONSTRAINT.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSchema.Type.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSchema.Type.CREATE_CONSTRAINT.sql
pause

sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSchema.EntityAttribute.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSchema.EntityInverseAssignment.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSchema.EnumItem.Table.sql

sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSchema.SelectItem.Table.sql

sqlcmd -S %SqlServer% -d %ifcSQL% -Q [ifcSchemaTool].[ReFill_ifcSchemaDerived_EntityAttributeInstance]


sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcProperty.SetDef.Table.sql
pause
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcProperty.Def.Table.sql
pause
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcProperty.DefAlias.Table.sql
pause
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcProperty.SetDefAlias.Table.sql
pause
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcProperty.SetDefApplicable.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcProperty.TypePropertyReferenceValue.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcProperty.TypePropertySingleValue.Table.sql
pause

sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcQuantityTakeOff.Type.Table.sql

sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcAPI.TypeComputerLanguageAssignment.Table.sql

sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcSpecification.TypeSpecificationAssignment.Table.sql

sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcUnit.Unit.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcUnit.SIUnitNameUnitOfMeasureEnumAssignment.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcUnit.SIUnitNameEnumDimensionsExponentAssignment.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcUnit.SIPrefixEnumExponentAssigment.Table.sql

sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcInstance.Entity.Table.sql

sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcInstance.EntityAttributeOfEnum.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcInstance.EntityAttributeOfFloat.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcInstance.EntityAttributeOfInteger.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcInstance.EntityAttributeOfList.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcInstance.EntityAttributeOfString.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcInstance.EntityAttributeOfVector.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcInstance.EntityAttributeOfEntityRef.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcInstance.EntityAttributeListElementOfEntityRef.Table.sql

sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcProject.EntityInstanceIdAssignment.Table.sql
sqlcmd -S %SqlServer% -d %ifcSQL% -i ifcProject.LastGlobalEntityInstanceId.Table.sql
pause

sqlcmd -S %SqlServer% -d %ifcSQL% -Q "app.CreateNewUserIfNotExist"
sqlcmd -S %SqlServer% -d %ifcSQL% -Q "app.SelectProject 1006"
pause

goto end
:UseYourServerName
echo Please replace YourSqlServername with your SqlServername.
:end
pause
