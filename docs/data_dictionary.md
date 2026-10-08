# Data Dictionary

## Overview

This document describes the main analytical fields used in the Operational Process Intelligence project.

The project uses two main analytical tables:

- `process_analysis` — case-level process analysis
- `process_events` — event-level process data

## Process Analysis

The `process_analysis` table contains one record per process case and is used as the main analytical table for process performance and classification.

| Field | Description |
|---|---|
| `case_id` | Unique identifier of the process case |
| `variant` | Process variant associated with the case |
| `priority` | Priority level assigned to the case |
| `issue_type` | Type of operational issue associated with the case |
| `process_start` | Timestamp when the process started |
| `process_end` | Timestamp when the process ended |
| `process_duration_hours` | Total process duration in hours |
| `event_count` | Total number of events recorded for the case |
| `l1_l2_escalations` | Number of L1-to-L2 escalation events |
| `l2_l3_escalations` | Number of L2-to-L3 escalation events |
| `l2_escalated_tickets` | Number of tickets escalated to L2 |
| `reopenings` | Number of customer reopening events |
| `l1_rejections` | Number of L1 rejection events |
| `l2_rejections` | Number of L2 rejection events |
| `complexity_score` | Composite score based on selected operational complexity events |
| `exception_rework` | Indicator identifying cases with exception or rework events |
| `process_classification` | Classification of the process as Standard, Exception / Rework, or Complex |
| `customer_satisfaction` | Customer satisfaction score associated with the case |

## Process Events

The `process_events` table contains the event-level records used to analyze process behavior and event sequences.

| Field | Description |
|---|---|
| `case_id` | Identifier linking the event to a process case |
| `variant` | Process variant associated with the case |
| `priority` | Priority level assigned to the case |
| `reporter` | Person or source that reported the case |
| `event_timestamp` | Timestamp when the event occurred |
| `event` | Event type recorded in the process |
| `issue_type` | Type of operational issue associated with the case |
| `resolver` | Resolver associated with the event |
| `report_channel` | Channel through which the case was reported |
| `short_description` | Short description of the reported issue |
| `customer_satisfaction` | Customer satisfaction score associated with the case |

## Process Classification

Process classification is based on operational complexity and exception/rework indicators.

### Standard

Processes without exception/rework indicators and with lower complexity scores.

### Exception / Rework

Processes containing identified exception or rework events.

### Complex

Processes with higher operational complexity based on the complexity score.

## Complexity Score

The complexity score is based on the presence of selected operational events:

- L1-L2 Escalations
- L2-L3 Escalations
- L2 Escalated Tickets
- Reopenings
- L1 Rejections
- L2 Rejections

The score is used to support process classification and operational investigation.

## Data Quality Notes

The dataset contains missing values in the `resolver` field.

These missing values were retained as NULL because they are structurally associated with specific event types. They were not replaced with arbitrary values.

Timestamp validation was also performed during data preparation to ensure that process duration calculations were based on valid event timestamps.

## Analytical Relationship

The two analytical tables are connected through:

`process_analysis.case_id`

and

`process_events.case_id`

The relationship is:

**One process case → Multiple process events**

This structure allows case-level performance metrics to be analyzed together with detailed event-level process behavior.
