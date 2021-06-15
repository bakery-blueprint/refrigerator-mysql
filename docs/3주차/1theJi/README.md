##1
select 
		player_id
		, event_date
		, SUM(games_played) OVER(PARTITION by player_id order by event_date asc) as games_played_so_far		
from Activity

##2 전체플레이어중에 2일연속 로그인한 플레이어의 비
SELECT 
		ROUND(count(player_id)/(select count(DISTINCT player_id) from Activity a),2) as fraction 
FROM
	(
		SELECT 
				A.player_id , A.event_date , A.first_login_date, DATEDIFF(A.event_date, A.first_login_date) AS DIFF
		FROM (
				SELECT 
						player_id
						, event_date
						, min(event_date) over(PARTITION BY player_id order by event_date asc) as first_login_date		
				FROM Activity
			) AS A
	) AS B
WHERE 1=1
AND diff = 1

##3 
SELECT  
   		A1.first_login_date as install_dt
 		, count(distinct A1.player_id) as installs
  		, round(sum(DIFF)/count(distinct A1.player_id),2) Day1_retention 
FROM 
 	(
		SELECT 
				CTE.player_id 
				, CTE.games_played
				, CTE.event_date 
				, MAX(event_date) OVER(PARTITION BY player_id order by player_id desc) AS max_date
				, CTE.first_login_date
				, row_number()over(partition by CTE.player_id order by CTE.event_date desc) rn
				, CASE WHEN DATEDIFF(CTE.event_date, CTE.first_login_date) = 1
					   THEN 1
				       ELSE 0
				  END
				AS DIFF
		FROM (
				SELECT 
						player_id
						, event_date
						, games_played 
						, device_id 
						, min(event_date) over(PARTITION BY player_id order by event_date asc) as first_login_date		
				FROM Activity
			) AS CTE
		
	) AS A1
WHERE 1=1
and rn = 1
group by A1.first_login_date
;

with prep as (
select *
    , row_number()over(partition by player_id order by event_date) rn 
    , if(datediff(
    				lead(event_date,1)over(partition by player_id order by event_date), event_date
    			 ) = 1
    	  , 1,0
    	) isLoginNextDay
    from Activity 
)
select 
		 event_date install_dt
       , count(distinct player_id) installs
       , round(sum(isLoginNextDay)/count(distinct player_id),2) Day1_retention 
from prep
 where rn=1 
group by event_date
