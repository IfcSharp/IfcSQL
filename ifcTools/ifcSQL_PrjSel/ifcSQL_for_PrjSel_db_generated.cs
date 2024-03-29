// Interface to database ifcSQL, Comment: Release 1.5 (published on ifcSharp in april 2021)
// This software use IfcSharp (see https://github.com/IfcSharp)
using System.Collections.Generic;
using System;
using db;
using System.IO;
using System.Xml.Serialization;

namespace ifcSQL{//########################################################################

// namespace overview and template for filenames:
namespace ifcProject{}
namespace ifcUser{}

// enums:

// Overview and Template for class-extending:
namespace ifcProject{//=====================================================================
public partial class Project_Row : RowBase{}
public partial class ProjectGroup_Row : RowBase{}
public partial class ProjectGroupType_Row : RowBase{}
public partial class ProjectType_Row : RowBase{}
}// namespace ifcProject -------------------------------------------------------------------

namespace ifcUser{//=====================================================================
public partial class UserProjectAssignment_Row : RowBase{}
}// namespace ifcUser -------------------------------------------------------------------

//#############################################################################################
//#############################################################################################

namespace ifcProject{//=====================================================================

public partial class Project_Row : RowBase{
[XmlAttributeAttribute][DbField(PrimaryKey=true,PkName="PK_ifcProject")] [UserType(schema="ifcProject",name="Id")] [SqlType(name="int",size=4)] public int ProjectId=0;
public ifcProject.Project_Row FK_ifcProject_Project {get{return ifcProject.Project_Row.Map[ParentProjectId];}}
public ifcProject.ProjectGroup_Row FK_ifcProject_ProjectGroup {get{return ifcProject.ProjectGroup_Row.Map[ProjectGroupId];}}
public ifcProject.ProjectType_Row FK_ifcProject_ProjectType {get{return ifcProject.ProjectType_Row.Map[ProjectTypeId];}}
[XmlAttributeAttribute][DbField] [UserType(schema="Text",name="ToString")] [SqlType(name="nvarchar",size=-1)] public string ProjectName="";
public override string ToString(){return ProjectName;}
[XmlAttributeAttribute][DbField] [UserType(schema="Text",name="Description")] [SqlType(name="nvarchar",size=-1)] public string ProjectDescription="";
[XmlAttributeAttribute][DbField] [UserType(schema="ifcProject",name="Id")] [SqlType(name="int",size=4)] [References(FkName="FK_ifcProject_ProjectGroup",RefPkName="PK_ifcProjectGroup",RefTableSchema="ifcProject",RefTableName="ProjectGroup",RefTableColName="ProjectGroupId")] public int ProjectGroupId=0;
[XmlAttributeAttribute][DbField] [UserType(schema="ifcSchema",name="GroupId")] [SqlType(name="int",size=4)] [References(FkName="FK_Project_Specification",RefPkName="PK_Version",RefTableSchema="ifcSpecification",RefTableName="Specification",RefTableColName="SpecificationId")] public int SpecificationId=0;
[XmlAttributeAttribute][DbField] [UserType(schema="Text",name="Name")] [SqlType(name="nvarchar",size=-1)] public string Author="";
[XmlAttributeAttribute][DbField] [UserType(schema="Text",name="Name")] [SqlType(name="nvarchar",size=-1)] public string Organization="";
[XmlAttributeAttribute][DbField] [UserType(schema="Text",name="Name")] [SqlType(name="nvarchar",size=-1)] public string OriginatingSystem="";
[XmlAttributeAttribute][DbField] [UserType(schema="Text",name="Name")] [SqlType(name="nvarchar",size=-1)] public string Documentation="";
[XmlAttributeAttribute][DbField] [UserType(schema="ifcProject",name="Id")] [SqlType(name="int",size=4)] [References(FkName="FK_ifcProject_Project",RefPkName="PK_ifcProject",RefTableSchema="ifcProject",RefTableName="Project",RefTableColName="ProjectId")] public int ParentProjectId=0;
[XmlAttributeAttribute][DbField] [UserType(schema="ifcProject",name="Id")] [SqlType(name="int",size=4)] [References(FkName="FK_ifcProject_ProjectType",RefPkName="PK_ifcProject_Type",RefTableSchema="ifcProject",RefTableName="ProjectType",RefTableColName="ProjectTypeId")] public int ProjectTypeId=0;
public static Dictionary<int,Project_Row> Map=new Dictionary<int,Project_Row>();
public override void Load(TableBase rows){foreach (Project_Row row in rows) Map.Add(row.ProjectId,row);}
}

public partial class ProjectGroup_Row : RowBase{
[XmlAttributeAttribute][DbField(PrimaryKey=true,PkName="PK_ifcProjectGroup")] [UserType(schema="ifcProject",name="Id")] [SqlType(name="int",size=4)] public int ProjectGroupId=0;
public ifcProject.ProjectGroup_Row FK_ifcProjectGroup_ProjectGroup {get{return ifcProject.ProjectGroup_Row.Map[ParentProjectGroupId];}}
public ifcProject.ProjectGroupType_Row FK_ifcProjectGroup_ProjectGroupType {get{return ifcProject.ProjectGroupType_Row.Map[ProjectGroupTypeId];}}
[XmlAttributeAttribute][DbField] [UserType(schema="Text",name="ToString")] [SqlType(name="nvarchar",size=-1)] public string ProjectGroupName="";
public override string ToString(){return ProjectGroupName;}
[XmlAttributeAttribute][DbField] [UserType(schema="Text",name="Description")] [SqlType(name="nvarchar",size=-1)] public string ProjectGroupDescription="";
[XmlAttributeAttribute][DbField] [UserType(schema="ifcProject",name="Id")] [SqlType(name="int",size=4)] [References(FkName="FK_ifcProjectGroup_ProjectGroup",RefPkName="PK_ifcProjectGroup",RefTableSchema="ifcProject",RefTableName="ProjectGroup",RefTableColName="ProjectGroupId")] public int ParentProjectGroupId=0;
[XmlAttributeAttribute][DbField] [UserType(schema="ifcProject",name="Id")] [SqlType(name="int",size=4)] [References(FkName="FK_ifcProjectGroup_ProjectGroupType",RefPkName="PK_ifcProjectType",RefTableSchema="ifcProject",RefTableName="ProjectGroupType",RefTableColName="ProjectGroupTypeId")] public int ProjectGroupTypeId=0;
public static Dictionary<int,ProjectGroup_Row> Map=new Dictionary<int,ProjectGroup_Row>();
public override void Load(TableBase rows){foreach (ProjectGroup_Row row in rows) Map.Add(row.ProjectGroupId,row);}
}

public partial class ProjectGroupType_Row : RowBase{
[XmlAttributeAttribute][DbField(PrimaryKey=true,PkName="PK_ifcProjectType")] [UserType(schema="ifcProject",name="Id")] [SqlType(name="int",size=4)] public int ProjectGroupTypeId=0;
[XmlAttributeAttribute][DbField] [UserType(schema="Text",name="ToString")] [SqlType(name="nvarchar",size=-1)] public string ProjectGroupTypeName="";
public override string ToString(){return ProjectGroupTypeName;}
[XmlAttributeAttribute][DbField] [UserType(schema="Text",name="Description")] [SqlType(name="nvarchar",size=-1)] public string ProjectGroupTypeDescription="";
public static Dictionary<int,ProjectGroupType_Row> Map=new Dictionary<int,ProjectGroupType_Row>();
public override void Load(TableBase rows){foreach (ProjectGroupType_Row row in rows) Map.Add(row.ProjectGroupTypeId,row);}
}

public partial class ProjectType_Row : RowBase{
[XmlAttributeAttribute][DbField(PrimaryKey=true,PkName="PK_ifcProject_Type")] [UserType(schema="ifcProject",name="Id")] [SqlType(name="int",size=4)] public int ProjectTypeId=0;
[XmlAttributeAttribute][DbField] [UserType(schema="Text",name="ToString")] [SqlType(name="nvarchar",size=-1)] public string ProjectTypeName="";
public override string ToString(){return ProjectTypeName;}
[XmlAttributeAttribute][DbField] [UserType(schema="Text",name="Description")] [SqlType(name="nvarchar",size=-1)] public string ProjectTypeDescription="";
public static Dictionary<int,ProjectType_Row> Map=new Dictionary<int,ProjectType_Row>();
public override void Load(TableBase rows){foreach (ProjectType_Row row in rows) Map.Add(row.ProjectTypeId,row);}
}

}// namespace ifcProject -------------------------------------------------------------------

namespace ifcUser{//=====================================================================

public partial class UserProjectAssignment_Row : RowBase{
[XmlAttributeAttribute][DbField(PrimaryKey=true,PkName="PK_ifcUser_UserProject")] [SqlType(name="Int",size=4)] [References(FkName="FK_UserProject_User",RefPkName="PK_ifcUser_User",RefTableSchema="ifcUser",RefTableName="User",RefTableColName="UserId")] public int UserId=0;
public ifcProject.Project_Row FK_ProjectSUSER_PRJ {get{return ifcProject.Project_Row.Map[ProjectId];}}
[XmlAttributeAttribute][DbField(PrimaryKey=true,PkName="PK_ifcUser_UserProject")] [SqlType(name="Int",size=4)] public int UserProjectOrdinalPosition=0;
[XmlAttributeAttribute][DbField] [SqlType(name="Int",size=4)] [References(FkName="FK_ProjectSUSER_PRJ",RefPkName="PK_ifcProject",RefTableSchema="ifcProject",RefTableName="Project",RefTableColName="ProjectId")] public int ProjectId=0;
}

}// namespace ifcUser -------------------------------------------------------------------

//#############################################################################################
//#############################################################################################

public partial class ifcProject_Schema:SchemaBase{// -------------------------------------------------------------------
public TableBase Project=new RowList<ifcProject.Project_Row>("ORDER BY ProjectName");
public TableBase ProjectGroup=new RowList<ifcProject.ProjectGroup_Row>("ORDER BY ProjectGroupName");
public TableBase ProjectGroupType=new RowList<ifcProject.ProjectGroupType_Row>();
public TableBase ProjectType=new RowList<ifcProject.ProjectType_Row>();
}// of ifcProject_Schema // -------------------------------------------------------------------

public partial class cp_Schema:SchemaBase{// -------------------------------------------------------------------
public TableBase UserProjectAssignment=new RowList<ifcUser.UserProjectAssignment_Row>("ORDER BY UserProjectOrdinalPosition");
}// of cp_Schema // -------------------------------------------------------------------

//#############################################################################################
//#############################################################################################

[XmlInclude(typeof(ifcProject.Project_Row))]
[XmlInclude(typeof(ifcProject.ProjectGroup_Row))]
[XmlInclude(typeof(ifcProject.ProjectGroupType_Row))]
[XmlInclude(typeof(ifcProject.ProjectType_Row))]

[XmlInclude(typeof(ifcUser.UserProjectAssignment_Row))]

//#############################################################################################
//#############################################################################################

/// <summary>interface between database "ifcSQL" and software "ifcSQL_PrjSel"</summary>
public partial class _ifcSQL_for_PrjSel:TableSet{ //assign Tables to the TableSet
public _ifcSQL_for_PrjSel(string ServerName, string DatabaseName="ifcSQL",bool DirectLoad=false):base(ServerName,DatabaseName,DirectLoad){if (DirectLoad) LoadLists();}
public _ifcSQL_for_PrjSel(string ServerName,string UserName,string Password, string DatabaseName="ifcSQL",bool DirectLoad=false):base(ServerName,DatabaseName,UserName,Password,DirectLoad){if (DirectLoad) LoadLists();}
public _ifcSQL_for_PrjSel():base(){}
public ifcProject_Schema ifcProject =new ifcProject_Schema();
public cp_Schema cp =new cp_Schema();
public void LoadLists(){}

public void ToXml(string XmlFileName){using (StreamWriter sw = new StreamWriter(XmlFileName)) new XmlSerializer(typeof(_ifcSQL_for_PrjSel)).Serialize(sw,this);}
public static _ifcSQL_for_PrjSel FromXml(string XmlFileName){_ifcSQL_for_PrjSel tmp=new XmlSerializer(typeof(_ifcSQL_for_PrjSel)).Deserialize(new StreamReader(XmlFileName)) as _ifcSQL_for_PrjSel;tmp.LoadAllMaps();tmp.LoadLists();return tmp;}
}
}// namespace ifcSQL ########################################################################
