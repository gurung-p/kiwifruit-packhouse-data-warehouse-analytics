/* ============================================================
   PACKHOUSE DATA WAREHOUSE (Packhouse_DW) - DATABASE CREATION
   Author: PG
   ============================================================ */

IF DB_ID('Packhouse_DW') IS NOT NULL
BEGIN
    ALTER DATABASE Packhouse_DW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Packhouse_DW;
END;
GO

CREATE DATABASE Packhouse_DW;
GO

USE Packhouse_DW;
GO


/* ============================================================
   SCHEMA CREATION
   ============================================================ */

CREATE SCHEMA dim AUTHORIZATION dbo;
GO

CREATE SCHEMA fact AUTHORIZATION dbo;
GO

CREATE SCHEMA ref AUTHORIZATION dbo;
GO


/* ============================================================
   DIMENSIONS (SCD2 where appropriate)
   ============================================================ */

---------------------------------------------------------------
-- DimDate (Standard DW Date Dimension)
---------------------------------------------------------------
CREATE TABLE dim.DimDate (
    DateKey            INT         NOT NULL PRIMARY KEY,  -- YYYYMMDD
    FullDate           DATE        NOT NULL,
    DayNumberOfWeek    TINYINT     NOT NULL,
    DayNameOfWeek      VARCHAR(20) NOT NULL,
    DayOfMonth         TINYINT     NOT NULL,
    DayOfYear          SMALLINT    NOT NULL,
    WeekOfYear         TINYINT     NOT NULL,
    MonthNumber        TINYINT     NOT NULL,
    MonthName          VARCHAR(20) NOT NULL,
    QuarterNumber      TINYINT     NOT NULL,
    YearNumber         SMALLINT    NOT NULL
);
GO


---------------------------------------------------------------
-- DimGrower (SCD2)
---------------------------------------------------------------
CREATE TABLE dim.DimGrower (
    GrowerSK           INT IDENTITY(1,1) PRIMARY KEY,
    GrowerCode         VARCHAR(20) NOT NULL,
    GrowerName         VARCHAR(200) NOT NULL,
    Region             VARCHAR(100) NULL,
    ActiveFlag         BIT NOT NULL DEFAULT 1,
    EffectiveFrom      DATETIME2 NOT NULL,
    EffectiveTo        DATETIME2 NULL,
    IsCurrent          BIT NOT NULL
);
GO


---------------------------------------------------------------
-- DimBlock (SCD2)
---------------------------------------------------------------
CREATE TABLE dim.DimBlock (
    BlockSK            INT IDENTITY(1,1) PRIMARY KEY,
    GrowerCode         VARCHAR(20) NOT NULL,
    BlockCode          VARCHAR(20) NOT NULL,
    VarietyCode        VARCHAR(20) NOT NULL,
    Hectares           DECIMAL(10,2) NULL,
    OrchardRegion      VARCHAR(100) NULL,
    EffectiveFrom      DATETIME2 NOT NULL,
    EffectiveTo        DATETIME2 NULL,
    IsCurrent          BIT NOT NULL
);
GO


---------------------------------------------------------------
-- DimVariety
---------------------------------------------------------------
CREATE TABLE dim.DimVariety (
    VarietySK          INT IDENTITY(1,1) PRIMARY KEY,
    VarietyCode        VARCHAR(20) NOT NULL,
    VarietyName        VARCHAR(100) NOT NULL,
    Colour             VARCHAR(20) NULL,
    MaturityGroup      VARCHAR(20) NULL
);
GO


---------------------------------------------------------------
-- DimPackLine
---------------------------------------------------------------
CREATE TABLE dim.DimPackLine (
    PackLineSK         INT IDENTITY(1,1) PRIMARY KEY,
    PackLineCode       VARCHAR(20) NOT NULL,
    PackLineName       VARCHAR(100) NOT NULL,
    Site               VARCHAR(50) NOT NULL
);
GO


