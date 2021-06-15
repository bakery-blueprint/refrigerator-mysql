-- 534. Game Play Analysis III
SELECT A.player_id,
       A.event_date,
       Sum(B.games_played) AS games_played_so_far
FROM   activity A
       INNER JOIN activity B
               ON A.event_date >= B.event_date
                  AND A.player_id = B.player_id
GROUP  BY A.player_id,
          A.event_date

-- 550. Game Play Analysis IV

SELECT Round(COUNT(t2.player_id) / COUNT(t1.player_id), 2) AS fraction
FROM   (SELECT player_id,
               Min(event_date) AS first_login
        FROM   activity
        GROUP  BY player_id) t1
       LEFT JOIN activity t2
              ON t1.player_id = t2.player_id
                 AND t1.first_login = Date_add(t2.event_date, interval - 1 DAY)

-- 1097. Game Play Analysis V
SELECT t1.first_login                                      AS install_dt,
       COUNT(t1.player_id)                                 AS installs,
       Round(COUNT(t2.player_id) / COUNT(t1.player_id), 2) AS Day1_retention
FROM   (SELECT player_id,
               Min(event_date) AS first_login
        FROM   activity
        GROUP  BY player_id) t1
       LEFT JOIN activity t2
              ON t1.player_id = t2.player_id
                 AND t1.first_login = Date_add(t2.event_date, interval - 1 DAY)
GROUP  BY first_login
