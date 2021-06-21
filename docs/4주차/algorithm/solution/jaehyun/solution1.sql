select distinct t1.viewer_id
  from Views t1 inner join (select viewer_id, view_date, count(view_date) as viewcount
                              from Views
                             group by viewer_id, view_date
                            having viewcount >= 2) t2 on t1.viewer_id = t2.viewer_id and t1.view_date = t2.view_date
 group by t1.article_id, t1.viewer_id
having count(t1.article_id) < 2;