---------------------------------------------------------------
-- DimCoolstore
---------------------------------------------------------------
CREATE TABLE dim.DimCoolstore (
    CoolstoreSK        INT IDENTITY(1,1) PRIMARY KEY,
    CoolstoreCode      VARCHAR(20) NOT NULL,
    CoolstoreName      VARCHAR(100) NOT NULL,
    Site               VARCHAR(50) NOT NULL
);
GO


---------------------------------------------------------------
-- DimCustomer
---------------------------------------------------------------
CREATE TABLE dim.DimCustomer (
    CustomerSK         INT IDENTITY(1,1) PRIMARY KEY,
    CustomerCode       VARCHAR(20) NOT NULL,
    CustomerName       VARCHAR(200) NOT NULL,
    Market             VARCHAR(50) NULL
);
GO


/* ============================================================
   FACT TABLES
   ============================================================ */

---------------------------------------------------------------
-- FactPacking (PackRun, PackBatch, PackResult)
---------------------------------------------------------------
CREATE TABLE fact.FactPacking (
    PackingSK          BIGINT IDENTITY(1,1) PRIMARY KEY,
    DateKey            INT NOT NULL,
    PackLineSK         INT NOT NULL,
    GrowerSK           INT NOT NULL,
    BlockSK            INT NOT NULL,
    VarietySK          INT NOT NULL,
    RunNumber          INT NOT NULL,
    BatchNumber        INT NOT NULL,
    Class              VARCHAR(20) NOT NULL,
    Grade              VARCHAR(20) NOT NULL,
    TrayCount          INT NOT NULL,
    PackedKg           DECIMAL(12,3) NOT NULL,
    CreatedDateTime    DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_FactPacking_Date FOREIGN KEY (DateKey) REFERENCES dim.DimDate(DateKey),
    CONSTRAINT FK_FactPacking_PackLine FOREIGN KEY (PackLineSK) REFERENCES dim.DimPackLine(PackLineSK),
    CONSTRAINT FK_FactPacking_Grower FOREIGN KEY (GrowerSK) REFERENCES dim.DimGrower(GrowerSK),
    CONSTRAINT FK_FactPacking_Block FOREIGN KEY (BlockSK) REFERENCES dim.DimBlock(BlockSK),
    CONSTRAINT FK_FactPacking_Variety FOREIGN KEY (VarietySK) REFERENCES dim.DimVariety(VarietySK)
);
GO


---------------------------------------------------------------
-- FactQC (QC: Defects, Samples, Brix, Dry Matter)
---------------------------------------------------------------
CREATE TABLE fact.FactQC (
    QCSK               BIGINT IDENTITY(1,1) PRIMARY KEY,
    DateKey            INT NOT NULL,
    PackLineSK         INT NOT NULL,
    GrowerSK           INT NOT NULL,
    BlockSK            INT NOT NULL,
    VarietySK          INT NOT NULL,
    SampleNumber       INT NOT NULL,
    DefectCode         VARCHAR(20) NOT NULL,
    DefectCount        INT NOT NULL,
    Brix               DECIMAL(5,2) NULL,
    DryMatter          DECIMAL(5,2) NULL,
    Pressure           DECIMAL(5,2) NULL,

    CONSTRAINT FK_FactQC_Date FOREIGN KEY (DateKey) REFERENCES dim.DimDate(DateKey),
    CONSTRAINT FK_FactQC_PackLine FOREIGN KEY (PackLineSK) REFERENCES dim.DimPackLine(PackLineSK),
    CONSTRAINT FK_FactQC_Grower FOREIGN KEY (GrowerSK) REFERENCES dim.DimGrower(GrowerSK),
    CONSTRAINT FK_FactQC_Block FOREIGN KEY (BlockSK) REFERENCES dim.DimBlock(BlockSK),
    CONSTRAINT FK_FactQC_Variety FOREIGN KEY (VarietySK) REFERENCES dim.DimVariety(VarietySK)
);
GO


