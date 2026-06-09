<img src="docs/packhouse-dw-banner.png" alt="Packhouse Warehouse Banner" width="1000">

# Kiwifruit Packhouse Data Warehouse & Analytics

A complete end‑to‑end **data warehouse and analytics project** for kiwifruit packhouse operations.
Built using **SQL Server**, **Power BI**, and a full set of dimensional models covering packing, QC, pallets, coolstore movements, and downtime.
Includes a glossary explaining key post‑harvest concepts such as **Brix**, **Dry Matter**, **firmness**, **coolstore conditions** etc.

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
  - Season‑level production metrics  
  - Variety, grower, and block performance    
  - Packline throughput, efficiency, and downtime  
  - Packing grade and class distribution and insights 
  - QC sampling, defect trends, and maturity metrics
  - Pallet movements and coolstore inventory

- **Power BI Dashboards**
  - **Season Overview** - high‑level KPIs, production trends, and downtime  
  - **Variety & Grower Performance** - yield, quality, and consistency across seasons  
  - **Block Performance** - orchard‑level insights and productivity metrics  
  - **Packline Performance & Throughput** - line efficiency, output, and bottleneck analysis  
  - **Packing Insights** - grade distribution, class performance, and packing trends  
  - **QC Dashboard** - defect patterns, maturity results, and sampling coverage  
  - **Pallet & Coolstore** - inventory flow, storage duration, and movement tracking  
  - **Downtime Analysis** - root causes, duration, and operational impact 

- **Glossary**
  - Explains horticulture and post‑harvest terms 
  - Includes ideal values for Brix, Dry Matter, Pressure, etc.

---
## High‑Level Architecture Overview
The Packhouse Data Warehouse platform consolidates operational data from across the horticultural value chain into a unified, analytics‑ready warehouse. Source extracts from orchard management, packing operations, quality control, coolstore movements, downtime tracking, and dispatch systems are ingested into SQL Server through a structured staging process. After validation and transformation, the data is modelled into a dimensional warehouse that standardises business logic across production, quality, and supply‑chain domains. Curated SQL Semantic Views provide a governed analytical layer consumed by Power BI dashboards, enabling consistent reporting, operational insights, and data‑driven decision‑making across the packhouse environment.  

![High Level Architecture](docs/packhouse-dw-high-level-architecture.png)

---

## Data Source Overview
The synthetic datasets used in this project emulate data flows from real packhouse operational systems.
Each source represents a typical enterprise application that would feed a production data warehouse in horticultural processing environments.
These datasets were generated synthetically to reflect realistic packhouse operations and ingested into SQL Server as CSV extracts for the Packhouse_DW warehouse.

| Data Domain | Simulated Source System | Typical System Type | Example Platform |
| --- | --- | --- | --- |
| **Orchard Metadata** | Grower, block, and variety registration | ERP / Farm Management System | Radfords FreshInsights, Croptracker |
| **Packing Throughput** | Line performance and tray counts | MES (Manufacturing Execution System) | Packhouse line control software |
| **Quality Inspections** | Defect and grade results | LIMS (Laboratory Information Management System) / QC System | FreshInsights QC module |
| **Coolstore Movements** | Pallet storage and retrieval | WMS (Warehouse Management System) | Radfords Coolstore |
| **Downtime Logs** | Machine stoppages and reasons | SCADA / Maintenance System | Line PLC or downtime tracker |
| **Customer & Dispatch** | Orders and shipments | ERP / CRM | Microsoft Dynamics, SAP |

---

## Data Flow Summary
Operational data from orchard management, packing lines, QC inspections, coolstore operations, downtime tracking, and dispatch systems is exported as structured CSV extracts. These files are ingested into SQL Server through a controlled staging process, where they undergo validation, standardisation, and transformation into the Packhouse_DW warehouse schema. Cleaned data is modelled into Dimensions, Facts, and Reference tables, then exposed through curated SQL Semantic Views. These views form the analytical layer consumed by Power BI dashboards, enabling consistent, governed reporting across production, quality, and supply‑chain workflows.

![image alt](docs/packhouse-dw-data-flow-diagram.png)
---
## Data Warehouse Schema Overview

### **Dimensions**
Dimensions store descriptive attributes about business entities.  
They answer the “who, what, where, when” of our data and are used for slicing, filtering, and grouping in analytics.

- `DimDate` – Standard date dimension for calendar attributes 
- `DimGrower` –  SCD2 (Slowly Changing Dimension Type 2) grower attributes (code, name, region, active status)
- `DimBlock` – SCD2 (Slowly Changing Dimension Type 2) orchard block attributes (block, grower, variety, hectares)  
- `DimVariety` –  Kiwifruit varieties and maturity groups
- `DimPackLine` – Packing line metadata (line name, site)
- `DimCoolstore` – Coolstore rooms and site information
- `DimCustomer` – Export customer and market attributes

### **Fact Tables**
Fact tables store measurable events - the numeric values we aggregate and analyse.  
They answer the “how much, how many, how long” questions.

- `FactPacking` – Packing runs, grades, classes, tray counts, packed kg
- `FactQC` – QC sampling results: defects, Brix, Dry Matter, Pressure
- `FactPallet` – Palletisation, tray counts, net kg, customer, status
- `FactCoolstore` – Pallet movements (In/Out/Relocate), temperature, humidity 
- `FactDowntime` – Line downtime events, reason codes, duration

