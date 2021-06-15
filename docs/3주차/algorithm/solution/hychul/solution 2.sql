WITH SUB (player_id, first_date, diff_date) AS (
    SELECT
        a.player_id,
        b.first_date,
        (a.event_date - b.first_date)
    FROM
        Activity a
        INNER JOIN
        (
            SELECT
                player_id, 
                MIN(event_date) AS first_date
            from 
                Activity
            group by 
                player_id
        ) b
        ON
        a.player_id = b.player_id
)
SELECT
    w.first_date AS install_dt,
    COUNT(DISTINCT w.player_id) AS installs,
    ROUND(SUM(CASE WHEN w.diff_date = 1 THEN 1 ELSE 0 END) / COUNT(DISTINCT w.player_id), 2) AS Day1_retention
FROM
    SUB AS w
GROUP BY
    w.first_date
;