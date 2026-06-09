
-- Create VIEWS for Packhouse_DW (Part 1)

/*==========================================================
1. view_Date
============================================================*/

CREATE VIEW view_Date AS
SELECT *
FROM dim.DimDate;
GO


/*===========================================================
2. view_PacklineDailyThroughput (Trays + KG per packline per day)
=============================================================*/

CREATE VIEW view_PacklineDailyThroughput AS
SELECT 
    fp.DateKey,
    d.FullDate,
    fp.PackLineSK,
    pl.PackLineName,
    SUM(fp.TrayCount) AS TotalTrays,
    SUM(fp.PackedKg) AS TotalKg
FROM fact.FactPacking fp
JOIN dim.DimDate d ON fp.DateKey = d.DateKey
JOIN dim.DimPackLine pl ON fp.PackLineSK = pl.PackLineSK
GROUP BY fp.DateKey, d.FullDate, fp.PackLineSK, pl.PackLineName;
GO


/*==========================================================
3. view_PacklineHourlyThroughput (hourly throughput)
============================================================*/

CREATE VIEW view_PacklineHourlyThroughput AS
SELECT 
    fp.DateKey,
    d.FullDate,
    DATEPART(HOUR, fp.CreatedDateTime) AS HourOfDay,
    fp.PackLineSK,
    pl.PackLineName,
    SUM(fp.TrayCount) AS TraysPerHour,
    SUM(fp.PackedKg) AS KgPerHour
FROM fact.FactPacking fp
JOIN dim.DimDate d ON fp.DateKey = d.DateKey
JOIN dim.DimPackLine pl ON fp.PackLineSK = pl.PackLineSK
GROUP BY fp.DateKey, d.FullDate, DATEPART(HOUR, fp.CreatedDateTime),
         fp.PackLineSK, pl.PackLineName;
GO


/*==========================================================
4. view_GrowerPerformance (Grower‑level packout summary)
============================================================*/

CREATE VIEW view_GrowerPerformance AS
SELECT 
    g.GrowerCode,
    g.GrowerName,
    SUM(fp.TrayCount) AS TotalTrays,
    SUM(fp.PackedKg) AS TotalKg,
    COUNT(DISTINCT fp.BlockSK) AS BlocksPacked
FROM fact.FactPacking fp
JOIN dim.DimGrower g ON fp.GrowerSK = g.GrowerSK
GROUP BY g.GrowerCode, g.GrowerName;
GO


/*==========================================================
5. view_BlockPerformance (Block‑level yield and packout)
============================================================*/

CREATE VIEW view_BlockPerformance AS
SELECT 
    b.GrowerCode,
    b.BlockCode,
    b.VarietyCode,
    SUM(fp.TrayCount) AS TotalTrays,
    SUM(fp.PackedKg) AS TotalKg
FROM fact.FactPacking fp
JOIN dim.DimBlock b ON fp.BlockSK = b.BlockSK
GROUP BY b.GrowerCode, b.BlockCode, b.VarietyCode;
GO


/*==========================================================
6. view_VarietyPerformance (Variety‑level packout)
============================================================*/

CREATE VIEW view_VarietyPerformance AS
SELECT 
    v.VarietyCode,
    v.VarietyName,
    SUM(fp.TrayCount) AS TotalTrays,
    SUM(fp.PackedKg) AS TotalKg
FROM fact.FactPacking fp
JOIN dim.DimVariety v ON fp.VarietySK = v.VarietySK
GROUP BY v.VarietyCode, v.VarietyName;
GO


/*==========================================================
7. view_QC_DefectSummary (Defect counts + defect rate)
============================================================*/

CREATE VIEW view_QC_DefectSummary AS
SELECT 
    fq.DateKey,
    d.FullDate,
    fq.PackLineSK,
    pl.PackLineName,
    fq.DefectCode,
    rd.DefectDescription,
    SUM(fq.DefectCount) AS TotalDefects,
    COUNT(*) AS Samples,
    SUM(fq.DefectCount) * 1.0 / NULLIF(COUNT(*), 0) AS DefectsPerSample
FROM fact.FactQC fq
JOIN dim.DimDate d ON fq.DateKey = d.DateKey
JOIN dim.DimPackLine pl ON fq.PackLineSK = pl.PackLineSK
JOIN ref.RefDefect rd ON fq.DefectCode = rd.DefectCode
GROUP BY fq.DateKey, d.FullDate, fq.PackLineSK, pl.PackLineName,
         fq.DefectCode, rd.DefectDescription;
GO


/*==========================================================
8. view_QC_MaturitySummary (Brix, Dry Matter, Pressure)
============================================================*/

