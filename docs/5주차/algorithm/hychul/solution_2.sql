SELECT
    p.id AS ID,
    p.name AS NAME,
    p.host_id AS HOST_ID
FROM
    PLACES p
LEFT JOIN
    (
        SELECT
            host_id AS host_id,
            COUNT(*) AS cnt
        FROM
            PLACES
        GROUP BY
            host_id
    ) sub
    ON p.host_id = sub.host_id
WHERE
    sub.cnt > 1;

