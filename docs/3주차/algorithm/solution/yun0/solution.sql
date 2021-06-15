# 1. Game Play Analysis III
SELECT A.player_id,
       A.event_date,
       SUM(S.games_played) AS games_played_so_far
FROM Activity A
         LEFT JOIN Activity S
                   ON A.player_id = S.player_id
                       AND A.event_date >= S.event_date
GROUP BY A.player_id, A.event_date
;

SELECT A.player_id,
       A.event_date,
       SUM(S.games_played) AS games_played_so_far
FROM Activity A
         LEFT JOIN Activity S
                   ON A.player_id = S.player_id
                       AND DATEDIFF(A.event_date, S.event_date) >= 0
GROUP BY A.player_id, A.event_date
;

# 2. Game Play Analysis IV
SELECT ROUND(COUNT(A.player_id) / COUNT(M.player_id), 2) AS fraction
FROM (
         SELECT player_id,
                MIN(event_date) AS first_date
         FROM Activity M
         GROUP BY player_id
     ) M
         LEFT JOIN Activity A
                   ON A.player_id = M.player_id
                       AND A.event_date = M.first_date + 1
;

SELECT ROUND(COUNT(A.player_id) / COUNT(M.player_id), 2) AS fraction
FROM (
         SELECT player_id,
                MIN(event_date) AS first_date
         FROM Activity M
         GROUP BY player_id
     ) M
         LEFT JOIN Activity A
                   ON A.player_id = M.player_id
                       AND DATEDIFF(A.event_date, M.first_date) = 1
;

# 3. Game Play Analysis V
WITH Install AS (
    SELECT player_id,
           MIN(event_date) AS install_date
    FROM Activity
    GROUP BY player_id
)
SELECT I.install_date                                    AS install_dt,
       COUNT(I.player_id)                                AS installs,
       ROUND(COUNT(A.player_id) / COUNT(I.player_id), 2) AS Day1_retention
FROM Install I
         LEFT JOIN Activity A
                   ON A.player_id = I.player_id
                       AND A.event_date = I.install_date + 1
GROUP BY I.install_date
;

WITH Install AS (
    SELECT player_id,
           MIN(event_date) AS install_date
    FROM Activity
    GROUP BY player_id
)
SELECT I.install_date                                    AS install_dt,
       COUNT(I.player_id)                                AS installs,
       ROUND(COUNT(A.player_id) / COUNT(I.player_id), 2) AS Day1_retention
FROM Install I
         LEFT JOIN Activity A
                   ON A.player_id = I.player_id
                       AND DATEDIFF(A.event_date, I.install_date) = 1
GROUP BY I.install_date
;


# DATE 함수를 사용하는 게 더 빠르다.
