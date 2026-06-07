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

