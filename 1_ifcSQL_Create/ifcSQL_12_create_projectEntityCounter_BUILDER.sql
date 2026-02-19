USE ifcSql;  
GO

IF OBJECT_ID('ifcProject.ProjectEntityCounter', 'U') IS NULL
BEGIN
    CREATE TABLE ifcProject.ProjectEntityCounter (
        ProjectId INT NOT NULL PRIMARY KEY,
        NextProjectEntityInstanceId INT NOT NULL
    );

    ALTER TABLE ifcProject.ProjectEntityCounter
    ADD CONSTRAINT FK_ProjectEntityCounter_Project
    FOREIGN KEY (ProjectId)
    REFERENCES ifcProject.Project(ProjectId);
END