CREATE VIEW view_QC_MaturitySummary AS
SELECT 
    fq.DateKey,
    d.FullDate,
    fq.PackLineSK,
    pl.PackLineName,
    AVG(fq.Brix) AS AvgBrix,
    AVG(fq.DryMatter) AS AvgDryMatter,
    AVG(fq.Pressure) AS AvgPressure
FROM fact.FactQC fq
JOIN dim.DimDate d ON fq.DateKey = d.DateKey
JOIN dim.DimPackLine pl ON fq.PackLineSK = pl.PackLineSK
GROUP BY fq.DateKey, d.FullDate, fq.PackLineSK, pl.PackLineName;
GO


/*==========================================================
9. view_CoolstoreMovements (In / Out / Relocate counts)
============================================================*/

CREATE VIEW view_CoolstoreMovements AS
SELECT 
    fc.DateKey,
    d.FullDate,
    fc.CoolstoreDimSK,
    cs.CoolstoreName,
    fc.MovementType,
    COUNT(*) AS MovementCount,
    AVG(fc.Temperature) AS AvgTemp,
    AVG(fc.Humidity) AS AvgHumidity
FROM fact.FactCoolstore fc
JOIN dim.DimDate d ON fc.DateKey = d.DateKey
JOIN dim.DimCoolstore cs ON fc.CoolstoreDimSK = cs.CoolstoreSK
GROUP BY fc.DateKey, d.FullDate, fc.CoolstoreDimSK, cs.CoolstoreName, fc.MovementType;
GO


/*==========================================================
10. view_PalletSummary (Palletisation metrics)
============================================================*/

CREATE VIEW view_PalletSummary AS
SELECT 
    fp.DateKey,
    d.FullDate,
    fp.PackLineSK,
    pl.PackLineName,
    COUNT(*) AS PalletCount,
    SUM(fp.TrayCount) AS TotalTrays,
    SUM(fp.NetKg) AS TotalKg
FROM fact.FactPallet fp
JOIN dim.DimDate d ON fp.DateKey = d.DateKey
JOIN dim.DimPackLine pl ON fp.PackLineSK = pl.PackLineSK
GROUP BY fp.DateKey, d.FullDate, fp.PackLineSK, pl.PackLineName;
GO


/*==========================================================
11. view_DowntimeSummary (Downtime minutes per reason)
============================================================*/

CREATE VIEW view_DowntimeSummary AS
SELECT 
    fd.DateKey,
    d.FullDate,
    fd.PackLineSK,
    pl.PackLineName,
    fd.ReasonCode,
    rr.ReasonDescription,
    SUM(fd.DurationMinutes) AS TotalMinutes
FROM fact.FactDowntime fd
JOIN dim.DimDate d ON fd.DateKey = d.DateKey
JOIN dim.DimPackLine pl ON fd.PackLineSK = pl.PackLineSK
JOIN ref.RefDowntimeReason rr ON fd.ReasonCode = rr.ReasonCode
GROUP BY fd.DateKey, d.FullDate, fd.PackLineSK, pl.PackLineName,
         fd.ReasonCode, rr.ReasonDescription;
GO


/*==========================================================
12. view_OEE (Availability, Performance, Quality)

Overall Equipment Effectiveness - measure packline effectiveness based on:
a. Availability = Scheduled time – downtime
b. Performance = Actual throughput vs target
c. Quality = % good fruit (no defects)
============================================================*/

CREATE VIEW view_OEE AS
SELECT 
    pl.PackLineName,
    fp.DateKey,
    d.FullDate,

    -- Availability
    SUM(fp.TrayCount) AS TotalTrays,
    SUM(fp.PackedKg) AS TotalKg,
    SUM(fd.DurationMinutes) AS DowntimeMinutes,

    -- Quality
    SUM(CASE WHEN fq.DefectCount = 0 THEN 1 ELSE 0 END) * 1.0 /
    NULLIF(COUNT(fq.QCSK), 0) AS QualityRate

FROM dim.DimPackLine pl
LEFT JOIN fact.FactPacking fp ON fp.PackLineSK = pl.PackLineSK
LEFT JOIN fact.FactDowntime fd ON fd.PackLineSK = pl.PackLineSK AND fd.DateKey = fp.DateKey
LEFT JOIN fact.FactQC fq ON fq.PackLineSK = pl.PackLineSK AND fq.DateKey = fp.DateKey
LEFT JOIN dim.DimDate d ON fp.DateKey = d.DateKey
GROUP BY pl.PackLineName, fp.DateKey, d.FullDate;
GO


/*==========================================================
13. view_MasterDashboard
============================================================*/

