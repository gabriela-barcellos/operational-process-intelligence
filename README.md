# Operational Process Intelligence

End-to-end operational intelligence project focused on analyzing process performance, operational efficiency, data quality, process complexity, exceptions, and workflow automation using Python, PostgreSQL, Power BI, Power Apps, and Power Automate.

## Project Objective

The objective of this project is to analyze operational process data and transform raw event logs into actionable business insights.

The analysis focuses on:

- Process performance
- Process duration
- Process complexity
- Operational exceptions
- Escalations and rework
- Customer satisfaction
- Event transitions
- Data quality
- Operational investigation
- Workflow automation

## Technologies

- Python
- Pandas
- PostgreSQL
- SQL
- Power BI
- DAX
- Power Apps
- Power Automate
- GitHub

## Data Preparation & Python

The process mining event log was analyzed and transformed using Python and Pandas.

Python was used to:

- Load and prepare the event log dataset
- Aggregate events at case level
- Calculate process duration
- Calculate event counts
- Identify escalations
- Identify rework and reopening events
- Calculate process complexity
- Classify operational processes
- Prepare analytical datasets for PostgreSQL and Power BI

The processed datasets are available in the `data/` folder.

## PostgreSQL & SQL

The processed data was stored and analyzed in PostgreSQL.

SQL was used to:

- Create and structure analytical tables
- Define data types and constraints
- Analyze operational performance
- Calculate process metrics
- Analyze event transitions
- Identify operational hotspots
- Support the Power BI analytical model

The SQL scripts used in the project are available in the `sql/` folder.

## Process Classification

Processes were classified into three operational categories based on exception and complexity indicators:

- **Standard** — regular processes with lower complexity
- **Exception / Rework** — processes involving operational exceptions or rework
- **Complex** — processes with higher operational complexity

The classification supports the identification of processes that require deeper operational investigation.

## Power BI Dashboard

The dashboard was developed in Power BI and organized into three analytical pages:

1. **Executive Overview** — provides a high-level view of process volume, average duration, customer satisfaction, process classification, and operational duration gaps.
2. **Process Intelligence** — analyzes process behavior, duration, complexity distribution, event counts, process variants, and event transitions.
3. **Operational Investigation** — identifies operational hotspots by issue type, report channel, priority, escalations, rejections, reopenings, and long-duration cases.

## Key Insights

The analysis highlighted several relevant operational patterns:

- Standard processes represent the majority of the analyzed cases.
- Complex processes present higher average process duration than Standard processes.
- Exception / Rework and Complex processes show lower average customer satisfaction than Standard processes.
- Escalations represent an important operational event within the process.
- Process complexity varies across cases and can be used to support operational investigation.
- Long-duration cases provide opportunities for deeper investigation of operational inefficiencies.
- Missing resolver values are structurally associated with specific event types and were therefore retained as NULL values.

## Dashboard Preview

### Executive Overview

![Executive Overview](images/Executive_Overview.png)

### Process Intelligence

![Process Intelligence](images/Process_Intelligence.png)

### Operational Investigation

![Operational Investigation](images/Operational_Investigation.png)

## Investigation Workflow

The project also includes a conceptual workflow demonstrating how operational investigation can be connected to workflow automation.

### Power Apps

A conceptual Power Apps interface was designed to allow users to register cases for operational investigation directly from the analytical workflow.

![Power Apps](powerapps/Case_Investigation_App.png)

### Power Automate

A conceptual Power Automate workflow was designed to notify the investigation team when a case requires follow-up.

![Power Automate](powerautomate/Operational_Investigation_Notification.png)

> Note: The Power Apps and Power Automate interfaces are conceptual mockups created to demonstrate the intended workflow integration.

## Project Structure

```text
operational-process-intelligence/
│
├── data/
│   ├── process_analysis.csv
│   └── process_mining_event_log.zip
│
├── python/
│   └── 01_process_analysis.py
│
├── sql/
│   ├── 01_create_process_analysis.sql
│   └── 02_operational_analysis.sql
│
├── powerbi/
│
├── powerapps/
│   └── Case_Investigation_App.png
│
├── powerautomate/
│   └── Operational_Investigation_Notification.png
│
├── images/
│   ├── Executive_Overview.png
│   ├── Process_Intelligence.png
│   └── Operational_Investigation.png
│
├── docs/
│
├── LICENSE
└── README.md

Project Outcome
This project demonstrates an end-to-end operational intelligence workflow, connecting data preparation, process analytics, data quality, SQL analysis, business intelligence, operational investigation, and workflow automation.
The solution follows the flow:
Data → Python → Data Quality → PostgreSQL → Power BI → Investigation → Automation
