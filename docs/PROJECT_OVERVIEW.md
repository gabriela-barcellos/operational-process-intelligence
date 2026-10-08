# Project Overview

## Operational Process Intelligence

Operational Process Intelligence is an end-to-end data analytics project designed to transform process mining event data into actionable operational insights.

The project combines data preparation, process analytics, data quality assessment, SQL analysis, business intelligence, operational investigation, and workflow automation.

## Business Problem

Operational processes generate large volumes of event data, but raw event logs alone do not provide a clear view of process performance.

The objective of this project is to identify:

- Where operational time is concentrated
- How process complexity varies across cases
- Which processes require deeper investigation
- Where escalations, rework, rejections, and reopenings occur
- How operational patterns relate to customer satisfaction
- How data can support investigation and follow-up workflows

## Solution Approach

The project follows an end-to-end analytical workflow:

**Data → Python → Data Quality → PostgreSQL → Power BI → Investigation → Automation**

### 1. Data Preparation

The Process Mining Event Log dataset was processed using Python and Pandas.

The data was transformed from event-level records into analytical case-level information, including:

- Process duration
- Event count
- Escalations
- Rejections
- Reopenings
- Complexity score
- Exception / Rework classification
- Process classification
- Customer satisfaction

### 2. Data Quality

Data quality checks were performed during the preparation and analysis stages.

Missing resolver values were identified in the event log. These missing values were retained as NULL because they are structurally associated with specific event types rather than being treated as random missing data.

### 3. PostgreSQL

The processed analytical data was stored and analyzed in PostgreSQL.

SQL was used to support:

- Process performance analysis
- Operational metrics
- Event transition analysis
- Process complexity analysis
- Operational investigation
- Analytical preparation for Power BI

### 4. Power BI

Power BI was used to transform the analytical data into an interactive operational intelligence dashboard.

The dashboard contains three analytical perspectives:

**Executive Overview**

Provides a high-level view of process volume, duration, customer satisfaction, classification, and operational gaps.

**Process Intelligence**

Explores process behavior, complexity, event counts, process variants, and event transitions.

**Operational Investigation**

Focuses on operational hotspots, issue types, report channels, escalations, rejections, reopenings, and long-duration cases.

### 5. Investigation Workflow

The project extends the analytical workflow beyond visualization.

A conceptual Power Apps interface demonstrates how users could register cases requiring operational investigation.

A conceptual Power Automate workflow demonstrates how investigation cases could trigger notifications and follow-up actions.

## Key Analytical Results

The analysis identified the following patterns:

- The dataset contains **31,588 processes** and **242,901 event records**.
- Standard processes represent approximately **85%** of all processes.
- Exception / Rework processes represent approximately **8.6%**.
- Complex processes represent approximately **6.3%**.
- Average process duration is approximately **15 hours**.
- Complex processes show an average duration of approximately **24 hours**, compared with approximately **14 hours** for Standard processes.
- Average customer satisfaction is lower for Complex and Exception / Rework processes than for Standard processes.
- Approximately **57.7%** of processes contain an L1-to-L2 escalation.
- Reopenings occur in approximately **3.8%** of processes.
- L1 rejections occur in approximately **3.0%** of processes.

These results are descriptive and indicate operational patterns for investigation; they do not establish causal relationships.

## Business Value

The project demonstrates how operational event data can be transformed into a structured intelligence workflow.

The solution enables organizations to move through the following analytical journey:

**Raw operational data → Process understanding → Operational investigation → Workflow automation**

This approach supports data-driven identification of process inefficiencies, operational exceptions, and cases requiring further investigation.

## Project Scope

The project demonstrates the integration of:

- Data Engineering
- Python
- Pandas
- Data Quality
- SQL
- PostgreSQL
- Process Analytics
- Power BI
- DAX
- Power Apps
- Power Automate
- GitHub