CREATE VIEW view_MasterDashboard AS
SELECT 
    d.FullDate,
    pl.PackLineName,
    g.GrowerName,
    v.VarietyName,
    b.BlockCode,

    fp.TrayCount,
    fp.PackedKg,

    fq.DefectCode,
    fq.DefectCount,
    fq.Brix,
    fq.DryMatter,
    fq.Pressure,

    fc.MovementType,
    fc.Temperature,
    fc.Humidity,

    fd.ReasonCode,
    fd.DurationMinutes

FROM fact.FactPacking fp
LEFT JOIN fact.FactQC fq ON fq.DateKey = fp.DateKey AND fq.PackLineSK = fp.PackLineSK
LEFT JOIN fact.FactCoolstore fc ON fc.DateKey = fp.DateKey
LEFT JOIN fact.FactDowntime fd ON fd.DateKey = fp.DateKey AND fd.PackLineSK = fp.PackLineSK

JOIN dim.DimDate d ON fp.DateKey = d.DateKey
JOIN dim.DimPackLine pl ON fp.PackLineSK = pl.PackLineSK
JOIN dim.DimGrower g ON fp.GrowerSK = g.GrowerSK
JOIN dim.DimVariety v ON fp.VarietySK = v.VarietySK
JOIN dim.DimBlock b ON fp.BlockSK = b.BlockSK;
GO


/*==========================================================
14. view_QC_PassFail

Pass/Fail Logic (industry‑standard):
a. FAIL if ANY defect count > 0
b. PASS if all defect counts = 0
============================================================*/

CREATE VIEW view_QC_PassFail AS
SELECT
    fq.QCSK,
    fq.DateKey,
    d.FullDate,
    fq.PackLineSK,
    pl.PackLineName,
    fq.GrowerSK,
    g.GrowerName,
    fq.BlockSK,
    b.BlockCode,
    fq.VarietySK,
    v.VarietyName,
    fq.SampleNumber,

    -- PASS = no defects
    CASE 
        WHEN SUM(fq.DefectCount) OVER (PARTITION BY fq.QCSK) > 0 
            THEN 'FAIL'
        ELSE 'PASS'
    END AS PassFailStatus,

    SUM(fq.DefectCount) OVER (PARTITION BY fq.QCSK) AS TotalDefects
FROM fact.FactQC fq
JOIN dim.DimDate d ON fq.DateKey = d.DateKey
JOIN dim.DimPackLine pl ON fq.PackLineSK = pl.PackLineSK
JOIN dim.DimGrower g ON fq.GrowerSK = g.GrowerSK
JOIN dim.DimBlock b ON fq.BlockSK = b.BlockSK
JOIN dim.DimVariety v ON fq.VarietySK = v.VarietySK;
GO


/*==========================================================
15. view_GrowerQualityScore (quality score based on QC results)

0–100 score, Higher = better quality
============================================================*/

CREATE VIEW view_GrowerQualityScore AS
WITH qc AS (
    SELECT
        fq.GrowerSK,
        g.GrowerName,
        fq.DateKey,
        CASE WHEN SUM(fq.DefectCount) OVER (PARTITION BY fq.QCSK) > 0 
             THEN 0 ELSE 1 END AS PassFlag
    FROM fact.FactQC fq
    JOIN dim.DimGrower g ON fq.GrowerSK = g.GrowerSK
)
SELECT
    GrowerSK,
    GrowerName,
    COUNT(*) AS TotalSamples,
    SUM(PassFlag) AS PassSamples,
    (SUM(PassFlag) * 1.0 / NULLIF(COUNT(*), 0)) * 100 AS QualityScore
FROM qc
GROUP BY GrowerSK, GrowerName;
GO


/*==========================================================
16. view_VarietyQualityScore 

Variety‑level quality for comparing SunGold vs Hayward vs RubyRed
============================================================*/

CREATE VIEW view_VarietyQualityScore AS
WITH qc AS (
    SELECT
        fq.VarietySK,
        v.VarietyName,
        fq.DateKey,
        CASE WHEN SUM(fq.DefectCount) OVER (PARTITION BY fq.QCSK) > 0 
             THEN 0 ELSE 1 END AS PassFlag
    FROM fact.FactQC fq
    JOIN dim.DimVariety v ON fq.VarietySK = v.VarietySK
)
SELECT
    VarietySK,
    VarietyName,
    COUNT(*) AS TotalSamples,
    SUM(PassFlag) AS PassSamples,
    (SUM(PassFlag) * 1.0 / NULLIF(COUNT(*), 0)) * 100 AS QualityScore
FROM qc
GROUP BY VarietySK, VarietyName;
GO