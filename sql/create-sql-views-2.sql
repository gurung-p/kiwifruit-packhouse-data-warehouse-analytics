
-- Create VIEWS for Packhouse_DW (Part 2)

/*==========================================================
1. view_SeasonSummary: High‑level season KPIs (executive dashboard)
============================================================*/

DROP VIEW IF EXISTS view_SeasonSummary;
GO

CREATE VIEW view_SeasonSummary AS
SELECT
    d.YearNumber AS Season,
    SUM(fp.TrayCount) AS TotalTrays,
    SUM(fp.PackedKg) AS TotalKg,
    AVG(fq.Brix) AS AvgBrix,
    AVG(fq.DryMatter) AS AvgDryMatter,
    SUM(fd.DurationMinutes) AS TotalDowntime
FROM fact.FactPacking fp
JOIN dim.DimDate d ON fp.DateKey = d.DateKey
LEFT JOIN fact.FactQC fq ON fq.DateKey = fp.DateKey
LEFT JOIN fact.FactDowntime fd ON fd.DateKey = fp.DateKey
GROUP BY d.YearNumber;
GO


/*===========================================================
2. view_GrowerSeasonTrend (Grower performance over time)
=============================================================*/

CREATE VIEW view_GrowerSeasonTrend AS
SELECT
    g.GrowerName,
    d.YearNumber AS Season,
    SUM(fp.TrayCount) AS TotalTrays,
    SUM(fp.PackedKg) AS TotalKg,
    AVG(fq.Brix) AS AvgBrix,
    AVG(fq.DryMatter) AS AvgDryMatter
FROM fact.FactPacking fp
JOIN dim.DimGrower g ON fp.GrowerSK = g.GrowerSK
JOIN dim.DimDate d ON fp.DateKey = d.DateKey
LEFT JOIN fact.FactQC fq ON fq.GrowerSK = g.GrowerSK AND fq.DateKey = fp.DateKey
GROUP BY g.GrowerName, d.YearNumber;
GO


/*==========================================================
3. view_VarietySeasonTrend (Variety performance across seasons)
============================================================*/

CREATE VIEW view_VarietySeasonTrend AS
SELECT
    v.VarietyName,
    d.YearNumber AS Season,
    SUM(fp.TrayCount) AS TotalTrays,
    SUM(fp.PackedKg) AS TotalKg,
    AVG(fq.Brix) AS AvgBrix,
    AVG(fq.DryMatter) AS AvgDryMatter
FROM fact.FactPacking fp
JOIN dim.DimVariety v ON fp.VarietySK = v.VarietySK
JOIN dim.DimDate d ON fp.DateKey = d.DateKey
LEFT JOIN fact.FactQC fq ON fq.VarietySK = v.VarietySK AND fq.DateKey = fp.DateKey
GROUP BY v.VarietyName, d.YearNumber;
GO


/*==========================================================
4. view_PacklineShiftPerformance
============================================================*/

DROP VIEW IF EXISTS view_PacklineShiftPerformance;
GO

CREATE VIEW view_PacklineShiftPerformance AS
SELECT
    fp.DateKey,
    d.FullDate,
    fp.PackLineSK,
    pl.PackLineName,
    CASE 
        WHEN DATEPART(HOUR, fp.CreatedDateTime) BETWEEN 6 AND 14 THEN 'Day'
        ELSE 'Night'
    END AS Shift,
    SUM(fp.TrayCount) AS TotalTrays,
    SUM(fp.PackedKg) AS TotalKg
FROM fact.FactPacking fp
JOIN dim.DimDate d ON fp.DateKey = d.DateKey
JOIN dim.DimPackLine pl ON fp.PackLineSK = pl.PackLineSK
GROUP BY fp.DateKey, d.FullDate, fp.PackLineSK, pl.PackLineName,
         CASE 
            WHEN DATEPART(HOUR, fp.CreatedDateTime) BETWEEN 6 AND 14 THEN 'Day'
            ELSE 'Night'
         END;
GO



/*==========================================================
5. view_QC_DefectHeatmap (Defects by grower × variety × packline)
============================================================*/

