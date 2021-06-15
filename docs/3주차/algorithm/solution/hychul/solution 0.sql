SELECT
    a.player_id AS player_id,
    a.event_date AS event_date,
    SUM(b.games_played) AS games_played_so_far
FROM
    Activity a
JOIN
    Activity b
    ON a.player_id = b.player_id
WHERE
    a.event_date >= b.event_date
GROUP BY
    a.player_id, a.event_date
;