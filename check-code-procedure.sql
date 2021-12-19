USE [Barkod]
GO
/****** Object:  StoredProcedure [dbo].[check_code]    Script Date: 12/19/2021 11:53:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[check_code]
@Code varchar(8),
@IsValid int out

as
begin
DECLARE @VAL1 int;
DECLARE @VAL2 int;
DECLARE @VAL3 int;
DECLARE @VAL4 int;
DECLARE @VAL5 int;
DECLARE @VAL6 int;
DECLARE @MAX_INDEX int;
DECLARE @BARCODE varchar(1);
DECLARE @ControlCode int;
Declare @Chars varchar(23);
SET @Chars = 'ACDEFGHKLMNPRTXYZ234579';
DECLARE @LST int;
-- Kod kontrolü için gerekli algoritma
-- [generate_codes] ile üretilen her kod [check_code] ile doğrulanabilmelidir.
-- Bu aşamada kod bir tabloda aranmayacaktır!

SET @LST = (select( ASCII(SUBSTRING(@Code, 1, 1)) +  ASCII(SUBSTRING(@Code, 2, 1)) +  ASCII(SUBSTRING(@Code, 3, 1))
+  ASCII(SUBSTRING(@Code, 4, 1))
+  ASCII(SUBSTRING(@Code, 5, 1))
+  ASCII(SUBSTRING(@Code, 6, 1))
+  ASCII(SUBSTRING(@Code, 7, 1))) % 23);

IF ASCII(SUBSTRING(@Code, 8, 1))= ASCII(SUBSTRING(@Chars,@LST, 1))
BEGIN

 SET @BARCODE = SUBSTRING(@Code, 1, 1)
 
 SET @Code = SUBSTRING(@Code, 1, 6)
  IF @BARCODE='A' OR @BARCODE='C' OR @BARCODE='D'
  BEGIN
    SET @VAL1 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 1, 1)) - 4) % 23);
    SET @VAL2 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 2, 1)) - 15) %23);
    SET @VAL3 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 3, 1)) - 2) %23);
    SET @VAL4 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 4, 1)) - 10) %23);
    SET @VAL5 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 5, 1)) - 2) %23);
    SET @VAL6 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 6, 1)) - 16) %23);
  END
  ELSE
  BEGIN
    IF @BARCODE='E' OR @BARCODE='F' OR @BARCODE='G'
    BEGIN
      SET @VAL1 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 3, 1)) - 4) %23);
      SET @VAL2 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 2, 1)) - 15) %23);
      SET @VAL3 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 1, 1)) - 2) %23);
      SET @VAL4 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 6, 1)) - 10) %23);
      SET @VAL5 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 5, 1)) - 2) %23);
      SET @VAL6 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 4, 1)) - 16) %23);
    END
    ELSE
    BEGIN
      IF @BARCODE='H' OR @BARCODE='K' OR @BARCODE='L'
      BEGIN
        SET @VAL1 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 5, 1)) - 4) %23);
        SET @VAL2 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 2, 1)) - 15) %23);
        SET @VAL3 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 6, 1)) - 2) %23);
        SET @VAL4 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 4, 1)) - 10) %23);
        SET @VAL5 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 1, 1)) - 4) %23);
        SET @VAL6 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 3, 1)) - 16) %23);
      END
      ELSE
      BEGIN
        IF @BARCODE='M' OR @BARCODE='N' OR @BARCODE='P'
        BEGIN
          SET @VAL1 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 4, 1)) - 4) %23);
          SET @VAL2 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 6, 1)) - 15) %23);
          SET @VAL3 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 3, 1)) - 2) %23);
          SET @VAL4 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 5, 1)) - 10) %23);
          SET @VAL5 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 1, 1)) - 2) %23);
          SET @VAL6 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 2, 1)) - 16) %23);
        END
        ELSE
        BEGIN
          IF @BARCODE='R' OR @BARCODE='T' OR @BARCODE='X'
          BEGIN
            SET @VAL1 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 4, 1)) - 4) %23);
            SET @VAL2 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 3, 1)) - 15) %23);
            SET @VAL3 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 2, 1)) - 2) %23);
            SET @VAL4 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 6, 1)) - 10) %23);
            SET @VAL5 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 5, 1)) - 2) %23);
            SET @VAL6 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 1, 1)) - 16) %23);
          END
          ELSE
          BEGIN
            IF @BARCODE='Y' OR @BARCODE='Z' OR @BARCODE='2'
            BEGIN
              SET @VAL1 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 6, 1)) - 4) %23);
              SET @VAL2 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 5, 1)) - 15) %23);
              SET @VAL3 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 4, 1)) - 2) %23);
              SET @VAL4 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 3, 1)) - 10) %23);
              SET @VAL5 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 2, 1)) - 2) %23);
              SET @VAL6 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 1, 1)) - 16) %23);
            END
            ELSE
            BEGIN
              IF @BARCODE='3' OR @BARCODE='4' OR @BARCODE='5'
              BEGIN
                SET @VAL1 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 4, 1)) - 4) %23);
                SET @VAL2 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 3, 1)) - 15) %23);
                SET @VAL3 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 2, 1)) - 2) %23);
                SET @VAL4 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 1, 1)) - 10) %23);
                SET @VAL5 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 6, 1)) - 2) %23);
                SET @VAL6 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 5, 1)) - 16) %23);
              END
              ELSE
              BEGIN
                IF @BARCODE='7' OR @BARCODE='9'
                BEGIN
                  SET @VAL1 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 5, 1)) - 4) %23);
                  SET @VAL2 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 2, 1)) - 15) %23);
                  SET @VAL3 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 4, 1)) - 2) %23);
                  SET @VAL4 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 1, 1)) - 10) %23);
                  SET @VAL5 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 6, 1)) - 2) %23);
                  SET @VAL6 = ABS((CHARINDEX(@Code, SUBSTRING(@Code, 3, 1)) - 16) % 23);
                END
              END
            END
          END
        END
      END
    END
  END

  SET @MAX_INDEX = (((((((((@VAL6 * 23) + @VAL5) * 23) + @VAL4) * 23) + @VAL3) * 23) + @VAL2) * 23) + @VAL1;

  SELECT @MAX_INDEX,@VAL1,@VAL2,@VAL3,@VAL4,@VAL5,@VAL6;
  IF (select COUNT(*) from [dbo].[Codes]) >= @MAX_INDEX
  BEGIN
    set @IsValid=1;
    Select @IsValid;
  END
  ELSE
  BEGIN
    SET @IsValid=0;
    SELECT @IsValid;
  END
END
else
BEGIN
  SET @IsValid=0;
  SELECT @IsValid;
END
End
