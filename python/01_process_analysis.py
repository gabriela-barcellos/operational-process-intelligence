import pandas as pd
from pathlib import Path

# ============================================================
# 1. File paths
# ============================================================

project_path = Path(__file__).resolve().parent.parent

input_file = (
    project_path
    / "data"
    / "process_mining_event_log.csv"
)

output_file = (
    project_path
    / "data"
    / "process_analysis.csv"
)

# ============================================================
# 2. Load event log
# ============================================================

df = pd.read_csv(
    input_file,
    sep=";"
)

print("Event log loaded successfully!")
print(f"Rows: {len(df):,}")
print(f"Columns: {len(df.columns)}")

# ============================================================
# 3. Convert Timestamp
# ============================================================

df["Timestamp"] = pd.to_datetime(
    df["Timestamp"],
    errors="coerce"
)

# ============================================================
# 4. Create process-level dataset
# ============================================================

process_analysis = (
    df.groupby("Case ID")
    .agg(
        Process_Start=("Timestamp", "min"),
        Process_End=("Timestamp", "max"),
        Event_Count=("Event", "count"),
        Variant=("Variant", "first"),
        Priority=("Priority", "first"),
        Issue_Type=("Issue Type", "first"),
        Report_Channel=("Report Channel", "first"),
        Customer_Satisfaction=("Customer Satisfaction", "first")
    )
    .reset_index()
)

# ============================================================
# 5. Calculate process duration
# ============================================================

process_analysis["Process_Duration_Hours"] = (
    process_analysis["Process_End"]
    - process_analysis["Process_Start"]
).dt.total_seconds() / 3600

process_analysis["Process_Duration_Hours"] = (
    process_analysis["Process_Duration_Hours"]
    .round(2)
)

# ============================================================
# 6. Count complexity-related events
# ============================================================

complexity_events = {
    "L1_L2_Escalations": "Level 1 escalates to level 2 support",
    "L2_L3_Escalations": "Level 2 escalates to level 3 support",
    "L2_Escalated_Tickets": "Ticket escalated to level 2 support",
    "Reopenings": "Ticket reopened by customer",
    "L1_Rejections": "Ticket rejected by level 1 support",
    "L2_Rejections": "Level 2 support rejects the ticket"
}

for column_name, event_name in complexity_events.items():

    event_counts = (
        df[df["Event"] == event_name]
        .groupby("Case ID")
        .size()
    )

    process_analysis[column_name] = (
        process_analysis["Case ID"]
        .map(event_counts)
        .fillna(0)
        .astype(int)
    )

# ============================================================
# 7. Calculate Complexity Score
# ============================================================

complexity_columns = list(complexity_events.keys())

process_analysis["Complexity_Score"] = (
    process_analysis[complexity_columns]
    .sum(axis=1)
)

# ============================================================
# 8. Identify exception / rework processes
# ============================================================

process_analysis["Exception_Rework"] = (
    (
        (process_analysis["Reopenings"] > 0)
        | (process_analysis["L1_Rejections"] > 0)
        | (process_analysis["L2_Rejections"] > 0)
    )
    .astype(int)
)

# ============================================================
# 9. Classify process complexity
# ============================================================

def classify_process(row):

    if row["Exception_Rework"] == 1:
        return "Exception / Rework"

    elif row["Complexity_Score"] >= 2:
        return "Complex"

    else:
        return "Standard"


process_analysis["Process_Classification"] = (
    process_analysis.apply(
        classify_process,
        axis=1
    )
)

# ============================================================
# 10. Reorder columns
# ============================================================

process_analysis = process_analysis[
    [
        "Case ID",
        "Variant",
        "Priority",
        "Issue_Type",
        "Report_Channel",
        "Process_Start",
        "Process_End",
        "Process_Duration_Hours",
        "Event_Count",
        "L1_L2_Escalations",
        "L2_L3_Escalations",
        "L2_Escalated_Tickets",
        "Reopenings",
        "L1_Rejections",
        "L2_Rejections",
        "Complexity_Score",
        "Exception_Rework",
        "Process_Classification",
        "Customer_Satisfaction"
    ]
]

# ============================================================
# 11. Save analytical dataset
# ============================================================

process_analysis.to_csv(
    output_file,
    index=False
)

# ============================================================
# 12. Validation
# ============================================================

print("\n" + "=" * 60)
print("ANALYTICAL DATASET CREATED")
print("=" * 60)

print(f"Processes: {len(process_analysis):,}")
print(f"Columns: {len(process_analysis.columns)}")

print(f"\nSaved to:")
print(output_file)

print("\nClassification:")
print(
    process_analysis[
        "Process_Classification"
    ]
    .value_counts()
)

print("\nDataset sample:")
print(
    process_analysis
    .head(10)
    .to_string(index=False)
)