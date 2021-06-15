select round(
    (select count(*) as 'user'
     from Activity t1
              inner join ( SELECT player_id, min(event_date) as `date`
                           from Activity
                           group by player_id) t2
                         on t1.player_id = t2.player_id
                             and (t1.event_date - t2.date) = 1) 
    /
    (select count(*) total
             from ( select 1
                    from Activity t1
                    group by player_id) t2), 2) as 'fraction'