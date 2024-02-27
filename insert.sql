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


-- 2º Insert into Formats
INSERT INTO FORMATS(
    SELECT distinct
        CASE 
            WHEN PRODTYPE is not null and PRODTYPE like 'raw%' THEN 'raw grain'
            WHEN PRODTYPE is not null and PRODTYPE like 'roasted%' THEN 'roasted beans'
            WHEN PRODTYPE is not null and PRODTYPE like 'ground%' THEN 'ground'
            WHEN PRODTYPE is not null and PRODTYPE like 'freeze%' THEN 'freeze dried'
            WHEN PRODTYPE is not null and PRODTYPE like 'capsules%' THEN 'capsules'
            WHEN PRODTYPE is not null and PRODTYPE like 'prepared%' THEN 'prepared'
        END as format,
        packaging
    from fsdb.trolley);

