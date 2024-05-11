-- Supporting CTEs
WITH GroupedStatus AS (
    SELECT 
        times,
        status,
        ROW_NUMBER() OVER (ORDER BY times) - ROW_NUMBER() OVER (PARTITION BY status ORDER BY times) AS grp
    FROM 
        login_details
),
OnPeriods AS (
    SELECT 
        MIN(times) AS log_on,
        MAX(times) AS log_off
    FROM 
        GroupedStatus
    WHERE 
        status = 'on'
    GROUP BY 
        grp
)

-- Main Query
SELECT 
    log_on,
    DATEADD(MINUTE, 1, log_off) AS log_off,
    (DATEDIFF(SECOND, log_on, log_off) / 60) + 1 AS duration
FROM 
    OnPeriods;