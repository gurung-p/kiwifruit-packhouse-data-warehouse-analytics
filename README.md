# Kiwifruit Packhouse Data Warehouse & Analytics

A complete end‑to‑end **data warehouse and analytics project** for kiwifruit packhouse operations.  
Built using **SQL Server**, **Power BI**, and a full set of dimensional models covering packing, QC, pallets, coolstore movements, and downtime.  
Includes a beginner‑friendly glossary explaining key post‑harvest concepts such as **Brix**, **Dry Matter**, **firmness**, and **coolstore conditions**.

---

## Project Overview

This project models the operational workflow of a New Zealand kiwifruit packhouse, from orchard intake through packing, QC, palletisation, coolstore storage, and line downtime.  
It demonstrates real‑world **data engineering**, **data warehousing**, and **business intelligence** practices using industry‑aligned structures and terminology.

---

## Key Features

- **SQL Server Data Warehouse**
  - Star‑schema dimensional model
  - SCD2 dimensions (Grower, Block)
  - Fact tables for Packing, QC, Pallets, Coolstore, Downtime

- **Analytical SQL Views**
  - Production metrics  
  - QC performance  
  - Coolstore inventory  
  - Line efficiency & downtime  

- **Power BI Dashboards**
  - Packing performance  
  - QC defect trends  
  - Coolstore movements & inventory  
  - Operational downtime analysis  

- **Beginner‑Friendly Glossary**
  - Explains horticulture and post‑harvest terms  
  - Ideal for readers with no kiwifruit industry background  
  - Includes ideal values for Brix, Dry Matter, Pressure, etc.

---

## Data Warehouse Schema

### **Dimensions**
- `DimDate` – Standard date dimension  
- `DimGrower` – SCD2 grower attributes  
- `DimBlock` – SCD2 orchard block attributes  
- `DimVariety` – Kiwifruit varieties  
- `DimPackLine` – Packing line metadata  
- `DimCoolstore` – Coolstore rooms  
- `DimCustomer` – Export customers  

### **Fact Tables**
- `FactPacking` – Packing runs, grades, classes, volumes  
- `FactQC` – Defects, Brix, Dry Matter, Pressure  
- `FactPallet` – Palletisation and shipment status  
- `FactCoolstore` – In/Out/Relocate movements  
- `FactDowntime` – Line downtime events  

---

## Glossary

A full glossary explaining all packhouse, QC, and coolstore terminology is available here:

👉 **[Glossary.md](Glossary.md)**

| Term | Meaning | Ideal / Typical Values | Source (Schema) |
|------|---------|------------------------|------------------|
| GrowerCode | Unique identifier for a grower supplying fruit. | N/A | “GrowerCode varchar(20)” |
| BlockCode | Identifier for an orchard block. | N/A | “BlockCode varchar(20)” |
| VarietyCode / VarietyName | Identifies kiwifruit variety (e.g., Hayward, SunGold). | N/A | “VarietyName varchar(100)” |
| TrayCount | Number of trays packed or on a pallet. | 100–120 trays per pallet (typical) | “TrayCount int” |
| PackedKg / TotalKg | Total kilograms packed or produced. | 600–900 kg per pallet (typical) | “PackedKg decimal” |
| MovementType | Coolstore movement: In, Out, Relocate. | N/A | “MovementType varchar(20)” |
| Temperature | Coolstore temperature reading (°C). | **0–1°C** | “Temperature decimal” |
| Humidity | Coolstore humidity (%RH). | **90–95% RH** | “Humidity decimal” |
| PalletNumber | Unique pallet identifier. | N/A | “PalletNumber varchar(50)” |
| DaysInCoolstore | How long a pallet has been stored. | As low as possible | “DaysInCoolstore int” |
| DefectCode | QC defect type (e.g., blemish, rot). | N/A | “DefectCode varchar(20)” |
| DefectCount / TotalDefects | Number of defects found in QC sample. | As low as possible | “DefectCount int” |
| Brix | Sugar level of fruit (°Bx). | **6.5–7.5+ at harvest** | “Brix decimal” |
| DryMatter | Percentage of solids; key flavour predictor. | **16–18%+** | “DryMatter decimal” |
| Pressure | Fruit firmness (kgf). | **6–8 kgf at harvest** | “Pressure decimal” |
| PassFailStatus | Whether QC sample passed maturity rules. | Pass | “PassFailStatus varchar(4)” |
| QualityScore | Numeric score summarising quality. | Higher = better | “QualityScore numeric” |
| ReasonCode | Downtime reason (mechanical, labour, cleaning). | N/A | “ReasonCode varchar(20)” |
| DurationMinutes | Length of downtime event. | As low as possible | “DurationMinutes int” |
| QualityRate | QC pass rate for OEE. | >90% preferred | “QualityRate numeric” |
| PalletCount | Number of pallets produced or stored. | N/A | “PalletCount int” |
| AvgBrix / AvgDryMatter | Average maturity metrics. | Brix 6.5–7.5+, DM 16–18%+ | “AvgBrix decimal” |


---

## 📊 Power BI Dashboards

The project includes dashboard designs for:

- Packing throughput & efficiency  
- QC sampling & defect trends  
- Coolstore inventory & movement tracking  
- Downtime analysis & line performance  

These dashboards help visualise operational performance across the packhouse workflow.

---

##Technologies Used

- **SQL Server** (Data Warehouse)
- **T‑SQL** (ETL, SCD2 logic, analytical views)
- **Power BI** (Dashboards & reporting)
- **Markdown** (Documentation)
- **GitHub** (Version control & portfolio)

---

## Purpose of This Project

This repository is designed to:

- Demonstrate **real‑world data engineering skills**
- Showcase **data warehouse modelling** in a production‑like scenario
- Provide **analytics and BI examples** using Power BI
- Help non‑technical readers understand packhouse operations through clear documentation

---

## 📁 Repository Structure

