// ifcSQL_for_PrjSel_db_generated.cs, Copyright (c) 2020, Bernhard Simon Bock, Friedrich Eder, MIT License (see https://github.com/IfcSharp/IfcSharpLibrary/tree/master/Licence) 
// ifcSQL: Release 1.3 (after bS submitted in Febr 2020)
 
using db;
 
namespace ifcSQL{//########################################################################
// namespace overview and template for filenames:
namespace ifcProject{}
namespace ifcUser{}
 
// Overview and Template for class-extending:
namespace ifcProject{//=====================================================================
public partial class EntityInstanceIdAssignment_Row : RowBase{}
public partial class LastGlobalEntityInstanceId_Row : RowBase{}
public partial class Project_Row : RowBase{}
public partial class ProjectGroup_Row : RowBase{}
public partial class ProjectGroupType_Row : RowBase{}
}// namespace ifcProject -------------------------------------------------------------------
 
namespace ifcUser{//=====================================================================
public partial class Login_Row : RowBase{}
public partial class User_Row : RowBase{}
public partial class UserProjectAssignment_Row : RowBase{}
}// namespace ifcUser -------------------------------------------------------------------
 
//#############################################################################################
//#############################################################################################
 
namespace ifcProject{//=====================================================================
 
public partial class EntityInstanceIdAssignment_Row : RowBase{
 public EntityInstanceIdAssignment_Row(int ProjectId, long ProjectEntityInstanceId, long GlobalEntityInstanceId){this.ProjectId=ProjectId;this.ProjectEntityInstanceId=ProjectEntityInstanceId;this.GlobalEntityInstanceId=GlobalEntityInstanceId;}
 public EntityInstanceIdAssignment_Row(){}
 [DbField(PrimaryKey=true, SortAscending=true)] [UserType(schema="ifcProject",name="Id")] [References(RefTableSchema="ifcProject",RefTableName="Project",RefTableColName="ProjectId")] public int ProjectId=0;
 [DbField(PrimaryKey=true, SortAscending=true)] [UserType(schema="ifcInstance",name="Id")] public long ProjectEntityInstanceId=0;
 [DbField] [UserType(schema="ifcInstance",name="Id")] [References(RefTableSchema="ifcInstance",RefTableName="Entity",RefTableColName="GlobalEntityInstanceId")] public long GlobalEntityInstanceId=0;
}
 
public partial class LastGlobalEntityInstanceId_Row : RowBase{
 public LastGlobalEntityInstanceId_Row(int ProjectId, long GlobalEntityInstanceId){this.ProjectId=ProjectId;this.GlobalEntityInstanceId=GlobalEntityInstanceId;}
 public LastGlobalEntityInstanceId_Row(){}
 [DbField(PrimaryKey=true, SortAscending=true)] [UserType(schema="ifcProject",name="Id")] public int ProjectId=0;
 [DbField] [UserType(schema="ifcInstance",name="Id")] public long GlobalEntityInstanceId=0;
}
 
public partial class Project_Row : RowBase{
 public Project_Row(int ProjectId, string ProjectName, string ProjectDescription, int ProjectGroupId, int SpecificationId){this.ProjectId=ProjectId;this.ProjectName=ProjectName;this.ProjectDescription=ProjectDescription;this.ProjectGroupId=ProjectGroupId;this.SpecificationId=SpecificationId;}
 public Project_Row(){}
 [DbField(PrimaryKey=true, SortAscending=true)] [UserType(schema="ifcProject",name="Id")] public int ProjectId=0;
 [DbField] [UserType(schema="Text",name="ToString")] public string ProjectName="";
 [DbField] [UserType(schema="Text",name="Description")] public string ProjectDescription="";
 [DbField] [UserType(schema="ifcProject",name="Id")] [References(RefTableSchema="ifcProject",RefTableName="ProjectGroup",RefTableColName="ProjectGroupId")] public int ProjectGroupId=0;
 [DbField] [UserType(schema="ifcSchema",name="GroupId")] [References(RefTableSchema="ifcSpecification",RefTableName="Specification",RefTableColName="SpecificationId")] public int SpecificationId=0;
}
 
public partial class ProjectGroup_Row : RowBase{
 public ProjectGroup_Row(int ProjectGroupId, string ProjectGroupName, string ProjectGroupDescription, int? ParentProjectGroupId, int ProjectGroupTypeId){this.ProjectGroupId=ProjectGroupId;this.ProjectGroupName=ProjectGroupName;this.ProjectGroupDescription=ProjectGroupDescription;this.ParentProjectGroupId=ParentProjectGroupId;this.ProjectGroupTypeId=ProjectGroupTypeId;}
 public ProjectGroup_Row(){}
 [DbField(PrimaryKey=true, SortAscending=true)] [UserType(schema="ifcProject",name="Id")] public int ProjectGroupId=0;
 [DbField] [UserType(schema="Text",name="ToString")] public string ProjectGroupName="";
 [DbField] [UserType(schema="Text",name="Description")] public string ProjectGroupDescription="";
 [DbField] [UserType(schema="ifcProject",name="Id")] [References(RefTableSchema="ifcProject",RefTableName="ProjectGroup",RefTableColName="ProjectGroupId")] public int? ParentProjectGroupId=null;
 [DbField] [UserType(schema="ifcProject",name="Id")] [References(RefTableSchema="ifcProject",RefTableName="ProjectGroupType",RefTableColName="ProjectGroupTypeId")] public int ProjectGroupTypeId=0;
}
 
public partial class ProjectGroupType_Row : RowBase{
 public ProjectGroupType_Row(int ProjectGroupTypeId, string ProjectGroupTypeName, string ProjectGroupTypeDescription){this.ProjectGroupTypeId=ProjectGroupTypeId;this.ProjectGroupTypeName=ProjectGroupTypeName;this.ProjectGroupTypeDescription=ProjectGroupTypeDescription;}
 public ProjectGroupType_Row(){}
 [DbField(PrimaryKey=true, SortAscending=true)] [UserType(schema="ifcProject",name="Id")] public int ProjectGroupTypeId=0;
 [DbField] [UserType(schema="Text",name="ToString")] public string ProjectGroupTypeName="";
 [DbField] [UserType(schema="Text",name="Description")] public string ProjectGroupTypeDescription="";
}
 
}// namespace ifcProject -------------------------------------------------------------------
 
 
namespace ifcUser{//=====================================================================
 
public partial class Login_Row : RowBase{
 public Login_Row(int UserId, string Login){this.UserId=UserId;this.Login=Login;}
 public Login_Row(){}
 [DbField(PrimaryKey=true, SortAscending=true)] public int UserId=0;
 [DbField(PrimaryKey=true, SortAscending=true)] [UserType(schema="Text",name="Login")] public string Login="";
}
 
public partial class User_Row : RowBase{
 public User_Row(int UserId, string FamilyName, string FirstName, string Email){this.UserId=UserId;this.FamilyName=FamilyName;this.FirstName=FirstName;this.Email=Email;}
 public User_Row(){}
 [DbField(PrimaryKey=true, SortAscending=true)] public int UserId=0;
 [DbField] [UserType(schema="Text",name="Name")] public string FamilyName="";
 [DbField] [UserType(schema="Text",name="Name")] public string FirstName="";
 [DbField] [UserType(schema="Text",name="Name")] public string Email="";
}
 
public partial class UserProjectAssignment_Row : RowBase{
 public UserProjectAssignment_Row(int UserId, int UserProjectOrdinalPosition, int ProjectId){this.UserId=UserId;this.UserProjectOrdinalPosition=UserProjectOrdinalPosition;this.ProjectId=ProjectId;}
 public UserProjectAssignment_Row(){}
 [DbField(PrimaryKey=true, SortAscending=true)] [References(RefTableSchema="ifcUser",RefTableName="User",RefTableColName="UserId")] public int UserId=0;
 [DbField(PrimaryKey=true, SortAscending=true)] public int UserProjectOrdinalPosition=0;
 [DbField] [References(RefTableSchema="ifcProject",RefTableName="Project",RefTableColName="ProjectId")] public int ProjectId=0;
}
 
}// namespace ifcUser -------------------------------------------------------------------
 
 
public partial class cp_Schema:SchemaBase{// -------------------------------------------------------------------
public TableBase Project=new RowList<ifcProject.Project_Row>();
}// of cp_Schema // -------------------------------------------------------------------
 
public partial class ifcProject_Schema:SchemaBase{// -------------------------------------------------------------------
public TableBase Project=new RowList<ifcProject.Project_Row>();
public TableBase ProjectGroup=new RowList<ifcProject.ProjectGroup_Row>();
public TableBase ProjectGroupType=new RowList<ifcProject.ProjectGroupType_Row>();
}// of ifcProject_Schema // -------------------------------------------------------------------
 
public partial class ifcUser_Schema:SchemaBase{// -------------------------------------------------------------------
public TableBase UserProjectAssignment=new RowList<ifcUser.UserProjectAssignment_Row>();
}// of ifcUser_Schema // -------------------------------------------------------------------
 
 
 
 /// <summary>DataSource with the name "ifcSQL" for Software "ifcSQL_PrjSel"</summary>
public partial class _ifcSQL_for_PrjSel:TableSet{ //assign Tables to the TableSet
public _ifcSQL_for_PrjSel(string ServerName, string DatabaseName="ifcSQL_Instance"):base(ServerName,DatabaseName){}
public _ifcSQL_for_PrjSel():base(){}
public cp_Schema cp =new cp_Schema();
public ifcProject_Schema ifcProject =new ifcProject_Schema();
public ifcUser_Schema ifcUser =new ifcUser_Schema();
}
}// namespace ifcSQL_PrjSel ########################################################################