CREATE VIEW view_QC_DefectHeatmap AS
SELECT
    g.GrowerName,
    v.VarietyName,
    pl.PackLineName,
    fq.DefectCode,
    SUM(fq.DefectCount) AS TotalDefects
FROM fact.FactQC fq
JOIN dim.DimGrower g ON fq.GrowerSK = g.GrowerSK
JOIN dim.DimVariety v ON fq.VarietySK = v.VarietySK
JOIN dim.DimPackLine pl ON fq.PackLineSK = pl.PackLineSK
GROUP BY g.GrowerName, v.VarietyName, pl.PackLineName, fq.DefectCode;
GO


/*==========================================================
6. view_QC_MaturityCompliance (Checks if Brix/DM meet minimum thresholds)
============================================================*/

CREATE VIEW view_QC_MaturityCompliance AS
SELECT
    fq.DateKey,
    d.FullDate,
    fq.GrowerSK,
    g.GrowerName,
    fq.VarietySK,
    v.VarietyName,
    fq.Brix,
    fq.DryMatter,
    CASE WHEN fq.Brix >= 6.5 THEN 1 ELSE 0 END AS BrixPass,
    CASE WHEN fq.DryMatter >= 15 THEN 1 ELSE 0 END AS DMPass
FROM fact.FactQC fq
JOIN dim.DimDate d ON fq.DateKey = d.DateKey
JOIN dim.DimGrower g ON fq.GrowerSK = g.GrowerSK
JOIN dim.DimVariety v ON fq.VarietySK = v.VarietySK;
GO


/*==========================================================
7. view_PalletAgeing (pallets duration in coolstore)
============================================================*/

DROP VIEW IF EXISTS view_PalletAgeing;
GO

CREATE VIEW view_PalletAgeing AS
WITH Movements AS (
    SELECT
        fc.PalletNumber,
        d.FullDate,
        fc.MovementType
    FROM fact.FactCoolstore fc
    JOIN dim.DimDate d ON fc.DateKey = d.DateKey
),

InOut AS (
    SELECT
        PalletNumber,
        MIN(CASE WHEN MovementType = 'In' THEN FullDate END) AS InDate,
        MIN(CASE WHEN MovementType = 'Out' THEN FullDate END) AS OutDate
    FROM Movements
    GROUP BY PalletNumber
)

SELECT
    PalletNumber,
    InDate AS FirstSeen,
    COALESCE(OutDate, CAST(GETDATE() AS DATE)) AS LastSeen,
    DATEDIFF(
        DAY,
        InDate,
        COALESCE(OutDate, CAST(GETDATE() AS DATE))
    ) AS DaysInCoolstore
FROM InOut
WHERE InDate IS NOT NULL;
GO


/*==========================================================
8. view_CoolstoreOccupancy (Daily occupancy levels)
============================================================*/

DROP VIEW IF EXISTS view_CoolstoreOccupancy;
GO

CREATE VIEW view_CoolstoreOccupancy AS
SELECT
    fc.DateKey,
    d.FullDate,
    fc.CoolstoreDimSK,
    cs.CoolstoreName,
    COUNT(DISTINCT fc.PalletNumber) AS PalletsPresent
FROM fact.FactCoolstore fc
JOIN dim.DimDate d ON fc.DateKey = d.DateKey
JOIN dim.DimCoolstore cs ON fc.CoolstoreDimSK = cs.CoolstoreSK
GROUP BY fc.DateKey, d.FullDate, fc.CoolstoreDimSK, cs.CoolstoreName;
GO


/*==========================================================
9. view_PacklineOEE_Daily (Daily OEE breakdown)
============================================================*/

CREATE VIEW view_PacklineOEE_Daily AS
SELECT
    fp.DateKey,
    d.FullDate,
    pl.PackLineName,
    SUM(fp.TrayCount) AS TotalTrays,
    SUM(fd.DurationMinutes) AS DowntimeMinutes,
    SUM(CASE WHEN fq.DefectCount = 0 THEN 1 ELSE 0 END) * 1.0 /
        NULLIF(COUNT(fq.QCSK), 0) AS QualityRate
