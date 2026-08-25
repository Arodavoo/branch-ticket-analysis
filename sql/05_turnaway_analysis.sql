-- ============================================================
-- BRANCH TICKET ANALYSIS
-- 05 - TURN-AWAY ANALYSIS
-- ============================================================


-- What is the overall turn-away rate?

SELECT
    COUNT(*) AS total_tickets,

    SUM(
        CASE
            WHEN UPPER(TRIM(status))
                IN ('TURNED_AWAY', 'TURNED AWAY')
            THEN 1
            ELSE 0
        END
    ) AS turned_away,

    SUM(
        CASE
            WHEN UPPER(TRIM(status))
                IN ('ATTENDED', 'RESOLVED')
            THEN 1
            ELSE 0
        END
    ) AS served,

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


-- What are the main reasons customers are turned away?

SELECT
    turn_away_reason,

    COUNT(*) AS turned_away

FROM staging_branch_tickets

WHERE UPPER(TRIM(status))
        IN ('TURNED_AWAY', 'TURNED AWAY')

GROUP BY turn_away_reason

ORDER BY turned_away DESC;


-- Which branches have the most turn-aways for each reason?

SELECT
    branch_id,
    turn_away_reason,
    COUNT(*) AS number_of_records

FROM staging_branch_tickets

WHERE UPPER(TRIM(status))
        IN ('TURNED_AWAY', 'TURNED AWAY')

GROUP BY
    branch_id,
    turn_away_reason

ORDER BY
    branch_id,
    number_of_records DESC;


-- Which request types have the highest turn-away rates?

SELECT
    UPPER(TRIM(request_type)) AS standardized_request_type,

    COUNT(*) AS total_tickets,

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

GROUP BY UPPER(TRIM(request_type))

ORDER BY turn_away_rate DESC;


-- Which request types and reasons appear together most often?

SELECT
    UPPER(TRIM(request_type)) AS standardized_request_type,

    turn_away_reason,

    COUNT(*) AS turned_away

FROM staging_branch_tickets

WHERE UPPER(TRIM(status))
        IN ('TURNED_AWAY', 'TURNED AWAY')

GROUP BY
    UPPER(TRIM(request_type)),
    turn_away_reason

ORDER BY turned_away DESC;


-- Are turn-aways concentrated at particular hours?

SELECT
    EXTRACT(HOUR FROM timestamp)::INT AS hour_of_day,

    COUNT(*) AS total_tickets,

    SUM(
        CASE
            WHEN UPPER(TRIM(status))
                IN ('TURNED_AWAY', 'TURNED AWAY')
            THEN 1
            ELSE 0
        END
    ) AS turned_away,

    SUM(
        CASE
            WHEN UPPER(TRIM(status))
                IN ('ATTENDED', 'RESOLVED')
            THEN 1
            ELSE 0
        END
    ) AS served,

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

GROUP BY EXTRACT(HOUR FROM timestamp)

ORDER BY hour_of_day;


-- Are turn-aways higher on particular days?

SELECT
    TO_CHAR(timestamp, 'Day') AS day_of_week,

    COUNT(*) AS total_tickets,

    SUM(
        CASE
            WHEN UPPER(TRIM(status))
                IN ('TURNED_AWAY', 'TURNED AWAY')
            THEN 1
            ELSE 0
        END
    ) AS turned_away,

    SUM(
        CASE
            WHEN UPPER(TRIM(status))
                IN ('ATTENDED', 'RESOLVED')
            THEN 1
            ELSE 0
        END
    ) AS served,

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

GROUP BY TO_CHAR(timestamp, 'Day')

ORDER BY
    MIN(EXTRACT(ISODOW FROM timestamp));