### **Reference Table**
Reference tables provide standardised lookup values used across dimensions and facts.  
They ensure consistency for codes, labels, and classifications.

- `RefDefect` – Defect codes, descriptions, and severity levels
- `RefDowntimeReason` – Downtime reason codes and descriptions

---

## **Entity Relationship Diagram (ERD)**
<p align="left">
  <img src="docs/erd.png" width="800">
</p>

---

## Glossary

| **Term** | Meaning | Ideal / Typical Values | Industry Explanation |
|----------|---------|------------------------|----------------------|
| **Grower Code** | Unique identifier for a grower supplying fruit. | N/A | Identifies the orchard owner for traceability and performance reporting. |
| **Block Code** | Identifier for an orchard block. | N/A | Used to track fruit quality and yield at a block level. |
| **Variety Code / VarietyName** | Identifies kiwifruit variety (e.g., Hayward, SunGold). | N/A | Different varieties have different maturity rules and storage behaviour. |
| **Tray Count** | Number of trays packed or on a pallet. | 100-120 trays per pallet | Standard pallet configuration in NZ packhouses. |
| **Packed Kg / TotalKg** | Total kilograms packed or produced. | 600-900 kg per pallet | Typical net weight range depending on tray type and fruit size. |
| **Movement Type** | Coolstore movement: In, Out, Relocate. | N/A | Tracks pallet flow for inventory accuracy and cold chain compliance. |
| **Temperature** | Coolstore temperature (°C). | 0-1°C | Optimal storage temperature to slow ripening and maintain firmness. |
| **Humidity** | Coolstore humidity (%RH). | 90-95% RH | High humidity prevents fruit dehydration and weight loss. |
| **Pallet Number** | Unique pallet identifier. | N/A | Critical for traceability from orchard to export. |
| **DaysInCoolstore** | How long a pallet has been stored. | As low as possible | Longer storage increases softening risk and reduces market life. |
| **Defect Code** | QC defect type (e.g., blemish, rot). | N/A | Used to classify and monitor fruit quality issues. |
| **Defect Count / Total Defects** | Number of defects found in QC sample. | As low as possible | High defect rates indicate orchard issues or packing line problems. |
| **Brix** | Sugar level of fruit (°Bx). | SunGold (G3): 6.5-7.5+<br>Hayward (Green): 6.2-6.8+ | Minimum Brix ensures fruit sweetness and export maturity compliance. |
| **Dry Matter** | Percentage of solids; key flavour predictor. | SunGold: 16-18%+<br>Hayward: 15-17%+ | Higher DM strongly correlates with better flavour and consumer satisfaction. |
| **Pressure** | Fruit firmness (kgf). | SunGold: 6-8 kgf<br>Hayward: 7-9 kgf | Ensures fruit is firm enough for export and long storage. |
| **PassFail Status** | Whether QC sample passed maturity rules. | Pass | Ensures fruit meets Zespri maturity standards before packing. |
| **Quality Score** | Numeric score summarising quality. | Higher = better | Aggregates QC performance across samples or growers. |
| **Reason Code** | Downtime reason (mechanical, labour, cleaning). | N/A | Helps identify bottlenecks and operational inefficiencies. |
| **Duration Minutes** | Length of downtime event. | As low as possible | Directly impacts throughput and OEE performance. |
| **Quality Rate** | QC pass rate for OEE. | >90% preferred | High quality rate indicates consistent fruit maturity and packing accuracy. |
| **Pallet Count** | Number of pallets produced or stored. | N/A | Key metric for daily throughput and coolstore utilisation. |
| **Avg Brix / Avg Dry Matter** | Average maturity metrics. | SunGold: Brix 6.5-7.5+, DM 16-18%+<br>Hayward: Brix 6.2-6.8+, DM 15-17%+ | Used to monitor overall fruit quality trends across growers and seasons. |

---

## Technologies Used ##

- **SQL Server** (Data Warehouse)
- **T‑SQL** (ETL, SCD2 logic, analytical views)
- **Power BI** (Dashboards & reporting)
- **Markdown** (Documentation)
- **GitHub** (Version control & portfolio)

---

## Purpose of This Project
The purpose of this project is to provide a complete, production‑aligned demonstration of how a modern kiwifruit packhouse can use data engineering, data warehousing, and analytics to support operational decision‑making.   
It showcases the full lifecycle of building a SQL Server data warehouse, from ingesting raw CSV extracts through staging, transforming them into a dimensional model, and exposing governed analytical views for Power BI reporting.

This repository is designed to:

- Illustrate **real‑world data engineering workflows**, including staging, validation, transformation, and SCD2 dimension management  
- Demonstrate **best‑practice data warehouse modelling** using facts, dimensions, and reference tables aligned to packhouse operations  
- Provide **analytical SQL views** that standardise business logic for production, quality, coolstore, and downtime reporting
- Deliver **Power BI dashboards** that mirror the insights used in commercial packhouse environments, covering season trends, variety and grower performance, block productivity, packline throughput, QC results, pallet movements, and downtime analysis
- Serve as a **portfolio‑ready example** of end‑to‑end data architecture, modelling, and BI development in a horticultural processing context

It acts as a complete learning and demonstration resource for anyone wanting to understand how operational data from orchard, packing, QC, coolstore, and downtime systems can be unified into a single analytics‑ready warehouse.

---

## Repository Structure

