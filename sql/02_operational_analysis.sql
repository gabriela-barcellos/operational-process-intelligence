-- ============================================================
-- OPERATIONAL PROCESS INTELLIGENCE
-- Operational Analysis Queries
-- ============================================================


-- ============================================================
-- 1. Operational analysis by process classification
-- Compare process volume, duration and customer satisfaction
-- ============================================================

SELECT
    process_classification,
    COUNT(*) AS process_count,

    ROUND(
        AVG(process_duration_hours),
        2
    ) AS average_duration_hours,

    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY process_duration_hours
        )::numeric,
        2
    ) AS median_duration_hours,

    ROUND(
        AVG(customer_satisfaction),
        2
    ) AS average_customer_satisfaction

FROM process_analysis

GROUP BY
    process_classification

ORDER BY
    average_duration_hours DESC;


-- ============================================================
-- 2. Time between consecutive process events
-- Identify where process time is concentrated
-- ============================================================

WITH ordered_events AS (

    SELECT
        case_id,
        event,
        event_timestamp,

        LEAD(event_timestamp) OVER (
            PARTITION BY case_id
            ORDER BY event_timestamp
        ) AS next_event_timestamp,

        LEAD(event) OVER (
            PARTITION BY case_id
            ORDER BY event_timestamp
        ) AS next_event

    FROM process_events
)

SELECT
    event AS current_event,
    next_event,
    COUNT(*) AS transition_count,

    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    next_event_timestamp
                    - event_timestamp
                )
            ) / 3600
        )::numeric,
        2
    ) AS average_transition_hours,

    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY
                EXTRACT(
                    EPOCH FROM (
                        next_event_timestamp
                        - event_timestamp
                    )
                ) / 3600
        )::numeric,
        2
    ) AS median_transition_hours

FROM ordered_events

WHERE next_event_timestamp IS NOT NULL

GROUP BY
    event,
    next_event

ORDER BY
    average_transition_hours DESC;


-- ============================================================
-- 3. Process variant analysis
-- Compare process volume, duration and customer satisfaction
-- across different process paths
-- ============================================================

SELECT
    variant,
    process_classification,

    COUNT(*) AS process_count,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS process_share_percent,

    ROUND(
        AVG(process_duration_hours),
        2
    ) AS average_duration_hours,

    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY process_duration_hours
        )::numeric,
        2
    ) AS median_duration_hours,

    ROUND(
        AVG(customer_satisfaction),
        2
    ) AS average_customer_satisfaction

FROM process_analysis

GROUP BY
    variant,
    process_classification

ORDER BY
    process_count DESC;


-- ============================================================
-- 4. Process complexity analysis
-- Analyze how process complexity relates to duration
-- and customer satisfaction
-- ============================================================

SELECT
    complexity_score,

    COUNT(*) AS process_count,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS process_share_percent,

    ROUND(
        AVG(process_duration_hours),
        2
    ) AS average_duration_hours,

    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY process_duration_hours
        )::numeric,
        2
    ) AS median_duration_hours,

    ROUND(
        AVG(customer_satisfaction),
        2
    ) AS average_customer_satisfaction

FROM process_analysis

GROUP BY
    complexity_score

ORDER BY
    complexity_score;


-- ============================================================
-- 5. Data quality analysis
-- Identify missing resolver values by event type
-- ============================================================

SELECT
    event,

    COUNT(*) AS event_count,

    COUNT(*) FILTER (
        WHERE resolver IS NULL
    ) AS missing_resolver_count,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE resolver IS NULL
        ) /
        COUNT(*),
        2
    ) AS missing_resolver_percent

FROM process_events

GROUP BY
    event

ORDER BY
    missing_resolver_percent DESC,
    event_count DESC;


-- ============================================================
-- 6. Overall data quality check
-- Check missing values across key process event fields
-- ============================================================

