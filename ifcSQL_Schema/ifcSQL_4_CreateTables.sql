-- Database-schema of ifcSQL, Copyright (c) 2021, Bernhard Simon Bock, Friedrich Eder, MIT License (see https://github.com/IfcSharp/IfcSharpLibrary/tree/master/Licence)
-- this database runs on Microsoft SQL Server 2019, earlier versions don't support UTF-8
-- this database was testet on Microsoft SQL Server 2019 EXPRESS
USE [ifcSQL]
GO
CREATE TABLE [ifcAPI].[ComputerLanguage](
	[ComputerLanguageId] [int] NOT NULL,
	[ComputerLanguageName] [Text].[ToString] NOT NULL,
 CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED 
(
	[ComputerLanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcAPI].[TypeComputerLanguageAssignment](
	[ComputerLanguageId] [int] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
	[TypeComputerLanguageName] [Text].[ToString] NOT NULL,
 CONSTRAINT [PK_TypeLanguage] PRIMARY KEY CLUSTERED 
(
	[ComputerLanguageId] ASC,
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcDocumentation].[NaturalLanguage](
	[NaturalLanguageId] [int] NOT NULL,
	[NaturalLanguageName] [Text].[ToString] NOT NULL,
	[NaturalLanguageDescription] [Text].[Description] NULL,
 CONSTRAINT [PK_HumanLanguage] PRIMARY KEY CLUSTERED 
(
	[NaturalLanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcDocumentation].[Type](
	[EntityTypeId] [ifcSchema].[Id] NOT NULL,
	[EntityDocumentation] [Text].[Html] NULL,
 CONSTRAINT [PK_EntityDocumentation] PRIMARY KEY CLUSTERED 
(
	[EntityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcInstance].[Entity](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[EntityTypeId] [ifcSchema].[Id] NOT NULL,
 CONSTRAINT [PK_Entity] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO
CREATE TABLE [ifcInstance].[EntityAttributeListElementOfBinary](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[ListDim1Position] [ifcOrder].[Position] NOT NULL,
	[Value] [ifcType].[ifcBINARY] NOT NULL,
 CONSTRAINT [PK_EntityAttributeListElementOfBinary] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC,
	[ListDim1Position] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

CREATE TABLE [ifcInstance].[EntityAttributeListElementOfEntityRef](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[ListDim1Position] [ifcOrder].[Position] NOT NULL,
	[Value] [ifcInstance].[Id] NOT NULL,
 CONSTRAINT [PK_EntityAttributeListElementOfEntityRef] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC,
	[ListDim1Position] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcInstance].[EntityAttributeListElementOfFloat](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[ListDim1Position] [ifcOrder].[Position] NOT NULL,
	[Value] [ifcType].[ifcREAL] NOT NULL,
 CONSTRAINT [PK_EntityAttributeListElementOfFloat] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC,
	[ListDim1Position] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcInstance].[EntityAttributeListElementOfInteger](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[ListDim1Position] [ifcOrder].[Position] NOT NULL,
	[Value] [ifcType].[ifcINTEGER] NOT NULL,
 CONSTRAINT [PK_EntityAttributeListElementOfInteger] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC,
	[ListDim1Position] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcInstance].[EntityAttributeListElementOfList](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[ListDim1Position] [ifcOrder].[Position] NOT NULL,
 CONSTRAINT [PK_EntityAttributeListElementOfList] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC,
	[ListDim1Position] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcInstance].[EntityAttributeListElementOfListElementOfEntityRef](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[ListDim1Position] [ifcOrder].[Position] NOT NULL,
	[ListDim2Position] [ifcOrder].[Position] NOT NULL,
	[Value] [ifcInstance].[Id] NOT NULL,
 CONSTRAINT [PK_EntityAttributeListElementOfListElementOfEntityRef] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC,
	[ListDim1Position] ASC,
	[ListDim2Position] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcInstance].[EntityAttributeListElementOfListElementOfFloat](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[ListDim1Position] [ifcOrder].[Position] NOT NULL,
	[ListDim2Position] [ifcOrder].[Position] NOT NULL,
	[Value] [ifcType].[ifcREAL] NOT NULL,
 CONSTRAINT [PK_EntityAttributeListElementOfListElementOfFloat] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC,
	[ListDim1Position] ASC,
	[ListDim2Position] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcInstance].[EntityAttributeListElementOfListElementOfInteger](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[ListDim1Position] [ifcOrder].[Position] NOT NULL,
	[ListDim2Position] [ifcOrder].[Position] NOT NULL,
	[Value] [ifcType].[ifcINTEGER] NOT NULL,
 CONSTRAINT [PK_EntityAttributeListElementOfListElementOfInteger] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC,
	[ListDim1Position] ASC,
	[ListDim2Position] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcInstance].[EntityAttributeListElementOfString](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[ListDim1Position] [ifcOrder].[Position] NOT NULL,
	[Value] [ifcType].[ifcSTRING] NOT NULL,
 CONSTRAINT [PK_EntityAttributeListElementOfString] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC,
	[ListDim1Position] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO
CREATE TABLE [ifcInstance].[EntityAttributeOfBinary](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
	[Value] [ifcType].[ifcBINARY] NOT NULL,
 CONSTRAINT [PK_EntityAttributeOfBinary] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

CREATE TABLE [ifcInstance].[EntityAttributeOfBoolean](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
	[Value] [ifcType].[ifcBOOLEAN] NOT NULL,
 CONSTRAINT [PK_EntityAttributeOfBoolean] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcInstance].[EntityAttributeOfEntityRef](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
	[Value] [ifcInstance].[Id] NOT NULL,
 CONSTRAINT [PK_EntityAttributeOfEntityRef] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcInstance].[EntityAttributeOfEnum](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
	[Value] [ifcEnum].[Id] NOT NULL,
 CONSTRAINT [PK_EntityAttributeOfEnum] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcInstance].[EntityAttributeOfFloat](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
	[Value] [ifcType].[ifcREAL] NOT NULL,
 CONSTRAINT [PK_EntityAttributeOfFloat] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcInstance].[EntityAttributeOfInteger](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
	[Value] [ifcType].[ifcINTEGER] NOT NULL,
 CONSTRAINT [PK_EntityAttributeOfInteger] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcInstance].[EntityAttributeOfList](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
 CONSTRAINT [PK_EntityAttributeOfList] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcInstance].[EntityAttributeOfString](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
	[Value] [ifcType].[ifcSTRING] NOT NULL,
 CONSTRAINT [PK_EntityAttributeOfString] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcInstance].[EntityAttributeOfVector](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
	[X] [ifcType].[ifcREAL] NOT NULL,
	[Y] [ifcType].[ifcREAL] NOT NULL,
	[Z] [ifcType].[ifcREAL] NULL,
 CONSTRAINT [PK_EntityAttributeOfVector] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC,
	[OrdinalPosition] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcInstance].[EntityVariableName](
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[VarableName] [ifcType].[ifcSTRING] NOT NULL,
 CONSTRAINT [PK_EntityVariableName] PRIMARY KEY CLUSTERED 
(
	[GlobalEntityInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcProject].[EntityInstanceIdAssignment](
	[ProjectId] [ifcProject].[Id] NOT NULL,
	[ProjectEntityInstanceId] [ifcInstance].[Id] NOT NULL,
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
 CONSTRAINT [PK_ifcEntityInstanceIdAssignment] PRIMARY KEY CLUSTERED 
(
	[ProjectId] ASC,
	[ProjectEntityInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcProject].[LastGlobalEntityInstanceId](
	[ProjectId] [ifcProject].[Id] NOT NULL,
	[GlobalEntityInstanceId] [ifcInstance].[Id] NOT NULL,
 CONSTRAINT [PK_ifcLastGlobalEntityInstanceId] PRIMARY KEY CLUSTERED 
(
	[ProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcProject].[Project](
	[ProjectId] [ifcProject].[Id] NOT NULL,
	[ProjectName] [Text].[ToString] NULL,
	[ProjectDescription] [Text].[Description] NULL,
	[ProjectGroupId] [ifcProject].[Id] NOT NULL,
	[SpecificationId] [ifcSchema].[GroupId] NOT NULL,
 CONSTRAINT [PK_ifcProject] PRIMARY KEY CLUSTERED 
(
	[ProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcProject].[ProjectGroup](
	[ProjectGroupId] [ifcProject].[Id] NOT NULL,
	[ProjectGroupName] [Text].[ToString] NULL,
	[ProjectGroupDescription] [Text].[Description] NULL,
	[ParentProjectGroupId] [ifcProject].[Id] NULL,
	[ProjectGroupTypeId] [ifcProject].[Id] NOT NULL,
 CONSTRAINT [PK_ifcProjectGroup] PRIMARY KEY CLUSTERED 
(
	[ProjectGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcProject].[ProjectGroupType](
	[ProjectGroupTypeId] [ifcProject].[Id] NOT NULL,
	[ProjectGroupTypeName] [Text].[ToString] NULL,
	[ProjectGroupTypeDescription] [Text].[Description] NULL,
 CONSTRAINT [PK_ifcProjectType] PRIMARY KEY CLUSTERED 
(
	[ProjectGroupTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcProperty].[Def](
	[DefId] [ifcProperty].[Id] NOT NULL,
	[ifdguid] [ifcType].[IfdGuid] NOT NULL,
	[DefName] [Text].[ToString] NOT NULL,
	[DefDefinition] [Text].[Description] NULL,
	[SetDefId] [ifcProperty].[Id] NOT NULL,
 CONSTRAINT [PK_ifcProperty_Def] PRIMARY KEY CLUSTERED 
(
	[DefId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcProperty].[DefAlias](
	[DefId] [ifcProperty].[Id] NOT NULL,
	[HumanLanguageId] [int] NOT NULL,
	[DefAliasName] [Text].[ToString] NOT NULL,
	[DefAliasDefinition] [Text].[Description] NULL,
 CONSTRAINT [PK_ifcProperty_DefAlias] PRIMARY KEY CLUSTERED 
(
	[DefId] ASC,
	[HumanLanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcProperty].[SetDef](
	[SetDefId] [ifcProperty].[Id] NOT NULL,
	[SpecificationId] [ifcSchema].[GroupId] NOT NULL,
	[SetDefName] [Text].[ToString] NOT NULL,
	[SetDefDefinition] [Text].[Description] NULL,
 CONSTRAINT [PK_ifcProperty_SetDef] PRIMARY KEY CLUSTERED 
(
	[SetDefId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcProperty].[SetDefAlias](
	[SetDefId] [ifcProperty].[Id] NOT NULL,
	[HumanLanguageId] [int] NOT NULL,
	[SetDefAlias] [Text].[ToString] NULL,
 CONSTRAINT [PK_ifcProperty_SetDefAlias] PRIMARY KEY CLUSTERED 
(
	[SetDefId] ASC,
	[HumanLanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcProperty].[SetDefApplicable](
	[SetDefId] [ifcProperty].[Id] NOT NULL,
	[EntityTypeId] [ifcSchema].[Id] NOT NULL,
	[EnumTypeId] [ifcSchema].[Id] NOT NULL,
	[EnumItemId] [ifcSchema].[Id] NOT NULL,
 CONSTRAINT [PK_ifcProperty_SetDefApplicable] PRIMARY KEY CLUSTERED 
(
	[SetDefId] ASC,
	[EntityTypeId] ASC,
	[EnumTypeId] ASC,
	[EnumItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcProperty].[TypeComplexProperty](
	[DefId] [ifcProperty].[Id] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
 CONSTRAINT [PK_ifcProperty_TypeProperty7] PRIMARY KEY CLUSTERED 
(
	[DefId] ASC,
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcProperty].[TypePropertyBoundedValue](
	[DefId] [ifcProperty].[Id] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
 CONSTRAINT [PK_ifcProperty_TypeProperty3] PRIMARY KEY CLUSTERED 
(
	[DefId] ASC,
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcProperty].[TypePropertyEnumeratedValue](
	[DefId] [ifcProperty].[Id] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
 CONSTRAINT [PK_ifcProperty_TypeProperty2] PRIMARY KEY CLUSTERED 
(
	[DefId] ASC,
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcProperty].[TypePropertyListValue](
	[DefId] [ifcProperty].[Id] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
 CONSTRAINT [PK_ifcProperty_TypeProperty6] PRIMARY KEY CLUSTERED 
(
	[DefId] ASC,
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcProperty].[TypePropertyReferenceValue](
	[DefId] [ifcProperty].[Id] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
 CONSTRAINT [PK_ifcProperty_TypeProperty5] PRIMARY KEY CLUSTERED 
(
	[DefId] ASC,
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcProperty].[TypePropertySingleValue](
	[DefId] [ifcProperty].[Id] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
 CONSTRAINT [PK_ifcProperty_TypeProperty1] PRIMARY KEY CLUSTERED 
(
	[DefId] ASC,
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcProperty].[TypePropertyTableValue](
	[DefId] [ifcProperty].[Id] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
 CONSTRAINT [PK_ifcProperty_TypeProperty4] PRIMARY KEY CLUSTERED 
(
	[DefId] ASC,
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcQuantityTakeOff].[Def](
	[DefId] [ifcProperty].[Id] NOT NULL,
	[DefName] [Text].[ToString] NOT NULL,
	[DefDefinition] [Text].[Description] NULL,
	[SetDefId] [ifcProperty].[Id] NOT NULL,
	[TypeId] [ifcProperty].[Id] NULL,
 CONSTRAINT [PK_ifcQuantityTakeOff_Def] PRIMARY KEY CLUSTERED 
(
	[DefId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcQuantityTakeOff].[DefAlias](
	[DefId] [ifcProperty].[Id] NOT NULL,
	[NaturalLanguageId] [int] NOT NULL,
	[DefAliasName] [Text].[ToString] NOT NULL,
	[DefAliasDefinition] [Text].[Description] NULL,
 CONSTRAINT [PK_ifcQuantityTakeOff_DefAlias] PRIMARY KEY CLUSTERED 
(
	[DefId] ASC,
	[NaturalLanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcQuantityTakeOff].[SetDef](
	[SetDefId] [ifcProperty].[Id] NOT NULL,
	[SpecificationId] [ifcSchema].[GroupId] NOT NULL,
	[SetDefName] [Text].[ToString] NOT NULL,
	[SetDefDefinition] [Text].[Description] NULL,
	[ApplicableTypeValueTypeId] [ifcSchema].[Id] NOT NULL,
 CONSTRAINT [PK_ifcQuantityTakeOff_SetDef] PRIMARY KEY CLUSTERED 
(
	[SetDefId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcQuantityTakeOff].[SetDefApplicableClass](
	[SetDefId] [ifcProperty].[Id] NOT NULL,
	[TypeId] [ifcSchema].[Id] NOT NULL,
 CONSTRAINT [PK_ifcQuantityTakeOff_SetDefApplicableClass] PRIMARY KEY CLUSTERED 
(
	[SetDefId] ASC,
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcQuantityTakeOff].[Type](
	[TypeId] [ifcProperty].[Id] NOT NULL,
	[TypeName] [Text].[ToString] NOT NULL,
 CONSTRAINT [PK_ifcQuantityTakeOff_Type] PRIMARY KEY CLUSTERED 
(
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcSchema].[EntityAttribute](
	[EntityTypeId] [ifcSchema].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[Optional] [Bool].[YesNo] NOT NULL,
	[Derived] [Bool].[YesNo] NOT NULL,
	[AttributeName] [Text].[ToString] NOT NULL,
	[AttributeTypeId] [ifcSchema].[Id] NOT NULL,
	[EntityTypeGroupId] [ifcSchema].[GroupId] NOT NULL,
	[AttributeIsFromBaseClass] [Bool].[YesNo] NOT NULL,
 CONSTRAINT [PK_EntityAttribute] PRIMARY KEY CLUSTERED 
(
	[EntityTypeId] ASC,
	[OrdinalPosition] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcSchema].[EntityAttributeDefaultvalue](
	[EntityTypeId] [ifcSchema].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[ComputerLanguageId] [int] NOT NULL,
	[Defaultvalue] [Text].[Expression] NOT NULL,
	[EntityTypeGroupId] [ifcSchema].[GroupId] NOT NULL,
 CONSTRAINT [PK_EntityAttributeDefaultvalue] PRIMARY KEY CLUSTERED 
(
	[EntityTypeId] ASC,
	[OrdinalPosition] ASC,
	[ComputerLanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcSchema].[EntityInverseAssignment](
	[EntityTypeId] [ifcSchema].[Id] NOT NULL,
	[AttributeName] [Text].[ToString] NOT NULL,
	[OfEntityTypeId] [ifcSchema].[Id] NOT NULL,
	[ForOrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[Optional] [Bool].[YesNo] NOT NULL,
	[IsList] [Bool].[YesNo] NOT NULL,
	[EntityTypeGroupId] [ifcSchema].[GroupId] NOT NULL,
 CONSTRAINT [PK_EntityInverseAssignment] PRIMARY KEY CLUSTERED 
(
	[EntityTypeId] ASC,
	[OfEntityTypeId] ASC,
	[ForOrdinalPosition] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcSchema].[EnumItem](
	[TypeId] [ifcSchema].[Id] NOT NULL,
	[EnumItemId] [ifcEnum].[Id] NOT NULL,
	[EnumItemName] [Text].[ToString] NOT NULL,
	[TypeGroupId] [ifcSchema].[GroupId] NOT NULL,
	[Definition] [Text].[Description] NULL,
 CONSTRAINT [PK_EnumItem] PRIMARY KEY CLUSTERED 
(
	[TypeId] ASC,
	[EnumItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcSchema].[EnumItemAlias](
	[TypeId] [ifcSchema].[Id] NOT NULL,
	[EnumItemId] [ifcEnum].[Id] NOT NULL,
	[NaturalLanguageId] [int] NOT NULL,
	[EnumItemAliasName] [Text].[ToString] NOT NULL,
	[EnumItemAliasDefinition] [Text].[Description] NULL,
 CONSTRAINT [PK_EnumItemAlias] PRIMARY KEY CLUSTERED 
(
	[TypeId] ASC,
	[EnumItemId] ASC,
	[NaturalLanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcSchema].[Layer](
	[LayerId] [ifcLayer].[Id] NOT NULL,
	[LayerName] [Text].[ToString] NOT NULL,
	[LayerGroupId] [ifcLayer].[Id] NOT NULL,
 CONSTRAINT [PK_Layer] PRIMARY KEY CLUSTERED 
(
	[LayerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcSchema].[LayerGroup](
	[LayerGroupId] [ifcLayer].[Id] NOT NULL,
	[LayerGroupName] [Text].[ToString] NOT NULL,
 CONSTRAINT [PK_LayerGroup] PRIMARY KEY CLUSTERED 
(
	[LayerGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcSchema].[SelectItem](
	[TypeId] [ifcSchema].[Id] NOT NULL,
	[SelectTypeId] [ifcSchema].[Id] NOT NULL,
	[TypeGroupId] [ifcSchema].[GroupId] NOT NULL,
	[NestLevel] [smallint] NOT NULL,
	[Abstract] [Bool].[YesNo] NOT NULL,
 CONSTRAINT [PK_SelectItem] PRIMARY KEY CLUSTERED 
(
	[TypeId] ASC,
	[SelectTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcSchema].[Type](
	[TypeId] [ifcSchema].[Id] NOT NULL,
	[TypeGroupId] [ifcSchema].[GroupId] NOT NULL,
	[TypeName] [ifcSchema].[IndexableName] NOT NULL,
	[ParentTypeId] [ifcSchema].[Id] NULL,
	[LayerId] [ifcLayer].[Id] NULL,
	[EntityAttributeTableId] [ifcSchema].[Id] NOT NULL,
	[BaseTypeId] [ifcSchema].[Id] NULL,
	[BaseTypeName] [ifcSchema].[IndexableName] NULL,
	[MinOccurs] [ifcOrder].[Position] NOT NULL,
	[MaxOccurs] [ifcOrder].[Position] NULL,
	[ExpressName] [ifcSchema].[IndexableName] NULL,
	[Abstract] [Bool].[YesNo] NOT NULL,
	[BaseTypeGroupId] [ifcSchema].[Id] NOT NULL,
 CONSTRAINT [PK_Type] PRIMARY KEY CLUSTERED 
(
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcSchema].[TypeGroup](
	[TypeGroupId] [ifcSchema].[GroupId] NOT NULL,
	[TypeGroupName] [Text].[ToString] NOT NULL,
 CONSTRAINT [PK_TypeGroup] PRIMARY KEY CLUSTERED 
(
	[TypeGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcSchemaDerived].[EntityAttributeInstance](
	[EntityTypeId] [ifcSchema].[Id] NOT NULL,
	[OrdinalPosition] [ifcOrder].[Position] NOT NULL,
	[AttributeInstanceTypeId] [ifcSchema].[Id] NOT NULL,
	[EntityAttributeTableId] [ifcSchema].[Id] NOT NULL,
 CONSTRAINT [PK_EntityAttributeInstance] PRIMARY KEY CLUSTERED 
(
	[EntityTypeId] ASC,
	[OrdinalPosition] ASC,
	[AttributeInstanceTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcSchemaTool].[ChangeLog](
	[Date] [datetime] NOT NULL,
	[Login] [Text].[Login] NOT NULL,
	[CommandText] [nvarchar](max) NULL,
	[ChangeLogTypeId] [ifcSchema].[Id] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcSchemaTool].[ChangeLogType](
	[ChangeLogTypeId] [ifcSchema].[Id] NOT NULL,
	[ChangeLogTypeName] [Text].[ToString] NOT NULL,
 CONSTRAINT [PK_ChangeLogType] PRIMARY KEY CLUSTERED 
(
	[ChangeLogTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcSpecification].[Specification](
	[SpecificationId] [ifcSchema].[GroupId] NOT NULL,
	[SpecificationName] [Text].[ToString] NOT NULL,
	[SpecificationGroupId] [ifcSchema].[GroupId] NOT NULL,
	[SpecificationBaseUrl] [IO].[URL] NULL,
	[SchemaName] [ifcSchema].[IndexableName] NOT NULL,
	[EpressFileName] [ifcSchema].[IndexableName] NULL,
 CONSTRAINT [PK_Version] PRIMARY KEY CLUSTERED 
(
	[SpecificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcSpecification].[SpecificationGroup](
	[SpecificationGroupId] [ifcSchema].[GroupId] NOT NULL,
	[SpecificationGroupName] [Text].[ToString] NOT NULL,
 CONSTRAINT [PK_SpecificationGroup] PRIMARY KEY CLUSTERED 
(
	[SpecificationGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcSpecification].[TypeSpecificationAssignment](
	[TypeId] [ifcSchema].[Id] NOT NULL,
	[SpecificationId] [ifcSchema].[GroupId] NOT NULL,
 CONSTRAINT [PK_TypeVersion] PRIMARY KEY CLUSTERED 
(
	[TypeId] ASC,
	[SpecificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcSQL].[BaseTypeGroup](
	[BaseTypeGroupId] [ifcSchema].[Id] NOT NULL,
	[BaseTypeGroupName] [ifcSchema].[IndexableName] NOT NULL,
 CONSTRAINT [PK_BaseTypeGroup] PRIMARY KEY CLUSTERED 
(
	[BaseTypeGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcSQL].[EntityAttributeTable](
	[EntityAttributeTableId] [ifcSchema].[Id] NOT NULL,
	[EntityAttributeTableName] [ifcSchema].[IndexableName] NOT NULL,
	[BaseTypeGroupId] [ifcSchema].[Id] NOT NULL,
	[NestLevel] [int] NOT NULL,
 CONSTRAINT [PK_EntityAttributeTable] PRIMARY KEY CLUSTERED 
(
	[EntityAttributeTableId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcSQL].[Issues](
	[IssuesKey] [Text].[Key] NOT NULL,
	[IssuesDescription] [Text].[Description] NOT NULL,
 CONSTRAINT [PK_Issues] PRIMARY KEY CLUSTERED 
(
	[IssuesKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcSQL].[Licence](
	[LicenceText] [Text].[ToString] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcSQL].[Release](
	[ReleaseKey] [Text].[Key] NOT NULL,
	[ReleaseDescription] [Text].[Description] NOT NULL,
 CONSTRAINT [PK_Release] PRIMARY KEY CLUSTERED 
(
	[ReleaseKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcUnit].[SIPrefixEnumExponentAssigment](
	[EnumItemId] [ifcEnum].[Id] NOT NULL,
	[ExponentOfTen] [smallint] NOT NULL,
 CONSTRAINT [PK_SIPrefixValues] PRIMARY KEY CLUSTERED 
(
	[EnumItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcUnit].[SIUnitNameEnumDimensionsExponentAssignment](
	[EnumItemId] [ifcEnum].[Id] NOT NULL,
	[LengthExponent] [ifcType].[ifcINTEGER] NOT NULL,
	[MassExponent] [ifcType].[ifcINTEGER] NOT NULL,
	[TimeExponent] [ifcType].[ifcINTEGER] NOT NULL,
	[ElectricCurrentExponent] [ifcType].[ifcINTEGER] NOT NULL,
	[ThermodynamicTemperatureExponent] [ifcType].[ifcINTEGER] NOT NULL,
	[AmountOfSubstanceExponent] [ifcType].[ifcINTEGER] NOT NULL,
	[LuminousIntensityExponent] [ifcType].[ifcINTEGER] NOT NULL,
 CONSTRAINT [PK_DimensionsForUnit] PRIMARY KEY CLUSTERED 
(
	[EnumItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcUnit].[SIUnitNameUnitOfMeasureEnumAssignment](
	[SIUnitNameEnumItemId] [ifcEnum].[Id] NOT NULL,
	[UnitEnumItemId] [ifcEnum].[Id] NOT NULL,
 CONSTRAINT [PK_SIUnit] PRIMARY KEY CLUSTERED 
(
	[SIUnitNameEnumItemId] ASC,
	[UnitEnumItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcUnit].[Unit](
	[UnitId] [ifcSchema].[Id] NOT NULL,
	[Measure] [Text].[Description] NULL,
	[UnitType] [Text].[Description] NULL,
	[UnitName] [Text].[Description] NULL,
	[Symbol] [Text].[Description] NULL,
	[Derivation] [Text].[Description] NULL,
	[EnumTypeName] [ifcSchema].[IndexableName] NULL,
	[EnumItemId] [ifcEnum].[Id] NULL,
	[ValueTypeName] [ifcSchema].[IndexableName] NULL,
 CONSTRAINT [PK_Unit2] PRIMARY KEY CLUSTERED 
(
	[UnitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcUser].[Login](
	[UserId] [int] NOT NULL,
	[Login] [Text].[Login] NOT NULL,
 CONSTRAINT [PK_UserLogin] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[Login] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ifcUser].[User](
	[UserId] [int] NOT NULL,
	[FamilyName] [Text].[Name] NOT NULL,
	[FirstName] [Text].[Name] NOT NULL,
	[Email] [Text].[Name] NOT NULL,
 CONSTRAINT [PK_ifcUser_User] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [ifcUser].[UserProjectAssignment](
	[UserId] [int] NOT NULL,
	[UserProjectOrdinalPosition] [int] NOT NULL,
	[ProjectId] [int] NOT NULL,
 CONSTRAINT [PK_ifcUser_UserProject] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[UserProjectOrdinalPosition] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
