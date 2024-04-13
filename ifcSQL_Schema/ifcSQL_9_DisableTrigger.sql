-- Database-schema of ifcSQL, Copyright (c) 2021, Bernhard Simon Bock, Friedrich Eder, MIT License (see https://github.com/IfcSharp/IfcSharpLibrary/tree/master/Licence)
-- this database runs on Microsoft SQL Server 2019, earlier versions don't support UTF-8
-- this database was testet on Microsoft SQL Server 2019 EXPRESS

USE [ifcSQL]
GO

DISABLE TRIGGER [DdlChangeLog] ON DATABASE 
GO


DISABLE TRIGGER [ifcAPI].[ComputerLanguage_AfterDeleteTrigger] ON [ifcAPI].[ComputerLanguage]
GO
DISABLE TRIGGER [ifcAPI].[ComputerLanguage_AfterInsertTrigger] ON [ifcAPI].[ComputerLanguage]
GO
DISABLE TRIGGER [ifcAPI].[ComputerLanguage_AfterUpdateTrigger] ON [ifcAPI].[ComputerLanguage]
GO
DISABLE TRIGGER [ifcAPI].[TypeComputerLanguageAssignment_AfterDeleteTrigger] ON [ifcAPI].[TypeComputerLanguageAssignment]
GO
DISABLE TRIGGER [ifcAPI].[TypeComputerLanguageAssignment_AfterInsertTrigger] ON [ifcAPI].[TypeComputerLanguageAssignment]
GO
DISABLE TRIGGER [ifcAPI].[TypeComputerLanguageAssignment_AfterUpdateTrigger] ON [ifcAPI].[TypeComputerLanguageAssignment]
GO
DISABLE TRIGGER [ifcDocumentation].[HumanLanguage_AfterDeleteTrigger] ON [ifcDocumentation].[NaturalLanguage]
GO
DISABLE TRIGGER [ifcDocumentation].[HumanLanguage_AfterInsertTrigger] ON [ifcDocumentation].[NaturalLanguage]
GO
DISABLE TRIGGER [ifcDocumentation].[HumanLanguage_AfterUpdateTrigger] ON [ifcDocumentation].[NaturalLanguage]
GO
DISABLE TRIGGER [ifcDocumentation].[Type_AfterDeleteTrigger] ON [ifcDocumentation].[DocumentationType]
GO
DISABLE TRIGGER [ifcDocumentation].[Type_AfterInsertTrigger] ON [ifcDocumentation].[DocumentationType]
GO
DISABLE TRIGGER [ifcDocumentation].[Type_AfterUpdateTrigger] ON [ifcDocumentation].[DocumentationType]
GO
DISABLE TRIGGER [ifcInstance].[EntityAfterUpdateTrigger] ON [ifcInstance].[Entity]
GO
DISABLE TRIGGER [ifcInstance].[EntityAttributeOfBinaryAfterUpdateTrigger] ON [ifcInstance].[EntityAttributeOfBinary]
GO
DISABLE TRIGGER [ifcInstance].[EntityAttributeOfBinaryInsteadOfInsertTrigger] ON [ifcInstance].[EntityAttributeOfBinary]
GO
DISABLE TRIGGER [ifcInstance].[EntityAttributeOfBooleanAfterUpdateTrigger] ON [ifcInstance].[EntityAttributeOfBoolean]
GO
DISABLE TRIGGER [ifcInstance].[EntityAttributeOfBooleanInsteadOfInsertTrigger] ON [ifcInstance].[EntityAttributeOfBoolean]
GO
DISABLE TRIGGER [ifcInstance].[EntityAttributeOfEntityRefAfterUpdateTrigger] ON [ifcInstance].[EntityAttributeOfEntityRef]
GO
DISABLE TRIGGER [ifcInstance].[EntityAttributeOfEntityRefInsteadOfInsertTrigger] ON [ifcInstance].[EntityAttributeOfEntityRef]
GO
DISABLE TRIGGER [ifcInstance].[EntityAttributeOfEnumAfterUpdateTrigger] ON [ifcInstance].[EntityAttributeOfEnum]
GO
DISABLE TRIGGER [ifcInstance].[EntityAttributeOfEnumInsteadOfInsertTrigger] ON [ifcInstance].[EntityAttributeOfEnum]
GO
DISABLE TRIGGER [ifcInstance].[EntityAttributeOfIntegerAfterUpdateTrigger] ON [ifcInstance].[EntityAttributeOfInteger]
GO
DISABLE TRIGGER [ifcInstance].[EntityAttributeOfIntegerInsteadOfInsertTrigger] ON [ifcInstance].[EntityAttributeOfInteger]
GO
DISABLE TRIGGER [ifcInstance].[EntityAttributeOfStringAfterUpdateTrigger] ON [ifcInstance].[EntityAttributeOfString]
GO
DISABLE TRIGGER [ifcInstance].[EntityAttributeOfStringInsteadOfInsertTrigger] ON [ifcInstance].[EntityAttributeOfString]
GO
DISABLE TRIGGER [ifcInstance].[EntityInsteadOfInsertTrigger] ON [ifcInstance].[Entity]
GO
DISABLE TRIGGER [ifcProperty].[Def_AfterDeleteTrigger] ON [ifcProperty].[PropertyDef]
GO
DISABLE TRIGGER [ifcProperty].[Def_AfterInsertTrigger] ON [ifcProperty].[PropertyDef]
GO
DISABLE TRIGGER [ifcProperty].[Def_AfterUpdateTrigger] ON [ifcProperty].[PropertyDef]
GO
DISABLE TRIGGER [ifcProperty].[DefAlias_AfterDeleteTrigger] ON [ifcProperty].[PropertyDefAlias]
GO
DISABLE TRIGGER [ifcProperty].[DefAlias_AfterInsertTrigger] ON [ifcProperty].[PropertyDefAlias]
GO
DISABLE TRIGGER [ifcProperty].[DefAlias_AfterUpdateTrigger] ON [ifcProperty].[PropertyDefAlias]
GO
DISABLE TRIGGER [ifcProperty].[SetDef_AfterDeleteTrigger] ON [ifcProperty].[PropertySetDef]
GO
DISABLE TRIGGER [ifcProperty].[SetDef_AfterInsertTrigger] ON [ifcProperty].[PropertySetDef]
GO
DISABLE TRIGGER [ifcProperty].[SetDef_AfterUpdateTrigger] ON [ifcProperty].[PropertySetDef]
GO
DISABLE TRIGGER [ifcProperty].[TypeComplexProperty_AfterDeleteTrigger] ON [ifcProperty].[TypeComplexProperty]
GO
DISABLE TRIGGER [ifcProperty].[TypeComplexProperty_AfterInsertTrigger] ON [ifcProperty].[TypeComplexProperty]
GO
DISABLE TRIGGER [ifcProperty].[TypeComplexProperty_AfterUpdateTrigger] ON [ifcProperty].[TypeComplexProperty]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertyBoundedValue_AfterDeleteTrigger] ON [ifcProperty].[TypePropertyBoundedValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertyBoundedValue_AfterInsertTrigger] ON [ifcProperty].[TypePropertyBoundedValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertyBoundedValue_AfterUpdateTrigger] ON [ifcProperty].[TypePropertyBoundedValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertyEnumeratedValue_AfterDeleteTrigger] ON [ifcProperty].[TypePropertyEnumeratedValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertyEnumeratedValue_AfterInsertTrigger] ON [ifcProperty].[TypePropertyEnumeratedValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertyEnumeratedValue_AfterUpdateTrigger] ON [ifcProperty].[TypePropertyEnumeratedValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertyListValue_AfterDeleteTrigger] ON [ifcProperty].[TypePropertyListValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertyListValue_AfterInsertTrigger] ON [ifcProperty].[TypePropertyListValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertyListValue_AfterUpdateTrigger] ON [ifcProperty].[TypePropertyListValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertyReferenceValue_AfterDeleteTrigger] ON [ifcProperty].[TypePropertyReferenceValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertyReferenceValue_AfterInsertTrigger] ON [ifcProperty].[TypePropertyReferenceValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertyReferenceValue_AfterUpdateTrigger] ON [ifcProperty].[TypePropertyReferenceValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertySingleValue_AfterDeleteTrigger] ON [ifcProperty].[TypePropertySingleValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertySingleValue_AfterInsertTrigger] ON [ifcProperty].[TypePropertySingleValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertySingleValue_AfterUpdateTrigger] ON [ifcProperty].[TypePropertySingleValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertyTableValue_AfterDeleteTrigger] ON [ifcProperty].[TypePropertyTableValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertyTableValue_AfterInsertTrigger] ON [ifcProperty].[TypePropertyTableValue]
GO
DISABLE TRIGGER [ifcProperty].[TypePropertyTableValue_AfterUpdateTrigger] ON [ifcProperty].[TypePropertyTableValue]
GO
DISABLE TRIGGER [ifcQuantityTakeOff].[Def_AfterDeleteTrigger] ON [ifcQuantityTakeOff].[QuantityTakeOffDef]
GO
DISABLE TRIGGER [ifcQuantityTakeOff].[Def_AfterInsertTrigger] ON [ifcQuantityTakeOff].[QuantityTakeOffDef]
GO
DISABLE TRIGGER [ifcQuantityTakeOff].[Def_AfterUpdateTrigger] ON [ifcQuantityTakeOff].[QuantityTakeOffDef]
GO
DISABLE TRIGGER [ifcQuantityTakeOff].[DefAlias_AfterDeleteTrigger] ON [ifcQuantityTakeOff].[QuantityTakeOffDefAlias]
GO
DISABLE TRIGGER [ifcQuantityTakeOff].[DefAlias_AfterInsertTrigger] ON [ifcQuantityTakeOff].[QuantityTakeOffDefAlias]
GO
DISABLE TRIGGER [ifcQuantityTakeOff].[DefAlias_AfterUpdateTrigger] ON [ifcQuantityTakeOff].[QuantityTakeOffDefAlias]
GO
DISABLE TRIGGER [ifcQuantityTakeOff].[SetDef_AfterDeleteTrigger] ON [ifcQuantityTakeOff].[QuantityTakeOffSetDef]
GO
DISABLE TRIGGER [ifcQuantityTakeOff].[SetDef_AfterInsertTrigger] ON [ifcQuantityTakeOff].[QuantityTakeOffSetDef]
GO
DISABLE TRIGGER [ifcQuantityTakeOff].[SetDef_AfterUpdateTrigger] ON [ifcQuantityTakeOff].[QuantityTakeOffSetDef]
GO
DISABLE TRIGGER [ifcQuantityTakeOff].[SetDefApplicableClass_AfterDeleteTrigger] ON [ifcQuantityTakeOff].[QuantityTakeOffSetDefApplicableClass]
GO
DISABLE TRIGGER [ifcQuantityTakeOff].[SetDefApplicableClass_AfterInsertTrigger] ON [ifcQuantityTakeOff].[QuantityTakeOffSetDefApplicableClass]
GO
DISABLE TRIGGER [ifcQuantityTakeOff].[SetDefApplicableClass_AfterUpdateTrigger] ON [ifcQuantityTakeOff].[QuantityTakeOffSetDefApplicableClass]
GO
DISABLE TRIGGER [ifcQuantityTakeOff].[Type_AfterDeleteTrigger] ON [ifcQuantityTakeOff].[QuantityTakeOffType]
GO
DISABLE TRIGGER [ifcQuantityTakeOff].[Type_AfterInsertTrigger] ON [ifcQuantityTakeOff].[QuantityTakeOffType]
GO
DISABLE TRIGGER [ifcQuantityTakeOff].[Type_AfterUpdateTrigger] ON [ifcQuantityTakeOff].[QuantityTakeOffType]
GO
DISABLE TRIGGER [ifcSchema].[EntityAttribute_AfterDeleteTrigger] ON [ifcSchema].[EntityAttribute]
GO
DISABLE TRIGGER [ifcSchema].[EntityAttribute_AfterInsertTrigger] ON [ifcSchema].[EntityAttribute]
GO
DISABLE TRIGGER [ifcSchema].[EntityAttribute_AfterUpdateTrigger] ON [ifcSchema].[EntityAttribute]
GO
DISABLE TRIGGER [ifcSchema].[EntityInverseAssignment_AfterDeleteTrigger] ON [ifcSchema].[EntityInverseAssignment]
GO
DISABLE TRIGGER [ifcSchema].[EntityInverseAssignment_AfterInsertTrigger] ON [ifcSchema].[EntityInverseAssignment]
GO
DISABLE TRIGGER [ifcSchema].[EntityInverseAssignment_AfterUpdateTrigger] ON [ifcSchema].[EntityInverseAssignment]
GO
DISABLE TRIGGER [ifcSchema].[EnumItem_AfterDeleteTrigger] ON [ifcSchema].[EnumItem]
GO
DISABLE TRIGGER [ifcSchema].[EnumItem_AfterInsertTrigger] ON [ifcSchema].[EnumItem]
GO
DISABLE TRIGGER [ifcSchema].[EnumItem_AfterUpdateTrigger] ON [ifcSchema].[EnumItem]
GO
DISABLE TRIGGER [ifcSchema].[Layer_AfterDeleteTrigger] ON [ifcSchema].[Layer]
GO
DISABLE TRIGGER [ifcSchema].[Layer_AfterInsertTrigger] ON [ifcSchema].[Layer]
GO
DISABLE TRIGGER [ifcSchema].[Layer_AfterUpdateTrigger] ON [ifcSchema].[Layer]
GO
DISABLE TRIGGER [ifcSchema].[SelectItem_AfterDeleteTrigger] ON [ifcSchema].[SelectItem]
GO
DISABLE TRIGGER [ifcSchema].[SelectItem_AfterInsertTrigger] ON [ifcSchema].[SelectItem]
GO
DISABLE TRIGGER [ifcSchema].[SelectItem_AfterUpdateTrigger] ON [ifcSchema].[SelectItem]
GO
DISABLE TRIGGER [ifcSchema].[Type_AfterDeleteTrigger] ON [ifcSchema].[Type]
GO
DISABLE TRIGGER [ifcSchema].[Type_AfterInsertTrigger] ON [ifcSchema].[Type]
GO
DISABLE TRIGGER [ifcSchema].[Type_AfterUpdateTrigger] ON [ifcSchema].[Type]
GO
DISABLE TRIGGER [ifcSchema].[TypeGroup_AfterDeleteTrigger] ON [ifcSchema].[TypeGroup]
GO
DISABLE TRIGGER [ifcSchema].[TypeGroup_AfterInsertTrigger] ON [ifcSchema].[TypeGroup]
GO
DISABLE TRIGGER [ifcSchema].[TypeGroup_AfterUpdateTrigger] ON [ifcSchema].[TypeGroup]
GO
DISABLE TRIGGER [ifcSchemaTool].[ChangeLogType_AfterDeleteTrigger] ON [ifcSchemaTool].[ChangeLogType]
GO
DISABLE TRIGGER [ifcSchemaTool].[ChangeLogType_AfterInsertTrigger] ON [ifcSchemaTool].[ChangeLogType]
GO
DISABLE TRIGGER [ifcSchemaTool].[ChangeLogType_AfterUpdateTrigger] ON [ifcSchemaTool].[ChangeLogType]
GO
DISABLE TRIGGER [ifcSpecification].[Specification_AfterDeleteTrigger] ON [ifcSpecification].[Specification]
GO
DISABLE TRIGGER [ifcSpecification].[Specification_AfterInsertTrigger] ON [ifcSpecification].[Specification]
GO
DISABLE TRIGGER [ifcSpecification].[Specification_AfterUpdateTrigger] ON [ifcSpecification].[Specification]
GO
DISABLE TRIGGER [ifcSpecification].[SpecificationGroup_AfterDeleteTrigger] ON [ifcSpecification].[SpecificationGroup]
GO
DISABLE TRIGGER [ifcSpecification].[SpecificationGroup_AfterInsertTrigger] ON [ifcSpecification].[SpecificationGroup]
GO
DISABLE TRIGGER [ifcSpecification].[SpecificationGroup_AfterUpdateTrigger] ON [ifcSpecification].[SpecificationGroup]
GO
DISABLE TRIGGER [ifcSpecification].[TypeSpecificationAssignment_AfterDeleteTrigger] ON [ifcSpecification].[TypeSpecificationAssignment]
GO
DISABLE TRIGGER [ifcSpecification].[TypeSpecificationAssignment_AfterInsertTrigger] ON [ifcSpecification].[TypeSpecificationAssignment]
GO
DISABLE TRIGGER [ifcSpecification].[TypeSpecificationAssignment_AfterUpdateTrigger] ON [ifcSpecification].[TypeSpecificationAssignment]
GO
DISABLE TRIGGER [ifcSQL].[BaseTypeGroup_AfterDeleteTrigger] ON [ifcSQL].[BaseTypeGroup]
GO
DISABLE TRIGGER [ifcSQL].[BaseTypeGroup_AfterInsertTrigger] ON [ifcSQL].[BaseTypeGroup]
GO
DISABLE TRIGGER [ifcSQL].[BaseTypeGroup_AfterUpdateTrigger] ON [ifcSQL].[BaseTypeGroup]
GO
DISABLE TRIGGER [ifcSQL].[EntityAttributeTable_AfterDeleteTrigger] ON [ifcSQL].[EntityAttributeTable]
GO
DISABLE TRIGGER [ifcSQL].[EntityAttributeTable_AfterInsertTrigger] ON [ifcSQL].[EntityAttributeTable]
GO
DISABLE TRIGGER [ifcSQL].[EntityAttributeTable_AfterUpdateTrigger] ON [ifcSQL].[EntityAttributeTable]
GO
DISABLE TRIGGER [ifcSQL].[Licence_AfterDeleteTrigger] ON [ifcSQL].[Licence]
GO
DISABLE TRIGGER [ifcSQL].[Licence_AfterInsertTrigger] ON [ifcSQL].[Licence]
GO
DISABLE TRIGGER [ifcSQL].[Licence_AfterUpdateTrigger] ON [ifcSQL].[Licence]
GO
DISABLE TRIGGER [ifcSQL].[Release_AfterDeleteTrigger] ON [ifcSQL].[Release]
GO
DISABLE TRIGGER [ifcSQL].[Release_AfterInsertTrigger] ON [ifcSQL].[Release]
GO
DISABLE TRIGGER [ifcSQL].[Release_AfterUpdateTrigger] ON [ifcSQL].[Release]
GO
