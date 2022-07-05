USE [ADSReports]
GO

Create table PARAMETERS(
parameterpk integer IDENTITY(1,1),
name varchar(50),
value varchar(50)
);

Insert into PARAMETERS (name,value) values('Warehosedb',N'[ads_Warehouse]');
Insert into PARAMETERS(name,value) VALUES('ddspro',N'[Tfs_DDSPro]');
