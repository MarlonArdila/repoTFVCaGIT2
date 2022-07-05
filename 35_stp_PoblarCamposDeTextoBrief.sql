USE [ADSReports]
GO
/****** Object:  StoredProcedure [dbo].[stp_PoblarCamposDeTextoBrief]    Script Date: 26/03/2020 7:47:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_PoblarCamposDeTextoBrief]
AS
BEGIN


--------------------
--ELIMINA INFORMACIÓN EXISTENTE
--------------------
TRUNCATE TABLE [dbo].[CamposDeTextoBrief];
TRUNCATE TABLE [dbo].[DescripcionFasesBrief]

------------------------------------------
--Constante con esquema bd tfs
-----------------------------------------

DECLARE @DDSpro varchar(50) = (Select p.value from PARAMETERS p where p.name='ddspro');
-----------------------------------------------
--------------------
--INGRESA INFORMACIÓN ACTUALIZADA
--------------------


DECLARE @InsertCamposDeTextoBrief NVARCHAR(MAX);
 SET @InsertCamposDeTextoBrief=N'
 INSERT INTO  [dbo].[CamposDeTextoBrief] 
(workitemsk,descripcion,beneficioBrief,ReqNOFuncionalBrief,NotificacionAlUsuario,SeguimientoIT
,RiskDescPlanMitiga,RiskDesencPlanMitiga,RiskDesencPlanConting,ReqNegfuncionalidadActual,ReqNegcriteriosAceptacion)
select workitemsk
, MAX(descripcion)descripcion
,MAX(beneficioBrief) beneficioBrief
,MAX(ReqNOFuncionalBrief)ReqNOFuncionalBrief
,''''
,''''
,MAX(RiesgoDescripcionPlanMitigacion)RiesgoDescripcionPlanMitigacion
,MAX(RiesgoDesencadenPlanMitigacion)RiesgoDesencadenPlanMitigacion
,MAX(RiesgoDescripPlanConting)RiesgoDescripPlanConting
,MAX(funcionalidadActual)funcionalidadActual
,MAX(criteriosAceptacion)criteriosAceptacion
FROM 
(
select ID as workitemsk, 
case when fldID=52 then REPLACE(CAST(words AS NVARCHAR(MAX)), ''&quot;'','''') else '''' end as descripcion
,case when FldID=10214 then words else '''' end as beneficioBrief
,case when fldID=10256 then words else '''' end as ReqNOFuncionalBrief
--,case when fldID=10226 then words else '''' end as NotificacionAlUsuario Se quita esta linea de codigo ya que es necesario revisar los multiples registros que genera el historico cada vez que aumenta la información en este campo de SeguimientoIT en TFS
--,case when fldID=10227 then words else '''' end as SeguimientoIT Se quita esta linea de codigo ya que es necesario revisar los multiples registros que genera el historico cada vez que aumenta la información en este campo de SeguimientoIT en TFS
,case when FldID=10335 then words else '''' end as RiesgoDescripcionPlanMitigacion
,case when fldID=10334 then words else '''' end as RiesgoDesencadenPlanMitigacion
,case when fldID=10336 then words else '''' end as RiesgoDescripPlanConting
,case when fldID=10247 then words else '''' end as funcionalidadActual
,case when fldID=10179 then words else '''' end as criteriosAceptacion
from '+ @DDSpro +'.[dbo].[WorkItemLongTexts] ) AS A
GROUP BY workitemsk';


--SELECT @InsertCamposDeTextoBrief;

EXEC sp_executesql @InsertCamposDeTextoBrief;


/*Selecciona solo el campo de seguimientoIT para todos los Briefs*/

DECLARE @seguimientoBrief NVARCHAR(MAX);
 SET @seguimientoBrief=N'
