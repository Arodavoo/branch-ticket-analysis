-- ============================================================
-- BRANCH TICKET ANALYSIS
-- 03 - BRANCH ANALYSIS
-- ============================================================


-- Which branches handle the most customer demand, and which branches have the highest turn-away rate?

SELECT
    branch_id,

    COUNT(*) AS total_tickets,

    SUM(
        CASE
            WHEN UPPER(TRIM(status))
                IN ('ATTENDED', 'RESOLVED')
            THEN 1
            ELSE 0
        END
    ) AS served,

    SUM(
        CASE
            WHEN UPPER(TRIM(status))
                IN ('TURNED_AWAY', 'TURNED AWAY')
            THEN 1
            ELSE 0
        END
    ) AS turned_away,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN UPPER(TRIM(status))
                    IN ('TURNED_AWAY', 'TURNED AWAY')
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS turn_away_rate

FROM staging_branch_tickets

GROUP BY branch_id

ORDER BY total_tickets DESC;


-- How much capacity is being used by each branch?

SELECT
    branch_id,

    COUNT(*) AS total_tickets,

    MAX(capacity) AS branch_capacity,

    ROUND(
        100.0 * COUNT(*) / NULLIF(MAX(capacity), 0),
        2
    ) AS capacity_usage_pct

FROM staging_branch_tickets

GROUP BY branch_id

ORDER BY capacity_usage_pct DESC;


-- Does branch capacity appear to be related to turn-away rate?

WITH branch_summary AS (

    SELECT
        branch_id,

        MAX(capacity) AS branch_capacity,

        COUNT(*) AS total_tickets,

        SUM(
            CASE
                WHEN UPPER(TRIM(status))
                    IN ('TURNED_AWAY', 'TURNED AWAY')
                THEN 1
                ELSE 0
            END
        ) AS turned_away

    FROM staging_branch_tickets

    GROUP BY branch_id
)

SELECT
    CORR(
        branch_capacity,
        turned_away::NUMERIC / total_tickets
    ) AS capacity_turnaway_correlation

FROM branch_summary;
