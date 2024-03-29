// ifcSQL_PrjSel.cs, Copyright (c) 2021, Bernhard Simon Bock, Friedrich Eder, MIT License (see https://github.com/IfcSharp/IfcSharpLibrary/tree/master/Licence) 
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;

using db;

// extension to ifcSQL_for_PrjSel_db_generated.cs:
namespace ifcSQL{ 
namespace ifcProject{//============================================================================

public partial class ProjectGroup_Row : RowBase{//.................................................
public ProjectGroupType_Row ProjectGroupType=null;
public List<Project_Row> ProjectList=new List<Project_Row>(); 
public List<ProjectGroup_Row> ChildList=new List<ProjectGroup_Row>();
public void AddNodes(TreeNode tn){TreeNode tnp=tn.Nodes.Add(this.ProjectGroupName+" ["+this.FK_ifcProjectGroup_ProjectGroupType.ProjectGroupTypeName+"]");
                                           tnp.Tag=this;   
                                           tnp.ForeColor=Color.DarkRed;
                                           tnp.ContextMenu=ifcSQL_PrjSel.XTreeView.PrjGroupContextMenu;
                                  foreach (ifcSQL.ifcProject.Project_Row p in this.ProjectList) p.AddNodes(tnp);
                                  foreach(ProjectGroup_Row pg in this.ChildList) pg.AddNodes(tnp);  
                                 }  
}//................................................................................................

public partial class Project_Row : RowBase{//......................................................
public ProjectGroup_Row ProjectGroup=null;
public void AddNodes(TreeNode tn){TreeNode tnp=tn.Nodes.Add(this.ProjectId+" - "+this.ProjectName+": "+this.ProjectDescription);
                                           tnp.Tag=this;
                                           tnp.ContextMenu=ifcSQL_PrjSel.XTreeView.PrjContextMenu;
                                  if (this.ProjectId==CurrentProjectId) tnp.BackColor=Color.Yellow;   
                                  if (this.ParentProjectId>0) tnp.ForeColor=Color.Red;   
                                  if (this.ProjectTypeId==1) tnp.ForeColor=Color.Blue;   
                                  if (this.ProjectTypeId==2) tnp.ForeColor=Color.Green;   
                                  if (this.ProjectTypeId==3) tnp.ForeColor=Color.DarkGray;   
                                  foreach (ifcSQL.ifcProject.Project_Row p in this.ChildProjects) p.AddNodes(tnp);
                                 }  
public static int CurrentProjectId=0;
public List<Project_Row> ChildProjects=new List<Project_Row>();
}//................................................................................................

}// namespace ifcProject --------------------------------------------------------------------------
}// namespace ifcSQL ------------------------------------------------------------------------------
// of extension to ifcSQL_for_PrjSel_db_generated.cs


