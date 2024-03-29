-- Database-schema of ifcSQL, Copyright (c) 2021, Bernhard Simon Bock, Friedrich Eder, MIT License (see https://github.com/IfcSharp/IfcSharpLibrary/tree/master/Licence)
-- this database runs on Microsoft SQL Server 2019, earlier versions don't support UTF-8
-- this database was testet on Microsoft SQL Server 2019 EXPRESS
USE [ifcSQL]
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Type] ON [ifcSchema].[Type]
(
	[TypeId] ASC,
	[TypeGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [ifcSchema].[Type] ADD  CONSTRAINT [DF_Type_Dim1MinOccurs]  DEFAULT ((1)) FOR [MinOccurs]
GO
ALTER TABLE [ifcSchema].[Type] ADD  CONSTRAINT [DF_Type_Dim1MaxOccurs]  DEFAULT ((1)) FOR [MaxOccurs]
GO
ALTER TABLE [ifcAPI].[TypeComputerLanguageAssignment]  WITH CHECK ADD  CONSTRAINT [FK_TypeLanguage_Language] FOREIGN KEY([ComputerLanguageId])
REFERENCES [ifcAPI].[ComputerLanguage] ([ComputerLanguageId])
GO
ALTER TABLE [ifcAPI].[TypeComputerLanguageAssignment] CHECK CONSTRAINT [FK_TypeLanguage_Language]
GO
ALTER TABLE [ifcAPI].[TypeComputerLanguageAssignment]  WITH CHECK ADD  CONSTRAINT [FK_TypeLanguage_Type] FOREIGN KEY([TypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcAPI].[TypeComputerLanguageAssignment] CHECK CONSTRAINT [FK_TypeLanguage_Type]
GO
ALTER TABLE [ifcDocumentation].[Type]  WITH CHECK ADD  CONSTRAINT [FK_EntityDocumentation_Type] FOREIGN KEY([EntityTypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcDocumentation].[Type] CHECK CONSTRAINT [FK_EntityDocumentation_Type]
GO
ALTER TABLE [ifcInstance].[Entity]  WITH NOCHECK ADD  CONSTRAINT [FK_Entity_Type] FOREIGN KEY([EntityTypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcInstance].[Entity] CHECK CONSTRAINT [FK_Entity_Type]
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfBinary]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeListElementOfBinary_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfBinary] CHECK CONSTRAINT [FK_EntityAttributeListElementOfBinary_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfEntityRef]  WITH NOCHECK ADD  CONSTRAINT [FK_EntityAttributeListElementOfEntityRef_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfEntityRef] CHECK CONSTRAINT [FK_EntityAttributeListElementOfEntityRef_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfEntityRef]  WITH NOCHECK ADD  CONSTRAINT [FK_EntityAttributeListElementOfEntityRef_Entity1] FOREIGN KEY([Value])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfEntityRef] CHECK CONSTRAINT [FK_EntityAttributeListElementOfEntityRef_Entity1]
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfFloat]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeListElementOfFloat_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfFloat] CHECK CONSTRAINT [FK_EntityAttributeListElementOfFloat_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfInteger]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeListElementOfInteger_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfInteger] CHECK CONSTRAINT [FK_EntityAttributeListElementOfInteger_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfList]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeListElementOfList_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfList] CHECK CONSTRAINT [FK_EntityAttributeListElementOfList_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfListElementOfEntityRef]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeListElementOfListElementOfEntityRef_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfListElementOfEntityRef] CHECK CONSTRAINT [FK_EntityAttributeListElementOfListElementOfEntityRef_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfListElementOfEntityRef]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeListElementOfListElementOfEntityRef_Entity1] FOREIGN KEY([Value])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfListElementOfEntityRef] CHECK CONSTRAINT [FK_EntityAttributeListElementOfListElementOfEntityRef_Entity1]
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfListElementOfFloat]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeListElementOfListElementOfFloat_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfListElementOfFloat] CHECK CONSTRAINT [FK_EntityAttributeListElementOfListElementOfFloat_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfListElementOfInteger]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeListElementOfListElementOfInteger_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfListElementOfInteger] CHECK CONSTRAINT [FK_EntityAttributeListElementOfListElementOfInteger_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfString]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeListElementOfString_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeListElementOfString] CHECK CONSTRAINT [FK_EntityAttributeListElementOfString_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfBinary]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeOfBinary_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfBinary] CHECK CONSTRAINT [FK_EntityAttributeOfBinary_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfBoolean]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeOfBoolean_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfBoolean] CHECK CONSTRAINT [FK_EntityAttributeOfBoolean_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfEntityRef]  WITH NOCHECK ADD  CONSTRAINT [FK_EntityAttributeOfEntityRef_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfEntityRef] CHECK CONSTRAINT [FK_EntityAttributeOfEntityRef_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfEntityRef]  WITH NOCHECK ADD  CONSTRAINT [FK_EntityAttributeOfEntityRef_Entity1] FOREIGN KEY([Value])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfEntityRef] CHECK CONSTRAINT [FK_EntityAttributeOfEntityRef_Entity1]
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfEnum]  WITH NOCHECK ADD  CONSTRAINT [FK_EntityAttributeOfEnum_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfEnum] CHECK CONSTRAINT [FK_EntityAttributeOfEnum_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfFloat]  WITH NOCHECK ADD  CONSTRAINT [FK_EntityAttributeOfFloat_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfFloat] CHECK CONSTRAINT [FK_EntityAttributeOfFloat_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfInteger]  WITH NOCHECK ADD  CONSTRAINT [FK_EntityAttributeOfInteger_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfInteger] CHECK CONSTRAINT [FK_EntityAttributeOfInteger_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfList]  WITH NOCHECK ADD  CONSTRAINT [FK_EntityAttributeOfList_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfList] CHECK CONSTRAINT [FK_EntityAttributeOfList_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfString]  WITH NOCHECK ADD  CONSTRAINT [FK_EntityAttributeOfString_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfString] CHECK CONSTRAINT [FK_EntityAttributeOfString_Entity]
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfVector]  WITH NOCHECK ADD  CONSTRAINT [FK_EntityAttributeOfVector_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityAttributeOfVector] CHECK CONSTRAINT [FK_EntityAttributeOfVector_Entity]
GO
ALTER TABLE [ifcInstance].[EntityVariableName]  WITH CHECK ADD  CONSTRAINT [FK_EntityVariableName_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcInstance].[EntityVariableName] CHECK CONSTRAINT [FK_EntityVariableName_Entity]
GO
ALTER TABLE [ifcProject].[EntityInstanceIdAssignment]  WITH NOCHECK ADD  CONSTRAINT [FK_ifcEntityInstanceIdAssignment_Entity] FOREIGN KEY([GlobalEntityInstanceId])
REFERENCES [ifcInstance].[Entity] ([GlobalEntityInstanceId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ifcProject].[EntityInstanceIdAssignment] CHECK CONSTRAINT [FK_ifcEntityInstanceIdAssignment_Entity]
GO
ALTER TABLE [ifcProject].[EntityInstanceIdAssignment]  WITH NOCHECK ADD  CONSTRAINT [FK_ifcEntityInstanceIdAssignment_Project] FOREIGN KEY([ProjectId])
REFERENCES [ifcProject].[Project] ([ProjectId])
GO
ALTER TABLE [ifcProject].[EntityInstanceIdAssignment] CHECK CONSTRAINT [FK_ifcEntityInstanceIdAssignment_Project]
GO
ALTER TABLE [ifcProject].[Project]  WITH CHECK ADD  CONSTRAINT [FK_ifcProject_ProjectGroup] FOREIGN KEY([ProjectGroupId])
REFERENCES [ifcProject].[ProjectGroup] ([ProjectGroupId])
GO
ALTER TABLE [ifcProject].[Project] CHECK CONSTRAINT [FK_ifcProject_ProjectGroup]
GO
ALTER TABLE [ifcProject].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_Specification] FOREIGN KEY([SpecificationId])
REFERENCES [ifcSpecification].[Specification] ([SpecificationId])
GO
ALTER TABLE [ifcProject].[Project] CHECK CONSTRAINT [FK_Project_Specification]
GO
ALTER TABLE [ifcProject].[ProjectGroup]  WITH CHECK ADD  CONSTRAINT [FK_ifcProjectGroup_ProjectGroup] FOREIGN KEY([ParentProjectGroupId])
REFERENCES [ifcProject].[ProjectGroup] ([ProjectGroupId])
GO
ALTER TABLE [ifcProject].[ProjectGroup] CHECK CONSTRAINT [FK_ifcProjectGroup_ProjectGroup]
GO
ALTER TABLE [ifcProject].[ProjectGroup]  WITH CHECK ADD  CONSTRAINT [FK_ifcProjectGroup_ProjectGroupType] FOREIGN KEY([ProjectGroupTypeId])
REFERENCES [ifcProject].[ProjectGroupType] ([ProjectGroupTypeId])
GO
ALTER TABLE [ifcProject].[ProjectGroup] CHECK CONSTRAINT [FK_ifcProjectGroup_ProjectGroupType]
GO
ALTER TABLE [ifcProperty].[Def]  WITH CHECK ADD  CONSTRAINT [FK_Def_SetDef] FOREIGN KEY([SetDefId])
REFERENCES [ifcProperty].[SetDef] ([SetDefId])
GO
ALTER TABLE [ifcProperty].[Def] CHECK CONSTRAINT [FK_Def_SetDef]
GO
ALTER TABLE [ifcProperty].[DefAlias]  WITH CHECK ADD  CONSTRAINT [FK_DefAlias_Def] FOREIGN KEY([DefId])
REFERENCES [ifcProperty].[Def] ([DefId])
GO
ALTER TABLE [ifcProperty].[DefAlias] CHECK CONSTRAINT [FK_DefAlias_Def]
GO
ALTER TABLE [ifcProperty].[DefAlias]  WITH CHECK ADD  CONSTRAINT [FK_DefAlias_HumanLanguage] FOREIGN KEY([HumanLanguageId])
REFERENCES [ifcDocumentation].[NaturalLanguage] ([NaturalLanguageId])
GO
ALTER TABLE [ifcProperty].[DefAlias] CHECK CONSTRAINT [FK_DefAlias_HumanLanguage]
GO
ALTER TABLE [ifcProperty].[SetDefAlias]  WITH CHECK ADD  CONSTRAINT [FK_SetDefAlias_Def] FOREIGN KEY([SetDefId])
REFERENCES [ifcProperty].[SetDef] ([SetDefId])
GO
ALTER TABLE [ifcProperty].[SetDefAlias] CHECK CONSTRAINT [FK_SetDefAlias_Def]
GO
ALTER TABLE [ifcProperty].[SetDefAlias]  WITH CHECK ADD  CONSTRAINT [FK_SetDefAlias_HumanLanguage] FOREIGN KEY([HumanLanguageId])
REFERENCES [ifcDocumentation].[NaturalLanguage] ([NaturalLanguageId])
GO
ALTER TABLE [ifcProperty].[SetDefAlias] CHECK CONSTRAINT [FK_SetDefAlias_HumanLanguage]
GO
ALTER TABLE [ifcProperty].[SetDefApplicable]  WITH CHECK ADD  CONSTRAINT [FK_SetDefApplicable_EntityType] FOREIGN KEY([EntityTypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcProperty].[SetDefApplicable] CHECK CONSTRAINT [FK_SetDefApplicable_EntityType]
GO
ALTER TABLE [ifcProperty].[SetDefApplicable]  WITH CHECK ADD  CONSTRAINT [FK_SetDefApplicable_EnumType] FOREIGN KEY([EnumTypeId], [EnumItemId])
REFERENCES [ifcSchema].[EnumItem] ([TypeId], [EnumItemId])
GO
ALTER TABLE [ifcProperty].[SetDefApplicable] CHECK CONSTRAINT [FK_SetDefApplicable_EnumType]
GO
ALTER TABLE [ifcProperty].[SetDefApplicable]  WITH CHECK ADD  CONSTRAINT [FK_SetDefApplicable_SetDef] FOREIGN KEY([SetDefId])
REFERENCES [ifcProperty].[SetDef] ([SetDefId])
GO
ALTER TABLE [ifcProperty].[SetDefApplicable] CHECK CONSTRAINT [FK_SetDefApplicable_SetDef]
GO
ALTER TABLE [ifcProperty].[TypeComplexProperty]  WITH CHECK ADD  CONSTRAINT [FK_TypeComplexProperty_Def] FOREIGN KEY([DefId])
REFERENCES [ifcProperty].[Def] ([DefId])
GO
ALTER TABLE [ifcProperty].[TypeComplexProperty] CHECK CONSTRAINT [FK_TypeComplexProperty_Def]
GO
ALTER TABLE [ifcProperty].[TypeComplexProperty]  WITH CHECK ADD  CONSTRAINT [FK_TypeComplexProperty_Type] FOREIGN KEY([TypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcProperty].[TypeComplexProperty] CHECK CONSTRAINT [FK_TypeComplexProperty_Type]
GO
ALTER TABLE [ifcProperty].[TypePropertyBoundedValue]  WITH CHECK ADD  CONSTRAINT [FK_TypePropertyBoundedValue_Def] FOREIGN KEY([DefId])
REFERENCES [ifcProperty].[Def] ([DefId])
GO
ALTER TABLE [ifcProperty].[TypePropertyBoundedValue] CHECK CONSTRAINT [FK_TypePropertyBoundedValue_Def]
GO
ALTER TABLE [ifcProperty].[TypePropertyBoundedValue]  WITH CHECK ADD  CONSTRAINT [FK_TypePropertyBoundedValue_Type] FOREIGN KEY([TypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcProperty].[TypePropertyBoundedValue] CHECK CONSTRAINT [FK_TypePropertyBoundedValue_Type]
GO
ALTER TABLE [ifcProperty].[TypePropertyEnumeratedValue]  WITH CHECK ADD  CONSTRAINT [FK_TypePropertyEnumeratedValue_Def] FOREIGN KEY([DefId])
REFERENCES [ifcProperty].[Def] ([DefId])
GO
ALTER TABLE [ifcProperty].[TypePropertyEnumeratedValue] CHECK CONSTRAINT [FK_TypePropertyEnumeratedValue_Def]
GO
ALTER TABLE [ifcProperty].[TypePropertyEnumeratedValue]  WITH CHECK ADD  CONSTRAINT [FK_TypePropertyEnumeratedValue_Type] FOREIGN KEY([TypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcProperty].[TypePropertyEnumeratedValue] CHECK CONSTRAINT [FK_TypePropertyEnumeratedValue_Type]
GO
ALTER TABLE [ifcProperty].[TypePropertyListValue]  WITH CHECK ADD  CONSTRAINT [FK_TypePropertyListValue_Def] FOREIGN KEY([DefId])
REFERENCES [ifcProperty].[Def] ([DefId])
GO
ALTER TABLE [ifcProperty].[TypePropertyListValue] CHECK CONSTRAINT [FK_TypePropertyListValue_Def]
GO
ALTER TABLE [ifcProperty].[TypePropertyListValue]  WITH CHECK ADD  CONSTRAINT [FK_TypePropertyListValue_Type] FOREIGN KEY([TypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcProperty].[TypePropertyListValue] CHECK CONSTRAINT [FK_TypePropertyListValue_Type]
GO
ALTER TABLE [ifcProperty].[TypePropertyReferenceValue]  WITH CHECK ADD  CONSTRAINT [FK_TypePropertyReferenceValue_Def] FOREIGN KEY([DefId])
REFERENCES [ifcProperty].[Def] ([DefId])
GO
ALTER TABLE [ifcProperty].[TypePropertyReferenceValue] CHECK CONSTRAINT [FK_TypePropertyReferenceValue_Def]
GO
ALTER TABLE [ifcProperty].[TypePropertyReferenceValue]  WITH CHECK ADD  CONSTRAINT [FK_TypePropertyReferenceValue_Type] FOREIGN KEY([TypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcProperty].[TypePropertyReferenceValue] CHECK CONSTRAINT [FK_TypePropertyReferenceValue_Type]
GO
ALTER TABLE [ifcProperty].[TypePropertySingleValue]  WITH CHECK ADD  CONSTRAINT [FK_TypePropertySingleValue_Def] FOREIGN KEY([DefId])
REFERENCES [ifcProperty].[Def] ([DefId])
GO
ALTER TABLE [ifcProperty].[TypePropertySingleValue] CHECK CONSTRAINT [FK_TypePropertySingleValue_Def]
GO
ALTER TABLE [ifcProperty].[TypePropertySingleValue]  WITH CHECK ADD  CONSTRAINT [FK_TypePropertySingleValue_Type] FOREIGN KEY([TypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcProperty].[TypePropertySingleValue] CHECK CONSTRAINT [FK_TypePropertySingleValue_Type]
GO
ALTER TABLE [ifcProperty].[TypePropertyTableValue]  WITH CHECK ADD  CONSTRAINT [FK_TypePropertyTableValue_Def] FOREIGN KEY([DefId])
REFERENCES [ifcProperty].[Def] ([DefId])
GO
ALTER TABLE [ifcProperty].[TypePropertyTableValue] CHECK CONSTRAINT [FK_TypePropertyTableValue_Def]
GO
ALTER TABLE [ifcProperty].[TypePropertyTableValue]  WITH CHECK ADD  CONSTRAINT [FK_TypePropertyTableValue_Type] FOREIGN KEY([TypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcProperty].[TypePropertyTableValue] CHECK CONSTRAINT [FK_TypePropertyTableValue_Type]
GO
ALTER TABLE [ifcQuantityTakeOff].[Def]  WITH CHECK ADD  CONSTRAINT [FK_Def_SetDef] FOREIGN KEY([SetDefId])
REFERENCES [ifcQuantityTakeOff].[SetDef] ([SetDefId])
GO
ALTER TABLE [ifcQuantityTakeOff].[Def] CHECK CONSTRAINT [FK_Def_SetDef]
GO
ALTER TABLE [ifcQuantityTakeOff].[Def]  WITH CHECK ADD  CONSTRAINT [FK_Def_Type] FOREIGN KEY([TypeId])
REFERENCES [ifcQuantityTakeOff].[Type] ([TypeId])
GO
ALTER TABLE [ifcQuantityTakeOff].[Def] CHECK CONSTRAINT [FK_Def_Type]
GO
ALTER TABLE [ifcQuantityTakeOff].[DefAlias]  WITH CHECK ADD  CONSTRAINT [FK_DefAlias_Def] FOREIGN KEY([DefId])
REFERENCES [ifcQuantityTakeOff].[Def] ([DefId])
GO
ALTER TABLE [ifcQuantityTakeOff].[DefAlias] CHECK CONSTRAINT [FK_DefAlias_Def]
GO
ALTER TABLE [ifcQuantityTakeOff].[DefAlias]  WITH CHECK ADD  CONSTRAINT [FK_DefAlias_HumanLanguage] FOREIGN KEY([NaturalLanguageId])
REFERENCES [ifcDocumentation].[NaturalLanguage] ([NaturalLanguageId])
GO
ALTER TABLE [ifcQuantityTakeOff].[DefAlias] CHECK CONSTRAINT [FK_DefAlias_HumanLanguage]
GO
ALTER TABLE [ifcQuantityTakeOff].[SetDef]  WITH CHECK ADD  CONSTRAINT [FK_SetDef_Specification] FOREIGN KEY([SpecificationId])
REFERENCES [ifcSpecification].[Specification] ([SpecificationId])
GO
ALTER TABLE [ifcQuantityTakeOff].[SetDef] CHECK CONSTRAINT [FK_SetDef_Specification]
GO
ALTER TABLE [ifcQuantityTakeOff].[SetDef]  WITH CHECK ADD  CONSTRAINT [FK_SetDef_Type] FOREIGN KEY([ApplicableTypeValueTypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcQuantityTakeOff].[SetDef] CHECK CONSTRAINT [FK_SetDef_Type]
GO
ALTER TABLE [ifcQuantityTakeOff].[SetDefApplicableClass]  WITH CHECK ADD  CONSTRAINT [FK_SetDefApplicableClass_SetDef] FOREIGN KEY([SetDefId])
REFERENCES [ifcQuantityTakeOff].[SetDef] ([SetDefId])
GO
ALTER TABLE [ifcQuantityTakeOff].[SetDefApplicableClass] CHECK CONSTRAINT [FK_SetDefApplicableClass_SetDef]
GO
ALTER TABLE [ifcQuantityTakeOff].[SetDefApplicableClass]  WITH CHECK ADD  CONSTRAINT [FK_SetDefApplicableClass_Type] FOREIGN KEY([TypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcQuantityTakeOff].[SetDefApplicableClass] CHECK CONSTRAINT [FK_SetDefApplicableClass_Type]
GO
ALTER TABLE [ifcSchema].[EntityAttribute]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttribute_Type] FOREIGN KEY([EntityTypeId], [EntityTypeGroupId])
REFERENCES [ifcSchema].[Type] ([TypeId], [TypeGroupId])
GO
ALTER TABLE [ifcSchema].[EntityAttribute] CHECK CONSTRAINT [FK_EntityAttribute_Type]
GO
ALTER TABLE [ifcSchema].[EntityAttributeDefaultvalue]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeDefaultvalue_ComputerLanguage] FOREIGN KEY([ComputerLanguageId])
REFERENCES [ifcAPI].[ComputerLanguage] ([ComputerLanguageId])
GO
ALTER TABLE [ifcSchema].[EntityAttributeDefaultvalue] CHECK CONSTRAINT [FK_EntityAttributeDefaultvalue_ComputerLanguage]
GO
ALTER TABLE [ifcSchema].[EntityAttributeDefaultvalue]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeDefaultvalue_Type] FOREIGN KEY([EntityTypeId], [EntityTypeGroupId])
REFERENCES [ifcSchema].[Type] ([TypeId], [TypeGroupId])
GO
ALTER TABLE [ifcSchema].[EntityAttributeDefaultvalue] CHECK CONSTRAINT [FK_EntityAttributeDefaultvalue_Type]
GO
ALTER TABLE [ifcSchema].[EntityInverseAssignment]  WITH CHECK ADD  CONSTRAINT [FK_EntityInverseAssignment_Type] FOREIGN KEY([EntityTypeId], [EntityTypeGroupId])
REFERENCES [ifcSchema].[Type] ([TypeId], [TypeGroupId])
GO
ALTER TABLE [ifcSchema].[EntityInverseAssignment] CHECK CONSTRAINT [FK_EntityInverseAssignment_Type]
GO
ALTER TABLE [ifcSchema].[EntityInverseAssignment]  WITH CHECK ADD  CONSTRAINT [FK_EntityInverseAssignment_TypeOfFor] FOREIGN KEY([OfEntityTypeId], [ForOrdinalPosition])
REFERENCES [ifcSchema].[EntityAttribute] ([EntityTypeId], [OrdinalPosition])
GO
ALTER TABLE [ifcSchema].[EntityInverseAssignment] CHECK CONSTRAINT [FK_EntityInverseAssignment_TypeOfFor]
GO
ALTER TABLE [ifcSchema].[EnumItem]  WITH CHECK ADD  CONSTRAINT [FK_EnumItem_Type] FOREIGN KEY([TypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcSchema].[EnumItem] CHECK CONSTRAINT [FK_EnumItem_Type]
GO
ALTER TABLE [ifcSchema].[EnumItem]  WITH CHECK ADD  CONSTRAINT [FK_EnumItem_Type1] FOREIGN KEY([TypeId], [TypeGroupId])
REFERENCES [ifcSchema].[Type] ([TypeId], [TypeGroupId])
GO
ALTER TABLE [ifcSchema].[EnumItem] CHECK CONSTRAINT [FK_EnumItem_Type1]
GO
ALTER TABLE [ifcSchema].[EnumItemAlias]  WITH CHECK ADD  CONSTRAINT [FK_EnumItemAlias_NaturalLanguage] FOREIGN KEY([NaturalLanguageId])
REFERENCES [ifcDocumentation].[NaturalLanguage] ([NaturalLanguageId])
GO
ALTER TABLE [ifcSchema].[EnumItemAlias] CHECK CONSTRAINT [FK_EnumItemAlias_NaturalLanguage]
GO
ALTER TABLE [ifcSchema].[EnumItemAlias]  WITH CHECK ADD  CONSTRAINT [FK_EnumItemAlias_Type] FOREIGN KEY([TypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcSchema].[EnumItemAlias] CHECK CONSTRAINT [FK_EnumItemAlias_Type]
GO
ALTER TABLE [ifcSchema].[Layer]  WITH CHECK ADD  CONSTRAINT [FK_Layer_LayerGroup] FOREIGN KEY([LayerGroupId])
REFERENCES [ifcSchema].[LayerGroup] ([LayerGroupId])
GO
ALTER TABLE [ifcSchema].[Layer] CHECK CONSTRAINT [FK_Layer_LayerGroup]
GO
ALTER TABLE [ifcSchema].[SelectItem]  WITH CHECK ADD  CONSTRAINT [FK_SelectItem_Type] FOREIGN KEY([TypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcSchema].[SelectItem] CHECK CONSTRAINT [FK_SelectItem_Type]
GO

ALTER TABLE [ifcSchema].[SelectItem]  WITH CHECK ADD  CONSTRAINT [FK_SelectItem_SelectType] FOREIGN KEY([SelectTypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO

ALTER TABLE [ifcSchema].[SelectItem] CHECK CONSTRAINT [FK_SelectItem_SelectType]
GO


ALTER TABLE [ifcSchema].[SelectItem]  WITH CHECK ADD  CONSTRAINT [FK_SelectItem_Type1] FOREIGN KEY([TypeId], [TypeGroupId])
REFERENCES [ifcSchema].[Type] ([TypeId], [TypeGroupId])
GO
ALTER TABLE [ifcSchema].[SelectItem] CHECK CONSTRAINT [FK_SelectItem_Type1]
GO
ALTER TABLE [ifcSchema].[Type]  WITH CHECK ADD  CONSTRAINT [FK_Type_BaseTypeGroup] FOREIGN KEY([BaseTypeGroupId])
REFERENCES [ifcSQL].[BaseTypeGroup] ([BaseTypeGroupId])
GO
ALTER TABLE [ifcSchema].[Type] CHECK CONSTRAINT [FK_Type_BaseTypeGroup]
GO
ALTER TABLE [ifcSchema].[Type]  WITH CHECK ADD  CONSTRAINT [FK_Type_Layer] FOREIGN KEY([LayerId])
REFERENCES [ifcSchema].[Layer] ([LayerId])
GO
ALTER TABLE [ifcSchema].[Type] CHECK CONSTRAINT [FK_Type_Layer]
GO
ALTER TABLE [ifcSchema].[Type]  WITH CHECK ADD  CONSTRAINT [FK_Type_Type] FOREIGN KEY([ParentTypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcSchema].[Type] CHECK CONSTRAINT [FK_Type_Type]
GO
ALTER TABLE [ifcSchema].[Type]  WITH CHECK ADD  CONSTRAINT [FK_Type_TypeGroup] FOREIGN KEY([TypeGroupId])
REFERENCES [ifcSchema].[TypeGroup] ([TypeGroupId])
GO
ALTER TABLE [ifcSchema].[Type] CHECK CONSTRAINT [FK_Type_TypeGroup]
GO
ALTER TABLE [ifcSchemaDerived].[EntityAttributeInstance]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeInstance_AttributeInstanceType] FOREIGN KEY([AttributeInstanceTypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcSchemaDerived].[EntityAttributeInstance] CHECK CONSTRAINT [FK_EntityAttributeInstance_AttributeInstanceType]
GO
ALTER TABLE [ifcSchemaDerived].[EntityAttributeInstance]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeInstance_EntityAttribute] FOREIGN KEY([EntityTypeId], [OrdinalPosition])
REFERENCES [ifcSchema].[EntityAttribute] ([EntityTypeId], [OrdinalPosition])
GO
ALTER TABLE [ifcSchemaDerived].[EntityAttributeInstance] CHECK CONSTRAINT [FK_EntityAttributeInstance_EntityAttribute]
GO
ALTER TABLE [ifcSchemaDerived].[EntityAttributeInstance]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeInstance_EntityAttributeTable] FOREIGN KEY([EntityAttributeTableId])
REFERENCES [ifcSQL].[EntityAttributeTable] ([EntityAttributeTableId])
GO
ALTER TABLE [ifcSchemaDerived].[EntityAttributeInstance] CHECK CONSTRAINT [FK_EntityAttributeInstance_EntityAttributeTable]
GO
ALTER TABLE [ifcSchemaTool].[ChangeLog]  WITH CHECK ADD  CONSTRAINT [FK_ChangeLog_ChangeLogType] FOREIGN KEY([ChangeLogTypeId])
REFERENCES [ifcSchemaTool].[ChangeLogType] ([ChangeLogTypeId])
GO
ALTER TABLE [ifcSchemaTool].[ChangeLog] CHECK CONSTRAINT [FK_ChangeLog_ChangeLogType]
GO
ALTER TABLE [ifcSpecification].[Specification]  WITH CHECK ADD  CONSTRAINT [FK_Specification_SpecificationGroup] FOREIGN KEY([SpecificationGroupId])
REFERENCES [ifcSpecification].[SpecificationGroup] ([SpecificationGroupId])
GO
ALTER TABLE [ifcSpecification].[Specification] CHECK CONSTRAINT [FK_Specification_SpecificationGroup]
GO
ALTER TABLE [ifcSpecification].[TypeSpecificationAssignment]  WITH CHECK ADD  CONSTRAINT [FK_TypeVersion_Type] FOREIGN KEY([TypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO
ALTER TABLE [ifcSpecification].[TypeSpecificationAssignment] CHECK CONSTRAINT [FK_TypeVersion_Type]
GO
ALTER TABLE [ifcSpecification].[TypeSpecificationAssignment]  WITH CHECK ADD  CONSTRAINT [FK_TypeVersion_Version] FOREIGN KEY([SpecificationId])
REFERENCES [ifcSpecification].[Specification] ([SpecificationId])
GO
ALTER TABLE [ifcSpecification].[TypeSpecificationAssignment] CHECK CONSTRAINT [FK_TypeVersion_Version]
GO
ALTER TABLE [ifcSQL].[EntityAttributeTable]  WITH CHECK ADD  CONSTRAINT [FK_EntityAttributeTable_BaseTypeGroup] FOREIGN KEY([BaseTypeGroupId])
REFERENCES [ifcSQL].[BaseTypeGroup] ([BaseTypeGroupId])
GO
ALTER TABLE [ifcSQL].[EntityAttributeTable] CHECK CONSTRAINT [FK_EntityAttributeTable_BaseTypeGroup]
GO
ALTER TABLE [ifcUser].[Login]  WITH CHECK ADD  CONSTRAINT [FK_Login_User] FOREIGN KEY([UserId])
REFERENCES [ifcUser].[User] ([UserId])
GO
ALTER TABLE [ifcUser].[Login] CHECK CONSTRAINT [FK_Login_User]
GO
ALTER TABLE [ifcUser].[UserProjectAssignment]  WITH CHECK ADD  CONSTRAINT [FK_ProjectSUSER_PRJ] FOREIGN KEY([ProjectId])
REFERENCES [ifcProject].[Project] ([ProjectId])
GO
ALTER TABLE [ifcUser].[UserProjectAssignment] CHECK CONSTRAINT [FK_ProjectSUSER_PRJ]
GO
ALTER TABLE [ifcUser].[UserProjectAssignment]  WITH CHECK ADD  CONSTRAINT [FK_UserProject_User] FOREIGN KEY([UserId])
REFERENCES [ifcUser].[User] ([UserId])
GO
ALTER TABLE [ifcUser].[UserProjectAssignment] CHECK CONSTRAINT [FK_UserProject_User]
GO
ALTER TABLE [ifcSchema].[EntityAttribute]  WITH CHECK ADD  CONSTRAINT [ENTITY] CHECK  (([EntityTypeGroupId]=(5)))
GO
ALTER TABLE [ifcSchema].[EntityAttribute] CHECK CONSTRAINT [ENTITY]
GO
ALTER TABLE [ifcSchema].[EntityAttributeDefaultvalue]  WITH CHECK ADD  CONSTRAINT [ENTITY_Defaultvalue] CHECK  (([EntityTypeGroupId]=(5)))
GO
ALTER TABLE [ifcSchema].[EntityAttributeDefaultvalue] CHECK CONSTRAINT [ENTITY_Defaultvalue]
GO
ALTER TABLE [ifcSchema].[EntityInverseAssignment]  WITH CHECK ADD  CONSTRAINT [EntityInverse] CHECK  (([EntityTypeGroupId]=(5)))
GO
ALTER TABLE [ifcSchema].[EntityInverseAssignment] CHECK CONSTRAINT [EntityInverse]
GO
ALTER TABLE [ifcSchema].[EnumItem]  WITH CHECK ADD  CONSTRAINT [ENUM] CHECK  (([TypeGroupId]=(4)))
GO
ALTER TABLE [ifcSchema].[EnumItem] CHECK CONSTRAINT [ENUM]
GO
ALTER TABLE [ifcSchema].[SelectItem]  WITH CHECK ADD  CONSTRAINT [SELECT] CHECK  (([TypeGroupId]=(6)))
GO
ALTER TABLE [ifcSchema].[SelectItem] CHECK CONSTRAINT [SELECT]
GO