SELECT
    COUNT(*) AS total_event_records,

    COUNT(*) FILTER (
        WHERE case_id IS NULL OR TRIM(case_id) = ''
    ) AS missing_case_id,

    COUNT(*) FILTER (
        WHERE event IS NULL OR TRIM(event) = ''
    ) AS missing_event,

    COUNT(*) FILTER (
        WHERE event_timestamp IS NULL
    ) AS missing_event_timestamp,

    COUNT(*) FILTER (
        WHERE priority IS NULL OR TRIM(priority) = ''
    ) AS missing_priority,

    COUNT(*) FILTER (
        WHERE issue_type IS NULL OR TRIM(issue_type) = ''
    ) AS missing_issue_type,

    COUNT(*) FILTER (
        WHERE report_channel IS NULL OR TRIM(report_channel) = ''
    ) AS missing_report_channel,

    COUNT(*) FILTER (
        WHERE customer_satisfaction IS NULL
    ) AS missing_customer_satisfaction

FROM process_events;


-- ============================================================
-- 7. Operational dimension analysis
-- Analyze process distribution across priority, issue type
-- and report channel
-- ============================================================


-- Priority distribution

SELECT
    'Priority' AS dimension,
    priority AS category,
    COUNT(*) AS process_count,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS process_share_percent

FROM process_analysis

GROUP BY
    priority

ORDER BY
    process_count DESC;


-- Issue type distribution

SELECT
    'Issue Type' AS dimension,
    issue_type AS category,
    COUNT(*) AS process_count,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS process_share_percent

FROM process_analysis

GROUP BY
    issue_type

ORDER BY
    process_count DESC;


-- Report channel distribution

SELECT
    'Report Channel' AS dimension,
    report_channel AS category,
    COUNT(*) AS process_count,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS process_share_percent

FROM process_analysis

GROUP BY
    report_channel

ORDER BY
    process_count DESC;


-- ============================================================
-- 8. Priority performance analysis
-- Analyze duration, complexity and customer satisfaction
-- across different priority levels
-- ============================================================

SELECT
    priority,

    COUNT(*) AS process_count,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS process_share_percent,

    ROUND(
        AVG(process_duration_hours),
        2
    ) AS average_duration_hours,

    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY process_duration_hours
        )::numeric,
        2
    ) AS median_duration_hours,

    ROUND(
        AVG(complexity_score),
        2
    ) AS average_complexity_score,

    ROUND(
        AVG(customer_satisfaction),
        2
    ) AS average_customer_satisfaction

FROM process_analysis

GROUP BY
    priority

ORDER BY
    average_duration_hours DESC;

    -- ============================================================
-- 9. Issue type performance analysis
-- Analyze duration, complexity and customer satisfaction
-- across different issue types
-- ============================================================

SELECT
    issue_type,

    COUNT(*) AS process_count,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS process_share_percent,

    ROUND(
        AVG(process_duration_hours),
        2
    ) AS average_duration_hours,

    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY process_duration_hours
        )::numeric,
        2
    ) AS median_duration_hours,

    ROUND(
        AVG(complexity_score),
        2
    ) AS average_complexity_score,

    ROUND(
        AVG(customer_satisfaction),
        2
    ) AS average_customer_satisfaction

FROM process_analysis

GROUP BY
    issue_type

ORDER BY
    average_duration_hours DESC;

    -- ============================================================
-- 10. Report channel performance analysis
-- Analyze duration, complexity and customer satisfaction
-- across different report channels
-- ============================================================

SELECT
    report_channel,

    COUNT(*) AS process_count,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS process_share_percent,

    ROUND(
        AVG(process_duration_hours),
        2
    ) AS average_duration_hours,

    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY process_duration_hours
        )::numeric,
        2
    ) AS median_duration_hours,

    ROUND(
        AVG(complexity_score),
        2
    ) AS average_complexity_score,

    ROUND(
        AVG(customer_satisfaction),
        2
    ) AS average_customer_satisfaction

FROM process_analysis

GROUP BY
    report_channel