select ID as workitemsk,Rev,
case when fldID=10227 then words else '''' end as SeguimientoIT
into ##campoSeguimientoITBrief
from '+@DDSpro+'.[dbo].[WorkItemLongTexts]';
--SELECT @seguimientoBrief;

EXEC sp_executesql @seguimientoBrief;

/*Filtra el registro mas actual*/
select t1.*
into #SeguimientoIT
from ##campoSeguimientoITBrief as t1
where t1.SeguimientoIT<>'' and t1.rev=(select max(t2.Rev) from ##campoSeguimientoITBrief t2 where t2.SeguimientoIT<>'' and t2.workitemsk=t1.workitemsk group by t2.workitemsk)
order by t1.workitemsk;


/*Actualiza el campo SeguimientoIT en la tabla principal*/
UPDATE [dbo].[CamposDeTextoBrief]
SET SeguimientoIT=s.SeguimientoIT
from [dbo].[CamposDeTextoBrief] inner join #SeguimientoIT s on [dbo].[CamposDeTextoBrief].workitemsk=s.workitemsk;

/*Selecciona solo el campo de NotificacionAlUsuario para todos los Briefs*/

DECLARE @notificacinUBrief NVARCHAR(MAX);
 SET @notificacinUBrief=N'
select ID as workitemsk,Rev,
case when fldID=10226 then words else '''' end as NotificacionU
into ##campoNotificacionUBrief
from '+@DDSpro+'.[dbo].[WorkItemLongTexts]';

SELECT @notificacinUBrief;

EXEC sp_executesql @notificacinUBrief;


/*Filtra el registro mas actual*/

select t3.*
into #NotificacionU
from ##campoNotificacionUBrief as t3
where t3.NotificacionU<>'' and t3.rev=(select max(t4.Rev) from ##campoNotificacionUBrief t4 where t4.NotificacionU<>'' and t4.workitemsk=t3.workitemsk group by t4.workitemsk)
order by t3.workitemsk;


/*Actualiza el campo SeguimientoIT en la tabla principal*/
UPDATE [dbo].[CamposDeTextoBrief]
SET NotificacionAlUsuario=n.NotificacionU
from [dbo].[CamposDeTextoBrief] inner join #NotificacionU n on [dbo].[CamposDeTextoBrief].workitemsk=n.workitemsk;


/*Actualiza la información correspondiende a la descripción de las fases del brief*/

DECLARE @insDesdFasesBrief NVARCHAR(MAX);
 SET @insDesdFasesBrief=N'
INSERT [dbo].[DescripcionFasesBrief]([workitemsk],[Fase],[Claro_ALM_DescripcionFase])
SELECT witlt.ID,CAST(REPLACE(field.ReportingReferenceName,''Claro.ALM.DescripcionFase'','''') as int) as Fase,witlt.Words
FROM '+@DDSpro+'.[dbo].[WorkItemLongTexts] witlt
INNER JOIN '+@DDSpro+'.[dbo].[tbl_Field] field
ON witlt.FldID = field.FieldId
WHERE field.ReferenceName in
(''Claro.ALM.DescripcionFase1'',
 ''Claro.ALM.DescripcionFase2'',
 ''Claro.ALM.DescripcionFase3'',
 ''Claro.ALM.DescripcionFase4'',
 ''Claro.ALM.DescripcionFase5'',
 ''Claro.ALM.DescripcionFase6'',
 ''Claro.ALM.DescripcionFase7'',
 ''Claro.ALM.DescripcionFase8'',
 ''Claro.ALM.DescripcionFase9'',
 ''Claro.ALM.DescripcionFase10'',
 ''Claro.ALM.DescripcionFase11'',
 ''Claro.ALM.DescripcionFase12'',
 ''Claro.ALM.DescripcionFase13'',
 ''Claro.ALM.DescripcionFase14'',
 ''Claro.ALM.DescripcionFase15'',
 ''Claro.ALM.DescripcionFase16'',
 ''Claro.ALM.DescripcionFase17'',
 ''Claro.ALM.DescripcionFase18'',
 ''Claro.ALM.DescripcionFase19'',
 ''Claro.ALM.DescripcionFase20'')
 AND witlt.AddedDate = (SELECT MAX(AddedDate) FROM '+@DDSpro+'.[dbo].[WorkItemLongTexts] witlt2
						WHERE witlt2.ID = witlt.ID AND witlt2.FldID = witlt.FldID
						GROUP BY witlt2.ID,witlt2.FldID)';

--SELECT @insDesdFasesBrief;
EXEC sp_executesql @insDesdFasesBrief;

DROP TABLE ##campoSeguimientoITBrief;
DROP TABLE ##campoNotificacionUBrief;
END








