USE [ADSReports]
GO
/****** Object:  StoredProcedure [dbo].[stp_RepVencimientosSLA]    Script Date: 26/03/2020 7:47:54 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stp_RepVencimientosSLA] 
as
BEGIN

DECLARE @Warehousedb varchar(50) = (Select p.value from PARAMETERS p where p.name='Warehosedb');

Declare @querycollectionguid NVARCHAR(500);
Declare @Params nvarchar(50);
SET  @Params=N'@varresul NVARCHAR(50) OUTPUT';
DECLARE @TEAMPROJECTCOLLECTIONGUID NVARCHAR(50);
SET @querycollectionguid=N'
(select @varresul=ProjectNodeSK from '+@Warehousedb+'.[dbo].[DimTeamProject] --SELECT * from [dbo].[DimTeamProject] where projectnodesk=23
  where ProjectNodeName=''DDSPro'')';

 Exec sp_executesql @querycollectionguid,@Params,@varresul = @TEAMPROJECTCOLLECTIONGUID output;

 --select @TEAMPROJECTCOLLECTIONGUID;
---------------------------------------------
-- Selecciona todos los Briefs tipo Requerimiento que no esten cerrados
---------------------------------------------
DECLARE @testBriefComp NVARCHAR(MAX);
 SET @testBriefComp=N'
select DISTINCT c.WorkItemSK, c.System_Id,c.System_Title,c.System_State,c.Claro_ALM_Segmento,c.Claro_ALM_Complejidad,
Claro_ALM_FechaFSPBase,Claro_ALM_FechaFSPCerrado,Claro_ALM_FechaEstimado
into ##briefComp 
from '+@Warehousedb+'.dbo.CurrentWorkItemView c
where c.TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and c.System_WorkItemType=''Brief'' and c.Claro_ALM_Clasificacion=''Requerimiento'' and NOT Claro_ALM_Complejidad IS NULL and c.System_State<>''Cerrado''
and 
c.System_Title <>''Para eliminar espacio'' 
ORDER BY System_Id';

DECLARE @parambrief2 NVARCHAR(100);
SET @parambrief2=N'@TEAMPROJECTCOLLECTIONGUID NVARCHAR(50)';
EXEC sp_executesql @testBriefComp,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;
--SELECT * FROM ##briefComp;
-----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------/**** Primer SubProcedimiento ***/---------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------
-- Se calcular Briefs vencidos en los tiempos 2 y 3 descritos que corresponden a (IT - Neg). 
--Este cálculo se realiza solo teniendo en cuenta fechas del brief 
---------------------------------------------
truncate table [tbl_VencimConstEstimNegIT]


DECLARE @InsertVencimConstEstimNegIT NVARCHAR(MAX);
 SET @InsertVencimConstEstimNegIT=N'
INSERT INTO [tbl_VencimConstEstimNegIT] ([ID_Brief],
	[TipoVencimiento],
	[MaxDiasVencimiento],
	[DiasDiferencia],
	[En_Tiempo],
	[Vencido],
	[DiasAcum])
