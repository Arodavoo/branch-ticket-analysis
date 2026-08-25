-- ============================================================
-- BRANCH TICKET ANALYSIS
-- 06 - FINAL KPIs
-- ============================================================


-- Overall ticket performance.

SELECT
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

FROM staging_branch_tickets;


-- Final wait-time KPIs.

SELECT
    COUNT(*) AS valid_wait_times,

    MIN(wait_time_minutes::NUMERIC) AS minimum_wait,

    MAX(wait_time_minutes::NUMERIC) AS maximum_wait,

    ROUND(
        AVG(wait_time_minutes::NUMERIC)::NUMERIC,
        2
    ) AS average_wait,

    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY wait_time_minutes::NUMERIC
        )::NUMERIC,
        2
    ) AS median_wait

FROM staging_branch_tickets

WHERE wait_time_minutes ~ '^[0-9]+(\.[0-9]+)?$'
  AND wait_time_minutes::NUMERIC <> 9999;


-- Number of turn-aways with a missing or unreliable reason.

SELECT
    COUNT(*) AS unknown_turnaway_reasons

FROM staging_branch_tickets

WHERE UPPER(TRIM(status))
        IN ('TURNED_AWAY', 'TURNED AWAY')

  AND (
        turn_away_reason IS NULL
        OR turn_away_reason = 'NULL'
        OR turn_away_reason = 'N/A - Attended'
      );


-- Main turn-away reasons.

SELECT
    turn_away_reason,

    COUNT(*) AS turned_away

FROM staging_branch_tickets

WHERE UPPER(TRIM(status))
        IN ('TURNED_AWAY', 'TURNED AWAY')

GROUP BY turn_away_reason

ORDER BY turned_away DESC;