ORDER BY
    average_duration_hours DESC;

    -- ============================================================
-- 11. Operational hotspot analysis
-- Identify process groups with higher duration and complexity
-- while considering process volume and customer satisfaction
-- ============================================================

SELECT
    issue_type,
    priority,

    COUNT(*) AS process_count,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS process_share_percent,

    ROUND(
        AVG(process_duration_hours),
        2
    ) AS average_duration_hours,

    ROUND(
        AVG(complexity_score),
        2
    ) AS average_complexity_score,

    ROUND(
        AVG(customer_satisfaction),
        2
    ) AS average_customer_satisfaction

FROM process_analysis

GROUP BY
    issue_type,
    priority

HAVING
    COUNT(*) >= 100

ORDER BY
    average_duration_hours DESC,
    average_complexity_score DESC;

    -- ============================================================
-- 12. High-duration process transition analysis
-- Identify event transitions associated with longer processes
-- ============================================================

WITH duration_threshold AS (

    SELECT
        PERCENTILE_CONT(0.75)
        WITHIN GROUP (
            ORDER BY process_duration_hours
        ) AS high_duration_threshold

    FROM process_analysis
),

high_duration_cases AS (

    SELECT
        pa.case_id

    FROM process_analysis pa

    CROSS JOIN duration_threshold dt

    WHERE
        pa.process_duration_hours >= dt.high_duration_threshold
),

ordered_events AS (

    SELECT
        pe.case_id,
        pe.event,
        pe.event_timestamp,

        LEAD(pe.event_timestamp) OVER (
            PARTITION BY pe.case_id
            ORDER BY pe.event_timestamp
        ) AS next_event_timestamp,

        LEAD(pe.event) OVER (
            PARTITION BY pe.case_id
            ORDER BY pe.event_timestamp
        ) AS next_event

    FROM process_events pe

    INNER JOIN high_duration_cases hdc
        ON pe.case_id = hdc.case_id
)

SELECT
    event AS current_event,
    next_event,

    COUNT(*) AS transition_count,

    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    next_event_timestamp
                    - event_timestamp
                )
            ) / 3600
        )::numeric,
        2
    ) AS average_transition_hours,

    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY
                EXTRACT(
                    EPOCH FROM (
                        next_event_timestamp
                        - event_timestamp
                    )
                ) / 3600
        )::numeric,
        2
    ) AS median_transition_hours

FROM ordered_events

WHERE
    next_event_timestamp IS NOT NULL

GROUP BY
    event,
    next_event

ORDER BY
    average_transition_hours DESC;

    -- ============================================================
-- 13. Rework and exception analysis
-- Analyze processes involving reopenings, rejections
-- and escalations
-- ============================================================

SELECT
    process_classification,

    COUNT(*) AS process_count,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS process_share_percent,

    ROUND(
        AVG(process_duration_hours),
        2
    ) AS average_duration_hours,

    ROUND(
        AVG(complexity_score),
        2
    ) AS average_complexity_score,

    ROUND(
        AVG(reopenings),
        2
    ) AS average_reopenings,

    ROUND(
        AVG(l1_rejections),
        2
    ) AS average_l1_rejections,

    ROUND(
        AVG(l2_rejections),
        2
    ) AS average_l2_rejections,

    ROUND(
        AVG(l1_l2_escalations),
        2
    ) AS average_l1_l2_escalations,

    ROUND(
        AVG(l2_l3_escalations),
        2
    ) AS average_l2_l3_escalations,

    ROUND(
        AVG(customer_satisfaction),
        2
    ) AS average_customer_satisfaction

FROM process_analysis

GROUP BY
    process_classification

ORDER BY
    average_duration_hours DESC;

    -- ============================================================
-- 14. Process improvement opportunities
-- Identify process groups that combine relevant volume,
-- higher duration and higher complexity
-- ============================================================

