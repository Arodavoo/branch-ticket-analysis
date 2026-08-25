
-- ============================================================
-- BRANCH TICKET ANALYSIS
-- 01 - DATA QUALITY CHECKS
-- ============================================================

-- How many records are in the staging table?

SELECT
    COUNT(*) AS total_records
FROM staging_branch_tickets;


-- Are there duplicate ticket records?

SELECT
    ticket_id,
    COUNT(*) AS number_of_records
FROM staging_branch_tickets
GROUP BY ticket_id
HAVING COUNT(*) > 1
ORDER BY number_of_records DESC;


-- What status values exist in the raw data?

SELECT
    status,
    COUNT(*) AS number_of_records
FROM staging_branch_tickets
GROUP BY status
ORDER BY number_of_records DESC;


-- What request types exist in the raw data?

SELECT
    request_type,
    COUNT(*) AS number_of_records
FROM staging_branch_tickets
GROUP BY request_type
ORDER BY number_of_records DESC;


-- What turn-away reasons exist in the raw data?

SELECT
    turn_away_reason,
    COUNT(*) AS number_of_records
FROM staging_branch_tickets
GROUP BY turn_away_reason
ORDER BY number_of_records DESC;


-- How many turn-away records have a missing or unreliable reason?

SELECT
    turn_away_reason,
    COUNT(*) AS number_of_records
FROM staging_branch_tickets
WHERE turn_away_reason = 'NULL'
   OR turn_away_reason IS NULL
   OR turn_away_reason = 'N/A - Attended'
GROUP BY turn_away_reason
ORDER BY number_of_records DESC;


-- Are there invalid or unusual wait-time values?

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


-- What are the minimum and maximum valid wait times?

SELECT
    MIN(wait_time_minutes::NUMERIC) AS minimum_wait,
    MAX(wait_time_minutes::NUMERIC) AS maximum_wait
FROM staging_branch_tickets
WHERE wait_time_minutes ~ '^[0-9]+(\.[0-9]+)?$';


-- How many records contain the invalid wait-time value 9999?

SELECT
    COUNT(*) AS invalid_wait_time_records
FROM staging_branch_tickets
WHERE wait_time_minutes = '9999';


-- What status values exist after removing leading/trailing spaces and standardizing capitalization?

SELECT
    UPPER(TRIM(status)) AS standardized_status,
    COUNT(*) AS number_of_records
FROM staging_branch_tickets
GROUP BY UPPER(TRIM(status))
ORDER BY number_of_records DESC;



-- What request-type values exist after removing leading/trailing spaces and standardizing capitalization?

SELECT
    UPPER(TRIM(request_type)) AS standardized_request_type,
    COUNT(*) AS number_of_records
FROM staging_branch_tickets
GROUP BY UPPER(TRIM(request_type))
ORDER BY number_of_records DESC;
