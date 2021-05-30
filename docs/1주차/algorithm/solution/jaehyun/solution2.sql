SELECT sale_date 
       ,(SELECT sold_num 
           FROM sales x 
          WHERE s.sale_date = x.sale_date 
                AND fruit = 'apples') - (SELECT sold_num 
                                           FROM sales x 
                                          WHERE s.sale_date = x.sale_date 
                                                AND fruit = 'oranges') AS 'diff' 
  FROM sales s 
 GROUP BY s.sale_date; 