FROM fact.FactPacking fp
JOIN dim.DimPackLine pl ON fp.PackLineSK = pl.PackLineSK
JOIN dim.DimDate d ON fp.DateKey = d.DateKey
LEFT JOIN fact.FactDowntime fd ON fd.PackLineSK = fp.PackLineSK AND fd.DateKey = fp.DateKey
LEFT JOIN fact.FactQC fq ON fq.PackLineSK = fp.PackLineSK AND fq.DateKey = fp.DateKey
GROUP BY fp.DateKey, d.FullDate, pl.PackLineName;
GO


/*==========================================================
10. view_GrowerScorecard (Combines yield + quality + maturity)
============================================================*/

CREATE VIEW view_GrowerScorecard AS
SELECT
    g.GrowerName,
    SUM(fp.TrayCount) AS TotalTrays,
    AVG(fq.Brix) AS AvgBrix,
    AVG(fq.DryMatter) AS AvgDryMatter,
    SUM(CASE WHEN fq.DefectCount = 0 THEN 1 ELSE 0 END) * 1.0 /
        NULLIF(COUNT(fq.QCSK), 0) AS PassRate
FROM fact.FactPacking fp
JOIN dim.DimGrower g ON fp.GrowerSK = g.GrowerSK
LEFT JOIN fact.FactQC fq ON fq.GrowerSK = g.GrowerSK AND fq.DateKey = fp.DateKey
GROUP BY g.GrowerName;
GO


/*==========================================================
11. view_PacklineBottlenecks
Identifies hours with low throughput or high downtime
============================================================*/

CREATE VIEW view_PacklineBottlenecks AS
SELECT
    fp.PackLineSK,
    pl.PackLineName,
    DATEPART(HOUR, fp.CreatedDateTime) AS HourOfDay,
    SUM(fp.TrayCount) AS Trays,
    SUM(fd.DurationMinutes) AS Downtime
FROM fact.FactPacking fp
LEFT JOIN fact.FactDowntime fd ON fd.PackLineSK = fp.PackLineSK AND fd.DateKey = fp.DateKey
JOIN dim.DimPackLine pl ON fp.PackLineSK = pl.PackLineSK
GROUP BY fp.PackLineSK, pl.PackLineName, DATEPART(HOUR, fp.CreatedDateTime);
GO


/*==========================================================
12. view_PackingGradeSummary
Packing summary
============================================================*/

CREATE VIEW view_PackingGradeSummary AS
SELECT
      fp.DateKey
    , d.FullDate        AS Date
    , fp.PackLineSK
    , pl.PackLineName
    , fp.GrowerSK
    , g.GrowerCode
    , g.GrowerName
    , fp.BlockSK
    , b.BlockCode
    , b.Hectares
    , fp.VarietySK
    , v.VarietyCode
    , v.VarietyName

    -- Fact attributes
    , fp.Class
    , fp.Grade

    -- Measures
    , SUM(fp.TrayCount) AS TotalTrays
    , SUM(fp.PackedKg)  AS TotalPackedKg

FROM fact.FactPacking fp
LEFT JOIN dim.DimDate      d  ON fp.DateKey     = d.DateKey
LEFT JOIN dim.DimPackLine  pl ON fp.PackLineSK  = pl.PackLineSK
LEFT JOIN dim.DimGrower    g  ON fp.GrowerSK    = g.GrowerSK AND g.IsCurrent = 1
LEFT JOIN dim.DimBlock     b  ON fp.BlockSK     = b.BlockSK  AND b.IsCurrent = 1
LEFT JOIN dim.DimVariety   v  ON fp.VarietySK   = v.VarietySK

GROUP BY
      fp.DateKey
    , d.FullDate
    , fp.PackLineSK
    , pl.PackLineName
    , fp.GrowerSK
    , g.GrowerCode
    , g.GrowerName
    , fp.BlockSK
    , b.BlockCode
    , b.Hectares
    , fp.VarietySK
    , v.VarietyCode
    , v.VarietyName
    , fp.Class
    , fp.Grade;

GO