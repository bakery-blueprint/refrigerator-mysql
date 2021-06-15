select t2.date as 'install_dt', total as 'installs', round(ifnull(count(t5.user), 0) / total, 2) as 'Day1_retention'
  from (select t1.date, count(*) total
           from ( select a1.player_id , min(a1.event_date) as `date`
                    from Activity a1
                   group by a1.player_id) t1
 group by t1.date) t2  left join ( select count(t4.player_id) as 'user', t4.date
                                   from Activity t3
                                            inner join ( select a2.player_id, min(a2.event_date) as `date`
                                                         from Activity a2
                                                         group by a2.player_id) t4 on t3.player_id = t4.player_id and (t3.event_date - t4.date) = 1
                                   group by t4.player_id, t4.date) t5 on t2.date = t5.date
group by t2.date;
;