WITH process_groups AS (

    SELECT
        issue_type,
        priority,

        COUNT(*) AS process_count,

        ROUND(
            100.0 * COUNT(*) /
            SUM(COUNT(*)) OVER (),
            2
        ) AS process_share_percent,

        AVG(process_duration_hours) AS average_duration_hours,

        AVG(complexity_score) AS average_complexity_score,

        AVG(customer_satisfaction) AS average_customer_satisfaction

    FROM process_analysis

    GROUP BY
        issue_type,
        priority
),

benchmarks AS (

    SELECT
        AVG(process_duration_hours) AS overall_average_duration,
        AVG(complexity_score) AS overall_average_complexity,
        AVG(customer_satisfaction) AS overall_average_satisfaction

    FROM process_analysis
)

SELECT
    pg.issue_type,
    pg.priority,
    pg.process_count,
    pg.process_share_percent,

    ROUND(
        pg.average_duration_hours,
        2
    ) AS average_duration_hours,

    ROUND(
        pg.average_complexity_score,
        2
    ) AS average_complexity_score,

    ROUND(
        pg.average_customer_satisfaction,
        2
    ) AS average_customer_satisfaction,

    CASE
        WHEN
            pg.average_duration_hours > b.overall_average_duration
            AND pg.average_complexity_score > b.overall_average_complexity
            AND pg.process_count >= 100
        THEN 'Investigation Area'

        WHEN
            pg.average_duration_hours > b.overall_average_duration
            AND pg.process_count >= 100
        THEN 'Duration Review'

        WHEN
            pg.average_complexity_score > b.overall_average_complexity
            AND pg.process_count >= 100
        THEN 'Complexity Review'

        ELSE 'Monitor'
    END AS operational_focus

FROM process_groups pg

CROSS JOIN benchmarks b

ORDER BY
    CASE
        WHEN
            pg.average_duration_hours > b.overall_average_duration
            AND pg.average_complexity_score > b.overall_average_complexity
            AND pg.process_count >= 100
        THEN 1

        WHEN
            pg.average_duration_hours > b.overall_average_duration
            AND pg.process_count >= 100
        THEN 2

        WHEN
            pg.average_complexity_score > b.overall_average_complexity
            AND pg.process_count >= 100
        THEN 3

        ELSE 4
    END,

    pg.average_duration_hours DESC;

    -- ============================================================
-- 15. Executive summary
-- Consolidate the main operational process indicators
-- ============================================================

WITH process_metrics AS (

    SELECT
        COUNT(*) AS total_processes,

        ROUND(
            AVG(process_duration_hours),
            2
        ) AS average_duration_hours,

        ROUND(
            PERCENTILE_CONT(0.5)
            WITHIN GROUP (
                ORDER BY process_duration_hours
            )::numeric,
            2
        ) AS median_duration_hours,

        ROUND(
            AVG(customer_satisfaction),
            2
        ) AS average_customer_satisfaction,

        ROUND(
            AVG(complexity_score),
            2
        ) AS average_complexity_score

    FROM process_analysis
),

classification_metrics AS (

    SELECT
        ROUND(
            100.0 *
            COUNT(*) FILTER (
                WHERE process_classification = 'Standard'
            ) / COUNT(*),
            2
        ) AS standard_process_percent,

        ROUND(
            100.0 *
            COUNT(*) FILTER (
                WHERE process_classification = 'Complex'
            ) / COUNT(*),
            2
        ) AS complex_process_percent,

        ROUND(
            100.0 *
            COUNT(*) FILTER (
                WHERE process_classification = 'Exception / Rework'
            ) / COUNT(*),
            2
        ) AS exception_rework_percent

    FROM process_analysis
)

SELECT
    pm.total_processes,
    pm.average_duration_hours,
    pm.median_duration_hours,
    pm.average_customer_satisfaction,
    pm.average_complexity_score,
    cm.standard_process_percent,
    cm.complex_process_percent,
    cm.exception_rework_percent

FROM process_metrics pm

CROSS JOIN classification_metrics cm;