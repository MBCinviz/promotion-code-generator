USE [Barkod]
GO
/****** Object:  StoredProcedure [dbo].[generate_codes]    Script Date: 12/19/2021 11:58:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[generate_codes]
as
begin




DECLARE @BARCODE varchar(8);
DECLARE @LST int;
Declare @Chars varchar(23);
SET @Chars = 'ACDEFGHKLMNPRTXYZ234579';

againRnd:
SET @BARCODE = (select STRING_AGG(value, '') FROM
  (
select top 7 
value FROM string_split('A,C,D,E,F,G,H,K,L,M,N,P,R,T,X,Y,Z,2,3,4,5,7,9', ',')  ORDER BY NEWID()
) as c);

SET @LST = (select( ASCII(SUBSTRING(@BARCODE, 1, 1)) +  ASCII(SUBSTRING(@BARCODE, 2, 1)) +  ASCII(SUBSTRING(@BARCODE, 3, 1))
+  ASCII(SUBSTRING(@BARCODE, 4, 1))
+  ASCII(SUBSTRING(@BARCODE, 5, 1))
+  ASCII(SUBSTRING(@BARCODE, 6, 1))
+  ASCII(SUBSTRING(@BARCODE, 7, 1))) % 23);

SET @BARCODE = @BARCODE+SUBSTRING(@Chars, @LST, 1);

IF (select COUNT(*) from [dbo].[Codes] where Code = @BARCODE)=0
BEGIN
Insert Into [dbo].[Codes](Code) values ( @BARCODE);
END
ELSE
BEGIN
GOTO againRnd;
END
end