---------------------------------------------------------------
-- FactPallet (Palletisation)
---------------------------------------------------------------
CREATE TABLE fact.FactPallet (
    PalletSK           BIGINT IDENTITY(1,1) PRIMARY KEY,
    DateKey            INT NOT NULL,
    PackLineSK         INT NOT NULL,
    GrowerSK           INT NOT NULL,
    BlockSK            INT NOT NULL,
    VarietySK          INT NOT NULL,
    CustomerSK         INT NULL,
    PalletNumber       VARCHAR(50) NOT NULL,
    TrayCount          INT NOT NULL,
    NetKg              DECIMAL(12,3) NOT NULL,
    Status             VARCHAR(20) NOT NULL,  -- e.g., Packed, Loaded, Shipped

    CONSTRAINT FK_FactPallet_Date FOREIGN KEY (DateKey) REFERENCES dim.DimDate(DateKey),
    CONSTRAINT FK_FactPallet_PackLine FOREIGN KEY (PackLineSK) REFERENCES dim.DimPackLine(PackLineSK),
    CONSTRAINT FK_FactPallet_Grower FOREIGN KEY (GrowerSK) REFERENCES dim.DimGrower(GrowerSK),
    CONSTRAINT FK_FactPallet_Block FOREIGN KEY (BlockSK) REFERENCES dim.DimBlock(BlockSK),
    CONSTRAINT FK_FactPallet_Variety FOREIGN KEY (VarietySK) REFERENCES dim.DimVariety(VarietySK),
    CONSTRAINT FK_FactPallet_Customer FOREIGN KEY (CustomerSK) REFERENCES dim.DimCustomer(CustomerSK)
);
GO


---------------------------------------------------------------
-- FactCoolstore (Coolstore Movements)
---------------------------------------------------------------
CREATE TABLE fact.FactCoolstore (
    CoolstoreSK        BIGINT IDENTITY(1,1) PRIMARY KEY,
    DateKey            INT NOT NULL,
    CoolstoreDimSK     INT NOT NULL,
    PalletNumber       VARCHAR(50) NOT NULL,
    MovementType       VARCHAR(20) NOT NULL,  -- In, Out, Relocate
    Temperature        DECIMAL(5,2) NULL,
    Humidity           DECIMAL(5,2) NULL,

    CONSTRAINT FK_FactCoolstore_Date FOREIGN KEY (DateKey) REFERENCES dim.DimDate(DateKey),
    CONSTRAINT FK_FactCoolstore_Coolstore FOREIGN KEY (CoolstoreDimSK) REFERENCES dim.DimCoolstore(CoolstoreSK)
);
GO


---------------------------------------------------------------
-- FactDowntime (Line Downtime)
---------------------------------------------------------------
CREATE TABLE fact.FactDowntime (
    DowntimeSK         BIGINT IDENTITY(1,1) PRIMARY KEY,
    DateKey            INT NOT NULL,
    PackLineSK         INT NOT NULL,
    ReasonCode         VARCHAR(20) NOT NULL,
    DurationMinutes    INT NOT NULL,
    Comment            VARCHAR(500) NULL,

    CONSTRAINT FK_FactDowntime_Date FOREIGN KEY (DateKey) REFERENCES dim.DimDate(DateKey),
    CONSTRAINT FK_FactDowntime_PackLine FOREIGN KEY (PackLineSK) REFERENCES dim.DimPackLine(PackLineSK)
);
GO


/* ============================================================
   REFERENCE TABLES (Codes)
   ============================================================ */

CREATE TABLE ref.RefDefect (
    DefectCode         VARCHAR(20) PRIMARY KEY,
    DefectDescription  VARCHAR(200) NOT NULL,
    Severity           VARCHAR(20) NULL
);
GO


CREATE TABLE ref.RefDowntimeReason (
    ReasonCode         VARCHAR(20) PRIMARY KEY,
    ReasonDescription  VARCHAR(200) NOT NULL
);
GO