SELECT t.*
FROM
(select System_Id,''ConstFSP_ITNeg'' as tipoVenc,d.[ConstruccionFSP ] as maxDiasPerm, 
(DATEDIFF(day,b.Claro_ALM_FechaFSPBase,b.Claro_ALM_FechaFSPCerrado)+1)- dbo.fn_DevuelveDiasFestivosScalar(b.Claro_ALM_FechaFSPBase,b.Claro_ALM_FechaFSPCerrado) as diasdif_ConsFSP,
1 as en,
0 as ven,
NULL as Acum
from ##briefComp b inner join DiasVencimientos d on b.Claro_ALM_Complejidad=d.Complejidad
where b.System_State=''FSP Base'' AND 
NOT b.Claro_ALM_FechaFSPBase IS NULL AND NOT b.Claro_ALM_FechaFSPCerrado IS NULL 
AND ((DATEDIFF(day,b.Claro_ALM_FechaFSPBase,b.Claro_ALM_FechaFSPCerrado)+1)- dbo.fn_DevuelveDiasFestivosScalar(b.Claro_ALM_FechaFSPBase,b.Claro_ALM_FechaFSPCerrado)<d.[ConstruccionFSP ] OR
(DATEDIFF(day,b.Claro_ALM_FechaFSPBase,b.Claro_ALM_FechaFSPCerrado)+1)- dbo.fn_DevuelveDiasFestivosScalar(b.Claro_ALM_FechaFSPBase,b.Claro_ALM_FechaFSPCerrado)=d.[ConstruccionFSP ])
union
select System_Id,''ConstFSP_ITNeg'' as tipoVenc,d.[ConstruccionFSP ] as maxDiasPerm, 
(DATEDIFF(day,b.Claro_ALM_FechaFSPBase,b.Claro_ALM_FechaFSPCerrado)+1)- dbo.fn_DevuelveDiasFestivosScalar(b.Claro_ALM_FechaFSPBase,b.Claro_ALM_FechaFSPCerrado) as diasdif_ConsFSP,
0 as en,
1 as ven,
NULL as Acum
from ##briefComp b inner join DiasVencimientos d on b.Claro_ALM_Complejidad=d.Complejidad
where  b.System_State=''FSP Base'' AND 
NOT b.Claro_ALM_FechaFSPBase IS NULL AND NOT b.Claro_ALM_FechaFSPCerrado IS NULL AND
(DATEDIFF(day,b.Claro_ALM_FechaFSPBase,b.Claro_ALM_FechaFSPCerrado)+1)- dbo.fn_DevuelveDiasFestivosScalar(b.Claro_ALM_FechaFSPBase,b.Claro_ALM_FechaFSPCerrado)>d.[ConstruccionFSP ]
union
--Selecciona Briefs que aun no han terminado la Construccion FSP
select System_Id,''ConstFSP_ITNeg'' as tipoVenc,d.[ConstruccionFSP ] as maxDiasPerm, NULL as diasdif_ConsFSP,
NULL as en,
NULL as ven,
(DATEDIFF(day,b.Claro_ALM_FechaFSPBase,GETDATE())+1)- dbo.fn_DevuelveDiasFestivosScalar(b.Claro_ALM_FechaFSPBase,GETDATE()) as Acum
from ##briefComp b inner join DiasVencimientos d on b.Claro_ALM_Complejidad=d.Complejidad
where  b.System_State=''FSP Base'' AND  
NOT b.Claro_ALM_FechaFSPBase IS NULL AND  b.Claro_ALM_FechaFSPCerrado IS NULL
UNION
--Selecciona Briefs a tiempo en Vencimiento tipo Estimacion Desarrollo
select System_Id,''EstimFSP_ITNeg'' as tipoVenc,d.[EstimacionDesarrollo ] as maxDiasPerm,
(DATEDIFF(day,b.Claro_ALM_FechaFSPCerrado,b.Claro_ALM_FechaEstimado)+1)- dbo.fn_DevuelveDiasFestivosScalar(b.Claro_ALM_FechaFSPCerrado,b.Claro_ALM_FechaEstimado) as diasdif_Estim,
1 as en,
0 as ven,
NULL as Acum
from ##briefComp b inner join DiasVencimientos d on b.Claro_ALM_Complejidad=d.Complejidad
where b.System_State=''FSP Cerrado'' AND 
NOT b.Claro_ALM_FechaFSPCerrado IS NULL AND NOT b.Claro_ALM_FechaEstimado IS NULL 
AND ((DATEDIFF(day,b.Claro_ALM_FechaFSPCerrado,b.Claro_ALM_FechaEstimado)+1)- dbo.fn_DevuelveDiasFestivosScalar(b.Claro_ALM_FechaFSPCerrado,b.Claro_ALM_FechaEstimado)<d.[EstimacionDesarrollo ]OR
(DATEDIFF(day,b.Claro_ALM_FechaFSPCerrado,b.Claro_ALM_FechaEstimado)+1)- dbo.fn_DevuelveDiasFestivosScalar(b.Claro_ALM_FechaFSPCerrado,b.Claro_ALM_FechaEstimado)=d.[EstimacionDesarrollo ])
union
--Selecciona Briefs vencidos en Vencimiento tipo Estimacion Desarrollo
select System_Id,''EstimFSP_ITNeg'' as tipoVenc,d.[EstimacionDesarrollo ] as maxDiasPerm,
(DATEDIFF(day,b.Claro_ALM_FechaFSPCerrado,b.Claro_ALM_FechaEstimado)+1)- dbo.fn_DevuelveDiasFestivosScalar(b.Claro_ALM_FechaFSPCerrado,b.Claro_ALM_FechaEstimado) as diasdif_Estim,
0 as en,
1 as ven,
NULL as Acum
from ##briefComp b inner join DiasVencimientos d on b.Claro_ALM_Complejidad=d.Complejidad
where  b.System_State=''FSP Cerrado'' AND 
NOT b.Claro_ALM_FechaFSPCerrado IS NULL AND NOT b.Claro_ALM_FechaEstimado IS NULL AND
(DATEDIFF(day,b.Claro_ALM_FechaFSPCerrado,b.Claro_ALM_FechaEstimado)+1)- dbo.fn_DevuelveDiasFestivosScalar(b.Claro_ALM_FechaFSPCerrado,b.Claro_ALM_FechaEstimado)>d.[EstimacionDesarrollo ]
union
--Selecciona Briefs que aun no han terminado la Estimacion Desarrollo
select System_Id,''EstimFSP_ITNeg'' as tipoVenc,d.[EstimacionDesarrollo ] as maxDiasPerm, NULL as diasdif_Estim,
NULL as en,
NULL as ven,
(DATEDIFF(day,b.Claro_ALM_FechaFSPCerrado,GETDATE())+1)- dbo.fn_DevuelveDiasFestivosScalar(b.Claro_ALM_FechaFSPCerrado,GETDATE()) as Acum
from ##briefComp b inner join DiasVencimientos d on b.Claro_ALM_Complejidad=d.Complejidad
where b.System_State=''FSP Cerrado'' AND 
NOT b.Claro_ALM_FechaFSPCerrado IS NULL AND  b.Claro_ALM_FechaEstimado IS NULL) AS t
order by t.System_Id';