// Windows-App:
class ifcSQL_PrjSel{//======================================================================================================
public static ifcSQL._ifcSQL_for_PrjSel ifcSQLin=null;
public class XTreeView : TreeView{//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
public static ContextMenu PrjContextMenu=new ContextMenu();
public static ContextMenu PrjGroupContextMenu=new ContextMenu();
public       XTreeView(){PrjContextMenu.MenuItems.Add(new MenuItem("Select project as active project (or doubleclick)",delegate{SelPrj(this.SelectedNode);}));
                         PrjGroupContextMenu.MenuItems.Add(new MenuItem("Move current project to this projectgroup",delegate{if (this.SelectedNode.Tag!=null) AssignPrj(this.SelectedNode); else MessageBox.Show("Please first click on the Group-Tree-Element");  }));     // ToDo: CreateProject
                        }
protected override void OnDoubleClick(EventArgs e) {base.OnDoubleClick(e);SelPrj(this.SelectedNode);}


public void SelPrj(TreeNode tn){if (tn.Tag is ifcSQL.ifcProject.Project_Row)
                                   {ifcSQL.ifcProject.Project_Row pr=(ifcSQL.ifcProject.Project_Row)tn.Tag;
                                    SelPrj(pr.ProjectId);
                                   }
                               } 

public static void SelPrj(int ProjectId){ifcSQLin.ExecuteNonQuery(sql:"[app].[SelectProject] "+ProjectId,DoOpenAndClose:true);
                                         Application.Exit();
                                        } 

public void AssignPrj(TreeNode tn){if (tn.Tag is ifcSQL.ifcProject.ProjectGroup_Row)
                                     {ifcSQL.ifcProject.ProjectGroup_Row gr=(ifcSQL.ifcProject.ProjectGroup_Row)tn.Tag;
                                      ifcSQLin.ExecuteNonQuery(sql:"[app].[MoveProject] "+ifcSQL.ifcProject.Project_Row.CurrentProjectId+","+gr.ProjectGroupId,DoOpenAndClose:true);
                                      Application.Restart();
                                     }
                               } 

}//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

public class ProjectForm : System.Windows.Forms.Form//######################################################################
{
public static XTreeView treeView=new XTreeView(); 
public  ProjectForm (string txt){treeView.Parent = this;
                                 treeView.Dock = DockStyle.Fill;
                                 treeView.ExpandAll();
                                 this.StartPosition = FormStartPosition.Manual;
                                 this.Bounds = new Rectangle(new Point(50,50), new Size(600, 800));
                                 this.Text = txt;
                                }
    }//of ProjectForm ##########################################################################################################

[STAThread]
static void Main(string[] args){//##########################################################################################

string SqlServerName=Environment.GetEnvironmentVariable("SqlServer");
string  DatabaseName=Environment.GetEnvironmentVariable("ifcSQL");

if (args.Length>0) SqlServerName=args[0]; 
if (args.Length>1)  DatabaseName=args[1];

if (SqlServerName==null || SqlServerName=="") {Console.WriteLine("No name for SqlServerName found. Set EnvironmentVariables \"SqlServerName\" and  \"ifcSQL\" or CommandLineArguments  \"ifcSQL_PrjSel.exe SqlServerName DatabaseName\"");Console.ReadLine();Application.Exit();}
if ( DatabaseName==null ||  DatabaseName=="") DatabaseName="ifcSQL";

//try{
ifcSQLin=new ifcSQL._ifcSQL_for_PrjSel(ServerName:SqlServerName,DatabaseName:DatabaseName,DirectLoad:true);

foreach (ifcSQL.ifcProject.ProjectGroup_Row pg in ifcSQLin.ifcProject.ProjectGroup) if (pg.ParentProjectGroupId!=0) ifcSQL.ifcProject.ProjectGroup_Row.Map[pg.ParentProjectGroupId].ChildList.Add(pg);

foreach (ifcSQL.ifcProject.Project_Row p in ifcSQLin.ifcProject.Project) 
        if (p.ParentProjectId==0) {p.ProjectGroup=ifcSQL.ifcProject.ProjectGroup_Row.Map[p.ProjectGroupId];p.ProjectGroup.ProjectList.Add(p);}
        else ifcSQL.ifcProject.Project_Row.Map[p.ParentProjectId].ChildProjects.Add(p);

foreach (ifcSQL.ifcUser.UserProjectAssignment_Row p in ifcSQL_PrjSel.ifcSQLin.cp.UserProjectAssignment)
        if  (p.UserProjectOrdinalPosition==0) ifcSQL.ifcProject.Project_Row.CurrentProjectId=p.ProjectId;
        else XTreeView.PrjContextMenu.MenuItems.Add(new MenuItem("Select Project "+p.UserProjectOrdinalPosition+", ProjectId="+p.ProjectId,delegate{XTreeView.SelPrj(p.ProjectId);}));

TreeNode tn0=ProjectForm.treeView.Nodes.Add("Project Root");
foreach (ifcSQL.ifcProject.ProjectGroup_Row pg in ifcSQLin.ifcProject.ProjectGroup) if (pg.ParentProjectGroupId==0) pg.AddNodes(tn0); // removed if (pg.ProjectGroupId>0) // bb 28.03.2024

        
Application.Run(new ProjectForm("Select Project from ["+SqlServerName+"].["+DatabaseName+"]"));
//}catch(Exception e) {MessageBox.Show(e.Message,"Error",MessageBoxButtons.OK);}

}//of Main #################################################################################################################
}//of ifcSQL_PrjSel ========================================================================================================

