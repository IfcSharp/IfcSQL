ALTER TABLE [ifcSchema].[Type]  WITH CHECK ADD  CONSTRAINT [FK_Type_Type] FOREIGN KEY([ParentTypeId])
REFERENCES [ifcSchema].[Type] ([TypeId])
GO

ALTER TABLE [ifcSchema].[Type] CHECK CONSTRAINT [FK_Type_Type]
GO
