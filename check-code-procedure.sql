USE [Barkod]
GO
/****** Object:  StoredProcedure [dbo].[check_code]    Script Date: 12/20/2021 12:00:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[check_code]
@Code varchar(8),
@IsValid int out

as
begin
DECLARE @ControlCode int;
Declare @Chars varchar(23);
SET @Chars = 'ACDEFGHKLMNPRTXYZ234579';
DECLARE @LST int;


SET @LST = (select( ASCII(SUBSTRING(@Code, 1, 1)) +  ASCII(SUBSTRING(@Code, 2, 1)) +  ASCII(SUBSTRING(@Code, 3, 1))
+  ASCII(SUBSTRING(@Code, 4, 1))
+  ASCII(SUBSTRING(@Code, 5, 1))
+  ASCII(SUBSTRING(@Code, 6, 1))
+  ASCII(SUBSTRING(@Code, 7, 1))) % 23);

IF ASCII(SUBSTRING(@Code, 8, 1))= ASCII(SUBSTRING(@Chars,@LST, 1))
BEGIN
set @IsValid=1;
  Select @IsValid;

END
else
BEGIN
set @IsValid=0;
  Select @IsValid;
END
End
