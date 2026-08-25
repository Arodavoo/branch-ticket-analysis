-- ============================================================
-- BRANCH TICKET ANALYSIS
-- 02 - DATA CLEANING
-- ============================================================
-- How should inconsistent ticket statuses be standardized?

SELECT
    status,

    CASE
        WHEN UPPER(TRIM(status))
            IN ('TURNED_AWAY', 'TURNED AWAY')
            THEN 'TURNED_AWAY'

        WHEN UPPER(TRIM(status))
            IN ('ATTENDED', 'RESOLVED')
            THEN 'SERVED'

        ELSE NULL
    END AS adjusted_status

FROM staging_branch_tickets;


-- How should inconsistent request types be standardized?

SELECT
    request_type,

    UPPER(TRIM(request_type)) AS standardized_request_type

FROM staging_branch_tickets;


-- How should invalid wait-time values be identified?

SELECT
    wait_time_minutes,

    CASE
        WHEN wait_time_minutes ~ '^[0-9]+(\.[0-9]+)?$'
            AND wait_time_minutes::NUMERIC <> 9999
            THEN wait_time_minutes::NUMERIC

        ELSE NULL
    END AS cleaned_wait_time

FROM staging_branch_tickets;


-- How should inconsistent state values be standardized?

SELECT
    state_residence,

    CASE
        WHEN UPPER(TRIM(state_residence))
            IN ('OYO STATE', 'OYO')
            THEN 'Oyo'

        WHEN UPPER(TRIM(state_residence))
            = 'LAGOS'
            THEN 'Lagos'

        ELSE state_residence
    END AS cleaned_state

FROM staging_customers;


-- How should inconsistent gender values be standardized?

SELECT
    gender,

    CASE
        WHEN UPPER(TRIM(gender))
            IN ('F', 'FEMALE')
            THEN 'F'

        WHEN UPPER(TRIM(gender))
            IN ('M', 'MALE')
            THEN 'M'

        ELSE NULL
    END AS cleaned_gender

FROM staging_customers;
