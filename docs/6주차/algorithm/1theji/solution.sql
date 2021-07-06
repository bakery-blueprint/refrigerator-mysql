--1
select ai.animal_id, ai.animal_type, ai.name
from animal_ins ai
inner join animal_outs ao
on ai.animal_id = ao.animal_id
where 1=1
and ai.sex_upon_intake like 'Intact%'
and ai.sex_upon_intake != ao.sex_upon_outcome

--2
select ai.animal_id, ai.name
from animal_ins ai
inner join animal_outs ao
on ai.animal_id = ao.animal_id
where 1=1
and ai.datetime > ao.datetime
order by ai.datetime

--3
select ai.animal_type, 
ifnull(ai.name,'No name') as name,
ai.sex_upon_intake
from animal_ins ai
where 1=1
order by ai.animal_id