# 1. 고양이와 개는 몇 마리 있을까
#    1. https://programmers.co.kr/learn/courses/30/lessons/59040
# Data
CREATE TABLE ANIMAL_INS
(
    ANIMAL_ID        VARCHAR(50) NOT NULL,
    ANIMAL_TYPE      VARCHAR(50) NOT NULL,
    DATETIME         DATETIME    NOT NULL,
    INTAKE_CONDITION VARCHAR(50) NOT NULL,
    NAME             VARCHAR(50) NULL,
    SEX_UPON_INTAKE  VARCHAR(50) NOT NULL
);
INSERT INTO ANIMAL_INS
VALUES ('A373219', 'Cat', '2014-07-29 11:43:00', 'Normal', 'Ella', 'Spayed Female'),
       ('A377750', 'Dog', '2017-10-25 17:17:00', 'Normal', 'Lucy', 'Spayed Female'),
       ('A354540', 'Cat', '2014-12-11 11:48:00', 'Normal', 'Tux', 'Neutered Male');

# Answer
SELECT ANIMAL_TYPE,
       COUNT(ANIMAL_ID) AS count
FROM ANIMAL_INS
WHERE ANIMAL_TYPE IN ('Cat', 'Dog')
GROUP BY ANIMAL_TYPE
ORDER BY ANIMAL_TYPE;

# 2. 헤비 유저가 소유한 장소
#    1. https://programmers.co.kr/learn/courses/30/lessons/77487
# Data
CREATE TABLE PLACES
(
    ID      INT,
    NAME    VARCHAR(100),
    HOST_ID INT
);
INSERT INTO PLACES
VALUES (4431977, 'BOUTIQUE STAYS - Somerset Terrace, Pet Friendly', 760849),
       (5194998, 'BOUTIQUE STAYS - Elwood Beaches 3, Pet Friendly', 760849),
       (16045624, 'Urban Jungle in the Heart of Melbourne', 30900122),
       (17810814, 'Stylish Bayside Retreat with a Luscious Garden', 760849),
       (22740286, 'FREE PARKING - The Velvet Lux in Melbourne CBD', 30900122),
       (22868779, '★ Fresh Fitzroy Pad with City Views! ★', 21058208)
;

# Answer
SELECT p.ID, p.NAME, p.HOST_ID
FROM PLACES p
         INNER JOIN (SELECT HOST_ID, COUNT(ID) AS count
                     FROM PLACES
                     GROUP BY HOST_ID) h
                    ON p.HOST_ID = h.HOST_ID
                        AND count >= 2
ORDER BY ID;

# 3. 우유와 요거트가 담긴 장바구니
#    1. https://programmers.co.kr/learn/courses/30/lessons/62284
# Data
CREATE TABLE CART_PRODUCTS
(
    ID      INT,
    CART_ID INT,
    NAME    VARCHAR(100),
    PRICE   INT
);
INSERT INTO CART_PRODUCTS
VALUES (1630, 83, 'Cereal', 3980),
       (1631, 83, 'Multipurpose Supply', 3900),
       (5491, 286, 'Yogurt', 2980),
       (5504, 286, 'Milk', 1880),
       (8435, 448, 'Milk', 1880),
       (8437, 448, 'Yogurt', 2980),
       (8438, 448, 'Tea', 11000),
       (20236, 1034, 'Yogurt', 2980),
       (20237, 1034, 'Butter', 4890);

# Answer
SELECT DISTINCT M.CART_ID
FROM CART_PRODUCTS M
         INNER JOIN CART_PRODUCTS Y ON M.CART_ID = Y.CART_ID
    AND Y.NAME = 'Yogurt'
WHERE M.NAME = 'Milk';
