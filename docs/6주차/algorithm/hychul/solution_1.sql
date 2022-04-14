SELECT
    i.ANIMAL_ID AS ANIMAL_ID,
    i.ANIMAL_TYPE AS ANIMAL_TYPE,
    i.NAME AS NAME
FROM
    ANIMAL_INS i
INNER JOIN
    ANIMAL_OUTS o
    ON i.ANIMAL_ID = o.ANIMAL_ID AND 
    i.SEX_UPON_INTAKE != o.SEX_UPON_OUTCOME;