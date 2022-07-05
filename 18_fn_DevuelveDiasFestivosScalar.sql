USE [ADSReports]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_DevuelveDiasFestivosScalar]    Script Date: 26/03/2020 7:51:57 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_DevuelveDiasFestivosScalar](@dateStart AS datetime,@dateEnd as datetime)  
RETURNS int
AS 
BEGIN
 DECLARE @feriados int
   SELECT @feriados= count(*)  FROM festivos E 
   WHERE E.diafestivo between @dateStart and @dateEnd
  
   RETURN @feriados
END

