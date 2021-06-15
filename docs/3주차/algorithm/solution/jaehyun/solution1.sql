select player_id
     , event_date
     , (select sum(count)
          from ( select t1.player_id
                    , t1.event_date
                    , sum(t1.games_played) as 'count'
                 from Activity t1
                group by t1.player_id, t1.event_date) t3
          where t3.player_id = t2.player_id
            and t3.event_date <= t2.event_date
         ) as 'games_played_so_far'
  from Activity t2;