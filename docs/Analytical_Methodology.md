# Analytical Methodology

## Overview

This document describes the main analytical methods used in the Operational Process Intelligence project.

The methodology transforms event-level process data into case-level operational metrics that can be analyzed using SQL and Power BI.

## Process Duration

Process duration represents the total elapsed time between the first and last recorded event of a process case.

The calculation is based on:

**Process Duration = Process End − Process Start**

The result is expressed in hours.

This metric is used to evaluate overall process performance and identify cases with longer execution times.

## Event Count

Event count represents the total number of recorded events associated with each process case.

A higher event count may indicate a more complex process path and is analyzed together with other operational indicators.

## Operational Event Indicators

Selected event types were converted into case-level operational indicators.

The analysis includes:

- L1-L2 Escalations
- L2-L3 Escalations
- L2 Escalated Tickets
- Reopenings
- L1 Rejections
- L2 Rejections

These indicators allow operational events to be analyzed at the process-case level.

## Complexity Score

The complexity score is based on the occurrence of selected operational events.

The following event categories contribute to the score:

- L1-L2 Escalations
- L2-L3 Escalations
- L2 Escalated Tickets
- Reopenings
- L1 Rejections
- L2 Rejections

The resulting score is used as an operational indicator of process complexity.

## Exception / Rework Identification

Cases containing identified exception or rework events are flagged using the `exception_rework` indicator.

This allows processes involving operational exceptions or rework to be separated from regular process cases.

## Process Classification

Each process case is classified using the exception/rework indicator and complexity score.

The classification logic is:

1. If `exception_rework = 1`, the process is classified as **Exception / Rework**.
2. Otherwise, if `complexity_score >= 2`, the process is classified as **Complex**.
3. All remaining cases are classified as **Standard**.

This classification provides a consistent framework for comparing process behavior across different operational profiles.

## Customer Satisfaction

Customer satisfaction is analyzed using the available satisfaction score associated with each process case.

The metric is used to compare satisfaction across process classifications and operational characteristics.

The analysis is descriptive and does not establish causal relationships between process characteristics and customer satisfaction.

## Process Transitions

Event transitions are analyzed by comparing consecutive events within the same process case.

For each transition, the analysis calculates:

- Transition count
- Average transition time
- Median transition time

This allows the identification of transitions where process time is more concentrated.

## Operational Investigation

The analytical model supports investigation of cases based on operational characteristics such as:

- Process classification
- Process duration
- Complexity score
- Escalations
- Reopenings
- Rejections
- Issue type
- Priority
- Report channel

Long-duration cases classified as **Exception / Rework** or **Complex** are prioritized in the investigation workflow.

## Analytical Perspective

The methodology follows a progressive analytical approach:

**Event Data → Case-Level Metrics → Process Classification → Performance Analysis → Operational Investigation**

The objective is to move from raw process events toward structured operational insights that can support investigation and follow-up actions.
