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

## Data Warehouse Schema Overview

### **Dimensions**

- `DimDate` – Standard date dimension for calendar attributes 
- `DimGrower` –  SCD2 grower attributes (code, name, region, active status)
- `DimBlock` – SCD2 orchard block attributes (block, grower, variety, hectares, region)  
- `DimVariety` –  Kiwifruit varieties and maturity groups
- `DimPackLine` – Packing line metadata (line name, site)
- `DimCoolstore` – Coolstore rooms and site information
- `DimCustomer` – Export customer and market attributes

### **Fact Tables**
- `FactPacking` – Packing runs, grades, classes, tray counts, packed kg
- `FactQC` – QC sampling results: defects, Brix, Dry Matter, Pressure
- `FactPallet` – Palletisation, tray counts, net kg, customer, status
- `FactCoolstore` – Pallet movements (In/Out/Relocate), temperature, humidity 
- `FactDowntime` – Line downtime events, reason codes, duration

### **Reference Table**
Lookup tables used to standardise codes and descriptions.
- `RefDefect` – Defect codes, descriptions, and severity levels
- `RefDowntimeReason` – Downtime reason codes and descriptions

---

## Glossary

| **Term** | Meaning | Ideal / Typical Values | Industry Explanation |
|----------|---------|------------------------|----------------------|
| **GrowerCode** | Unique identifier for a grower supplying fruit. | N/A | Identifies the orchard owner for traceability and performance reporting. |
| **BlockCode** | Identifier for an orchard block. | N/A | Used to track fruit quality and yield at a block level. |
| **VarietyCode / VarietyName** | Identifies kiwifruit variety (e.g., Hayward, SunGold). | N/A | Different varieties have different maturity rules and storage behaviour. |
| **TrayCount** | Number of trays packed or on a pallet. | 100-120 trays per pallet | Standard pallet configuration in NZ packhouses. |
| **PackedKg / TotalKg** | Total kilograms packed or produced. | 600-900 kg per pallet | Typical net weight range depending on tray type and fruit size. |
| **MovementType** | Coolstore movement: In, Out, Relocate. | N/A | Tracks pallet flow for inventory accuracy and cold chain compliance. |
| **Temperature** | Coolstore temperature (°C). | 0-1°C | Optimal storage temperature to slow ripening and maintain firmness. |
| **Humidity** | Coolstore humidity (%RH). | 90-95% RH | High humidity prevents fruit dehydration and weight loss. |
| **PalletNumber** | Unique pallet identifier. | N/A | Critical for traceability from orchard to export. |
| **DaysInCoolstore** | How long a pallet has been stored. | As low as possible | Longer storage increases softening risk and reduces market life. |
| **DefectCode** | QC defect type (e.g., blemish, rot). | N/A | Used to classify and monitor fruit quality issues. |
| **DefectCount / TotalDefects** | Number of defects found in QC sample. | As low as possible | High defect rates indicate orchard issues or packing line problems. |
| **Brix** | Sugar level of fruit (°Bx). | SunGold (G3): 6.5-7.5+<br>Hayward (Green): 6.2-6.8+ | Minimum Brix ensures fruit sweetness and export maturity compliance. |
| **DryMatter** | Percentage of solids; key flavour predictor. | SunGold: 16-18%+<br>Hayward: 15-17%+ | Higher DM strongly correlates with better flavour and consumer satisfaction. |
| **Pressure** | Fruit firmness (kgf). | SunGold: 6-8 kgf<br>Hayward: 7-9 kgf | Ensures fruit is firm enough for export and long storage. |
| **PassFailStatus** | Whether QC sample passed maturity rules. | Pass | Ensures fruit meets Zespri maturity standards before packing. |
| **QualityScore** | Numeric score summarising quality. | Higher = better | Aggregates QC performance across samples or growers. |
| **ReasonCode** | Downtime reason (mechanical, labour, cleaning). | N/A | Helps identify bottlenecks and operational inefficiencies. |
| **DurationMinutes** | Length of downtime event. | As low as possible | Directly impacts throughput and OEE performance. |
| **QualityRate** | QC pass rate for OEE. | >90% preferred | High quality rate indicates consistent fruit maturity and packing accuracy. |
| **PalletCount** | Number of pallets produced or stored. | N/A | Key metric for daily throughput and coolstore utilisation. |
| **AvgBrix / AvgDryMatter** | Average maturity metrics. | SunGold: Brix 6.5-7.5+, DM 16-18%+<br>Hayward: Brix 6.2-6.8+, DM 15-17%+ | Used to monitor overall fruit quality trends across growers and seasons. |

---

## Power BI Dashboards

The project includes dashboard designs for:

- Packing throughput & efficiency  
- QC sampling & defect trends  
- Coolstore inventory & movement tracking  
- Downtime analysis & line performance  

These dashboards help visualise operational performance across the packhouse workflow.

---

## Technologies Used ##

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

