-- 1. 보호소에서 중성화한 동물 (level 4)
--    1. https://programmers.co.kr/learn/courses/30/lessons/59045
### Data
# CREATE TABLE ANIMAL_OUTS
# (
#     ANIMAL_ID        VARCHAR(50) NOT NULL,
#     ANIMAL_TYPE      VARCHAR(50) NOT NULL,
#     DATETIME         DATETIME    NOT NULL,
#     NAME             VARCHAR(50) NULL,
#     SEX_UPON_OUTCOME VARCHAR(50) NOT NULL
# );
# INSERT INTO ANIMAL_INS
# VALUES ('A367438', 'Dog', '2015-09-10 16:01:00', 'Normal', 'Cookie', 'Spayed Female'),
#        ('A382192', 'Dog', '2015-03-13 13:14:00', 'Normal', 'Maxwell 2', 'Intact Male'),
#        ('A405494', 'Dog', '2014-05-16 14:17:00', 'Normal', 'Kaila', 'Spayed Female'),
#        ('A410330', 'Dog', '2016-09-11 14:09:00', 'Sick', 'Chewy', 'Intact Female');
# INSERT INTO ANIMAL_OUTS
# VALUES ('A367438', 'Dog', '2015-09-12 13:30:00', 'Cookie', 'Spayed Female'),
#        ('A382192', 'Dog', '2015-03-16 13:46:00', 'Maxwell 2', 'Neutered Male'),
#        ('A405494', 'Dog', '2014-05-20 11:44:00', 'Kaila', 'Spayed Female'),
#        ('A410330', 'Dog', '2016-09-13 13:46:00', 'Chewy', 'Spayed Female');

### Answer
SELECT i.ANIMAL_ID,
       i.ANIMAL_TYPE,
       i.NAME
FROM ANIMAL_INS i
         INNER JOIN ANIMAL_OUTS o
             ON i.ANIMAL_ID = o.ANIMAL_ID
AND o.SEX_UPON_OUTCOME != i.SEX_UPON_INTAKE
WHERE i.SEX_UPON_INTAKE LIKE 'Intact%';



-- 2. 있었는데요 없었습니다 (level 3)
--    1. https://programmers.co.kr/learn/courses/30/lessons/59043
### Data
# INSERT INTO ANIMAL_INS
# VALUES ('A350276', 'Cat', '2017-08-13 13:50:00', 'Normal', 'Jewel', 'Spayed Female'),
#        ('A381217', 'Dog', '2017-07-08 09:41:00', 'Sick', 'Cherokee', 'Neutered Male');
# INSERT INTO ANIMAL_OUTS
# VALUES ('A350276', 'Cat', '2018-01-28 17:51:00', 'Jewel', 'Spayed Female'),
#        ('A381217', 'Dog', '2017-06-09 18:51:00', 'Cherokee', 'Neutered Male');
### Answer
SELECT o.ANIMAL_ID,
       o.NAME
FROM ANIMAL_OUTS o
         INNER JOIN ANIMAL_INS i
                    ON o.ANIMAL_ID = i.ANIMAL_ID
                        AND i.DATETIME > o.DATETIME
ORDER BY i.DATETIME;

-- 3. NULL 처리하기 (level 2)
--    1. https://programmers.co.kr/learn/courses/30/lessons/59410
### Data
# INSERT INTO ANIMAL_INS
# VALUES ('A368930', 'Dog', '2014-06-08 13:20:00', 'Normal', NULL, 'Spayed Female');
### Answer
SELECT ANIMAL_TYPE,
       IFNULL(NAME, 'No name') AS NAME,
       SEX_UPON_INTAKE
FROM ANIMAL_INS;
