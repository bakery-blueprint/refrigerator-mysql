SELECT
    a.viewer_id AS id
FROM
    Views a
INNER JOIN
    VIews b ON 
        a.article_id != b.article_id
        AND a.viewer_id = b.viewer_id
        AND a.view_date = b.view_date
GROUP BY
    a.viewer_id
ORDER BY
    a.viewer_id