EXEC sp_executesql @InsertVencimConstEstimNegIT;

--Para los Briefs que aun no han concluido sus correspondientes vencimientos, determina si a la fecha actual estan en tiempo
UPDATE [tbl_VencimConstEstimNegIT]
SET [En_Tiempo]=1, [Vencido]=0
WHERE [DiasDiferencia] IS NULL AND ([DiasAcum]<[MaxDiasVencimiento] OR [DiasAcum]=[MaxDiasVencimiento])

--Para los Briefs que aun no han concluido sus correspondientes vencimientos, determina si a la fecha actual estan vencidos 
UPDATE [tbl_VencimConstEstimNegIT]
SET [En_Tiempo]=0, [Vencido]=1
WHERE [DiasDiferencia] IS NULL AND [DiasAcum]>[MaxDiasVencimiento]

--Para los vencidos, calcula cuantos periodos lleva vencidos
UPDATE [tbl_VencimConstEstimNegIT]
SET PeriodosVenc=DiasDiferencia/[MaxDiasVencimiento]
WHERE Vencido=1 AND NOT DiasDiferencia IS NULL AND DiasAcum IS NULL

UPDATE [tbl_VencimConstEstimNegIT]
SET PeriodosVenc=DiasAcum/[MaxDiasVencimiento]
WHERE Vencido=1 AND NOT DiasAcum IS NULL AND DiasDiferencia IS NULL

-- Actualiza el campo Segmento para todos los Briefs
UPDATE [tbl_VencimConstEstimNegIT]
SET [Claro_ALM_Segmento]=b.Claro_ALM_Segmento
from ##briefComp b inner join [tbl_VencimConstEstimNegIT] v on b.System_Id=v.ID_Brief
------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------/**** Segundo SubProcedimiento ***/---------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------
-- Carga en tabla temporal todos los links entre todos los WI
---------------------------------------------

DECLARE @vFactLinkedCurrentWorkItem NVARCHAR(MAX);
 SET @vFactLinkedCurrentWorkItem=N'
select a.SourceWorkItemSK,a.TargetWorkitemSK
into ##vFactLinkedCurrentWorkItem
from '+@Warehousedb+'.[dbo].[vFactLinkedCurrentWorkItem] as a
group by  a.SourceWorkItemSK,a.TargetWorkitemSK';

EXEC sp_executesql @vFactLinkedCurrentWorkItem;

---------------------------------------------
-- Borra toda la tabla y vuelve a insertar los calculos
---------------------------------------------
truncate table [tbl_VencimientosDetalle];

DECLARE @Inserttbl_VencimientosDetalle NVARCHAR(MAX);
 SET @Inserttbl_VencimientosDetalle=N'
