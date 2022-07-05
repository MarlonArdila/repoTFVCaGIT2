USE [ADSReports]
GO
/****** Object:  StoredProcedure [dbo].[stp_calculaDiasEntreEstadosSinFestivos]    Script Date: 26/03/2020 7:39:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stp_calculaDiasEntreEstadosSinFestivos]
as
BEGIN
TRUNCATE TABLE DiasEntreEstadosSinFestivos;
DECLARE @Warehousedb varchar(50) = (Select p.value from PARAMETERS p where p.name='Warehosedb');
DECLARE @DiasEntreEstadosSinFestivos NVARCHAR(MAX);
 
 SET @DiasEntreEstadosSinFestivos=N'
INSERT INTO DiasEntreEstadosSinFestivos
SELECT [briefSysID]
	  ,MAX((DATEDIFF(day,[Claro_ALM_FechaRadicado],[Claro_ALM_FechaFactible])+1) - dbo.fn_DevuelveDiasFestivosScalar([Claro_ALM_FechaRadicado],[Claro_ALM_FechaFactible])) as T1
	  ,MAX((DATEDIFF(day,[Claro_ALM_FechaFactible],[Claro_ALM_FechaFSPBase])+1)- dbo.fn_DevuelveDiasFestivosScalar([Claro_ALM_FechaFactible],[Claro_ALM_FechaFSPBase])) as T2
	  ,MAX((DATEDIFF(day,[Claro_ALM_FechaFSPBase],[Claro_ALM_FechaFSPCerrado])+1)- dbo.fn_DevuelveDiasFestivosScalar([Claro_ALM_FechaFSPBase],[Claro_ALM_FechaFSPCerrado])) as T3
	  ,MAX((DATEDIFF(day,[Claro_ALM_FechaFSPCerrado],[Claro_ALM_FechaEstimado])+1)- dbo.fn_DevuelveDiasFestivosScalar([Claro_ALM_FechaFSPCerrado],[Claro_ALM_FechaEstimado])) as T4
	  ,MAX((DATEDIFF(day,[Claro_ALM_FechaEstimado],[Claro_ALM_FechaAprobadoJunta])+1)- dbo.fn_DevuelveDiasFestivosScalar([Claro_ALM_FechaEstimado],[Claro_ALM_FechaAprobadoJunta])) as T5
	  ,MAX((DATEDIFF(day,[Claro_ALM_FechaAprobadoJunta],[FechaInicialDesarrollo])+1)- dbo.fn_DevuelveDiasFestivosScalar([Claro_ALM_FechaAprobadoJunta],[FechaInicialDesarrollo])) as E1
	  ,MAX((DATEDIFF(day,[FechaInicialDesarrollo],[FechaFinalDesarrollo])+1)- dbo.fn_DevuelveDiasFestivosScalar([FechaInicialDesarrollo],[FechaFinalDesarrollo])) as E2
	  ,MAX((DATEDIFF(day,[FechaInicialPruebas],[FechaFinalPruebas])+1)- dbo.fn_DevuelveDiasFestivosScalar([FechaInicialPruebas],[FechaFinalPruebas])) as E3
	  ,MAX((DATEDIFF(day,[FechaFinalDesarrollo],[FechaRealDespliegue])+1)- dbo.fn_DevuelveDiasFestivosScalar([FechaFinalDesarrollo],[FechaRealDespliegue])) as E4
--  into DiasEntreEstadosSinFestivos
  FROM [dbo].[informeGeneral] as A
  group by  [briefSysID]';

END


