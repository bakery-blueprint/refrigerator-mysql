select s.Score
      , (select count(*) + 1
           from ( select Score
                    from Scores t2
                   group by t2.Score) ts1
          where ts1.Score> s.Score) as 'rank'
  from Scores s
 order by s.Score DESC;