INSERT INTO [dbo].[tbl_VencimientosDetalle]([Wisk_Brief],
	[ID_Brief],
	[Titulo_Brief],
	[ComplejidadBrief],
	[Claro_ALM_Segmento],
	[Estado_Brief],
	[TipoVencimiento],
	[MaxDiasVencimiento],
	[Tipo_Wi],
	Wisk_Wi,
	[ID_Wi],
	[Estado_Wi],
	[Campo_Wi],
	[ValorCampo_Wi],
	[FechaIniDesc],
	[FechaIniValor],
	[FechaFinDesc],
	[FechaFinValor],
	[DiasDiferencia])
select *
from
(select b.WorkItemSK as WiskBrief, b.System_Id as IdBrief,b.System_Title,b.Claro_ALM_Complejidad,b.Claro_ALM_Segmento,b.System_State as EstadoBrief,
		''EstimacionGerDes'' as NombreVencimiento,d.[EstimacionDesarrollo],''Tarea'' as TipoWi,
		c.WorkItemSK,c.System_Id, c.System_State,''GerenciaDesarrollo'' as CampoWi,c.Claro_ALM_Gerencia,
		''FechaCrea'' as NombreFechaIni,c.System_CreatedDate,''FechaResol'' as NombreFechaFin,Microsoft_VSTS_Common_ResolvedDate,
(DATEDIFF(day,c.System_CreatedDate,Microsoft_VSTS_Common_ResolvedDate)+1)- dbo.fn_DevuelveDiasFestivosScalar(c.System_CreatedDate,Microsoft_VSTS_Common_ResolvedDate) as diasdif
from ##briefComp b inner join DiasVencimientos d on b.Claro_ALM_Complejidad=d.Complejidad
				left join ##vFactLinkedCurrentWorkItem v on b.WorkItemSK=v.SourceWorkItemSK
				left join '+@Warehousedb+'.[dbo].CurrentWorkItemView c on v.TargetWorkitemSK=c.WorkItemSK
where  --b.System_State=''Factible'' AND --Solo se estiman a akto nivel los briefs aprobados inicialmente
 c.TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and c.System_WorkItemType=''Tarea'' and c.Microsoft_VSTS_CMMI_TaskType=''Solicitud estimación''
union
select b.WorkItemSK as WiskBrief, b.System_Id as IdBrief,b.System_Title,b.Claro_ALM_Complejidad,b.Claro_ALM_Segmento,b.System_State as EstadoBrief,
		''ConstFSP_ITNeg'' as NombreVencimiento,d.[ConstruccionFSP],''RequerimientoNegocio'' as TipoWi,
		c.WorkItemSK,c.System_Id, c.System_State,''Motivo'' as CampoWi,c.System_Reason,
		''FechaFSPBase'' as NombreFechaIni,b.Claro_ALM_FechaFSPBase,''FechaFSPCerrado'' as NombreFechaFin,b.Claro_ALM_FechaFSPCerrado,
(DATEDIFF(day,b.Claro_ALM_FechaFSPBase,b.Claro_ALM_FechaFSPCerrado)+1)- dbo.fn_DevuelveDiasFestivosScalar(b.Claro_ALM_FechaFSPBase,b.Claro_ALM_FechaFSPCerrado) as diasdif
from ##briefComp b inner join DiasVencimientos d on b.Claro_ALM_Complejidad=d.Complejidad
				left join ##vFactLinkedCurrentWorkItem v on b.WorkItemSK=v.SourceWorkItemSK
				left join '+@Warehousedb+'.[dbo].CurrentWorkItemView c on v.TargetWorkitemSK=c.WorkItemSK
where  b.System_State=''FSP Base'' AND 
c.TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and c.System_WorkItemType=''RequerimientoNegocio''
union 
select b.WorkItemSK as WiskBrief, b.System_Id as IdBrief,b.System_Title,b.Claro_ALM_Complejidad,b.Claro_ALM_Segmento,b.System_State as EstadoBrief,''EstimFSP_ITNeg'' as NombreVencimiento,d.[EstimacionDesarrollo],''RequerimientoNegocio'' as TipoWi,
		c.WorkItemSK,c.System_Id, c.System_State,''Motivo'' as CampoWi,c.System_Reason,
		''FechaFSPCerrado'' as NombreFechaIni,b.Claro_ALM_FechaFSPCerrado,''FechaEstimado'' as NombreFechaIni,b.Claro_ALM_FechaEstimado,
(DATEDIFF(day,b.Claro_ALM_FechaFSPCerrado,b.Claro_ALM_FechaEstimado)+1)- dbo.fn_DevuelveDiasFestivosScalar(b.Claro_ALM_FechaFSPCerrado,b.Claro_ALM_FechaEstimado) as diasdif
from ##briefComp b inner join DiasVencimientos d on b.Claro_ALM_Complejidad=d.Complejidad
				left join ##vFactLinkedCurrentWorkItem v on b.WorkItemSK=v.SourceWorkItemSK
				left join '+@Warehousedb+'.[dbo].CurrentWorkItemView c on v.TargetWorkitemSK=c.WorkItemSK
where   b.System_State=''FSP Cerrado'' AND 
c.TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and c.System_WorkItemType=''RequerimientoNegocio''
) as temp
order by temp.System_Id';
--SELECT  @Inserttbl_VencimientosDetalle;
EXEC sp_executesql @Inserttbl_VencimientosDetalle,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;

