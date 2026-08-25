-- ============================================================
-- BRANCH TICKET ANALYSIS
-- 04 - WAIT TIME ANALYSIS
-- ============================================================


-- Checking the different wait-time values in the data.

SELECT
    wait_time_minutes,
    COUNT(*) AS number_of_records

FROM staging_branch_tickets

GROUP BY wait_time_minutes

ORDER BY
    CASE
        WHEN wait_time_minutes ~ '^[0-9]+(\.[0-9]+)?$'
        THEN wait_time_minutes::NUMERIC
        ELSE NULL
    END DESC;


-- Looking at the valid wait times only.
-- "NULL" and other invalid values are left out.

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
