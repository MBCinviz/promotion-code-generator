

USE [Barkod]
GO
/****** Object:  StoredProcedure [dbo].[generate_codes]    Script Date: 12/19/2021 11:53:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[generate_codes]
as
begin
-- Kod üretimi için gerekli algoritma
-- Temsili olarak 1.000 adet kod üretilebilir
-- Burada üretilen her kod [check_code] ile doğrulanabilmelidir.



DECLARE @BARCODE varchar(8);
DECLARE @LST int;
DECLARE @MAX_INDEX int;

DECLARE @VAL1 varchar(1);
DECLARE @VAL2 varchar(1);
DECLARE @VAL3 varchar(1);
DECLARE @VAL4 varchar(1);
DECLARE @VAL5 varchar(1);
DECLARE @VAL6 varchar(1);
Declare @Chars varchar(23);
SET @Chars = 'ACDEFGHKLMNPRTXYZ234579';

set @MAX_INDEX = (select COUNT(*) from [dbo].[Codes]) + 1


SET @VAL1 = SUBSTRING(@Chars, (@MAX_INDEX + 5) % 23, 1);
SET @MAX_INDEX = @MAX_INDEX / 23;

SET @VAL2 = SUBSTRING(@Chars, (@MAX_INDEX + 16) % 23, 1);
SET @MAX_INDEX = @MAX_INDEX / 23;

SET @VAL3 = SUBSTRING(@Chars, (@MAX_INDEX + 3) % 23, 1);
SET @MAX_INDEX = @MAX_INDEX / 23;

SET @VAL4 = SUBSTRING(@Chars, (@MAX_INDEX + 11) % 23, 1);
SET @MAX_INDEX = @MAX_INDEX / 23;

SET @VAL5 = SUBSTRING(@Chars, (@MAX_INDEX + 3) % 23, 1);
SET @MAX_INDEX = @MAX_INDEX / 23;

SET @VAL6 = SUBSTRING(@Chars, (@MAX_INDEX + 17) % 23, 1);
SET @MAX_INDEX = @MAX_INDEX / 23;

againRnd:
SET @BARCODE = (select STRING_AGG(value, '') FROM
  (
select top 1
value FROM string_split('A,C,D,E,F,G,H,K,L,M,N,P,R,T,X,Y,Z,2,3,4,5,7,9', ',')  ORDER BY NEWID()
) as c);

IF @BARCODE='A' OR @BARCODE='C' OR @BARCODE='D'
BEGIN
  SET @BARCODE =@BARCODE + @VAL1 +  @VAL2 + @VAL3 + @VAL4 + @VAL5 + @VAL6;
END
ELSE
BEGIN
  IF @BARCODE='E' OR @BARCODE='F' OR @BARCODE='G'
  BEGIN
    SET @BARCODE = @BARCODE + @VAL3 +  @VAL2 + @VAL1 + @VAL6 + @VAL5 + @VAL4;
  END
  ELSE
  BEGIN
    IF @BARCODE='H' OR @BARCODE='K' OR @BARCODE='L'
    BEGIN
      SET @BARCODE = @BARCODE + @VAL5 +  @VAL2 + @VAL6 + @VAL4 + @VAL1 + @VAL3;
    END
    ELSE
    BEGIN
      IF @BARCODE='M' OR @BARCODE='N' OR @BARCODE='P'
      BEGIN
        SET @BARCODE =@BARCODE +  @VAL4 +  @VAL6 + @VAL3 + @VAL5 + @VAL1 + @VAL2;
      END
      ELSE
      BEGIN
        IF @BARCODE='R' OR @BARCODE='T' OR @BARCODE='X'
        BEGIN
          SET @BARCODE =@BARCODE +  @VAL4 +  @VAL3 + @VAL2 + @VAL6 + @VAL5 + @VAL1;
        END
        ELSE
        BEGIN
          IF @BARCODE='Y' OR @BARCODE='Z' OR @BARCODE='2'
          BEGIN
            SET @BARCODE =@BARCODE +  @VAL6 +  @VAL5 + @VAL4 + @VAL3 + @VAL2 + @VAL1;
          END
          ELSE
          BEGIN
            IF @BARCODE='3' OR @BARCODE='4' OR @BARCODE='5'
            BEGIN
              SET @BARCODE =@BARCODE +  @VAL4 +  @VAL3 + @VAL2 + @VAL1 + @VAL6 + @VAL5;
            END
            ELSE
            BEGIN
              IF @BARCODE='7' OR @BARCODE='9'
              BEGIN
                SET @BARCODE = @BARCODE + @VAL5 +  @VAL2 + @VAL4 + @VAL1 + @VAL6 + @VAL3;
              END
            END
          END
        END
      END
    END
  END
END

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
