select DISTINCT cp1.CART_ID
  from CART_PRODUCTS cp1
 inner join ( select CART_ID
                from ( select CART_ID, NAME
                         from CART_PRODUCTS cp
                        where CP.NAME = 'Yogurt' or CP.NAME =  'Milk'
                        group by CART_ID, NAME) T1
               group by CART_ID
              having count(*) > 1) cp2 on cp1.CART_ID = cp2.CART_ID