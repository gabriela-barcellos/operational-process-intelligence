-- Create the main process analysis table

CREATE TABLE process_analysis (
    case_id VARCHAR(20) PRIMARY KEY,
    variant VARCHAR(50),
    priority VARCHAR(20),
    issue_type VARCHAR(100),
    report_channel VARCHAR(50),
    process_start TIMESTAMP,
    process_end TIMESTAMP,
    process_duration_hours NUMERIC(10,2),
    event_count INTEGER,
    l1_l2_escalations INTEGER,
    l2_l3_escalations INTEGER,
    l2_escalated_tickets INTEGER,
    reopenings INTEGER,
    l1_rejections INTEGER,
    l2_rejections INTEGER,
    complexity_score INTEGER,
    exception_rework INTEGER,
    process_classification VARCHAR(30),
    customer_satisfaction INTEGER
);