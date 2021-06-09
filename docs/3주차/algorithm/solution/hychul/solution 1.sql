WITH SUB (player_id, diff_date) AS (
    SELECT
        a.player_id,
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
    ROUND(SUM(CASE WHEN w.diff_date = 1 THEN 1 ELSE 0 END) / COUNT(DISTINCT w.player_id), 2) AS fraction
FROM
    SUB AS w
;