---------------------------------------------
-- Actualiza si esta vencido o no el brief 
---------------------------------------------
UPDATE tbl_VencimientosDetalle 
SET [En_Tiempo] = 1,[Vencido]=0,[Neg]=0,[IT]=0
WHERE DiasDiferencia<MaxDiasVencimiento or DiasDiferencia=MaxDiasVencimiento 

UPDATE tbl_VencimientosDetalle 
SET [En_Tiempo] = 0,[Vencido]=1,[Neg]=0,[IT]=0
WHERE DiasDiferencia>MaxDiasVencimiento 

---------------------------------------------
-- Para los briefs a los que se les calculó el primer tiepo de vencimiento si el actualiza si a hoy estan vencidos o no en caso
-- de que que aun no hayan concluido
---------------------------------------------
--Vencidos a hoy
UPDATE tbl_VencimientosDetalle 
SET [En_Tiempo] = 0,[Vencido]=1,[Neg]=0,[IT]=0
WHERE FechaFinValor IS NULL AND Tipo_Wi='Tarea'
AND (DATEDIFF(day,FechaIniValor,GETDATE())+1)- dbo.fn_DevuelveDiasFestivosScalar(FechaIniValor,GETDATE())>MaxDiasVencimiento 

--En Tiempo a hoy
UPDATE tbl_VencimientosDetalle 
SET [En_Tiempo] = 1,[Vencido]=0,[Neg]=0,[IT]=0
WHERE FechaFinValor IS NULL AND Tipo_Wi='Tarea'
AND (
(DATEDIFF(day,FechaIniValor,GETDATE())+1)- dbo.fn_DevuelveDiasFestivosScalar(FechaIniValor,GETDATE())<MaxDiasVencimiento 
OR
(DATEDIFF(day,FechaIniValor,GETDATE())+1)- dbo.fn_DevuelveDiasFestivosScalar(FechaIniValor,GETDATE())=MaxDiasVencimiento 
)
---------------------------------------------
-- Para los vencidos del segundo y tercer tipo de vencimiento determina si esta vencido del lado de negocio cuando al menos un requerimiento de negocio esta en Aclaracion Negocio
---------------------------------------------
UPDATE tbl_VencimientosDetalle
SET Neg=1
WHERE Vencido=1 and 
TipoVencimiento='ConstFSP_ITNeg' and 
exists (select 1 from tbl_VencimientosDetalle v1 where v1.ID_Brief=ID_Brief and v1.TipoVencimiento=TipoVencimiento and v1.ValorCampo_Wi='Aclaración de negocio')

UPDATE tbl_VencimientosDetalle
SET Neg=1
WHERE Vencido=1 and 
TipoVencimiento='EstimFSP_ITNeg' and 
exists (select 1 from tbl_VencimientosDetalle v1 where v1.ID_Brief=ID_Brief and v1.TipoVencimiento=TipoVencimiento and v1.ValorCampo_Wi='Aclaración de negocio')

---------------------------------------------
-- Finalmente los vencidos que no esten del lado de Negocio se dejan del lado de IT
---------------------------------------------
UPDATE tbl_VencimientosDetalle
SET [IT]=Vencido-Neg
WHERE Vencido=1 and TipoVencimiento in('ConstFSP_ITNeg','EstimFSP_ITNeg')

DROP TABLE ##briefComp;
DROP TABLE ##vFactLinkedCurrentWorkItem;

END






