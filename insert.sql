-- 1º Insert into products
INSERT INTO PRODUCTS(
    SELECT distinct
        product,
        coffea,
        varietal, 
        origin,
        CASE 
            WHEN roasting IS NOT NULL AND roasting LIKE 'natural' THEN 'natural'
            WHEN roasting IS NOT NULL AND roasting LIKE 'blend' THEN 'mixture'
            ELSE 'high-roast'
        END,
        CASE 
            WHEN dcafprocess IS NOT NULL AND dcafprocess != '' THEN 1 
            ELSE 0 
        END
    FROM fsdb.trolley);


