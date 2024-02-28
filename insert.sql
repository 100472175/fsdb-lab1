-- 1th Insert into products
INSERT INTO PRODUCTS(name, species, variety, origin, roasting, decaffeinated)
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
            WHEN decaf IS NOT NULL AND decaf LIKE 'yes' THEN 1 
            ELSE 0 
        END
    FROM fsdb.catalogue
    WHERE product IS NOT NULL 
        AND coffea IS NOT NULL 
        AND varietal IS NOT NULL 
        AND origin IS NOT NULL 
        AND roasting IS NOT NULL 
        AND decaf IS NOT NULL;


-- 2th Insert into Formats
INSERT INTO FORMATS(format_type_f, amount)
    SELECT distinct
        CASE 
            WHEN FORMAT is not null and FORMAT like 'raw%' THEN 'raw grain'
            WHEN FORMAT is not null and FORMAT like 'roasted%' THEN 'roasted beans'
            WHEN FORMAT is not null and FORMAT like 'ground%' THEN 'ground'
            WHEN FORMAT is not null and FORMAT like 'freeze%' THEN 'freeze dried'
            WHEN FORMAT is not null and FORMAT like 'capsules%' THEN 'capsules'
            WHEN FORMAT is not null and FORMAT like 'prepared%' THEN 'prepared'
        END as format,
        packaging 
    from fsdb.catalogue 
        where FORMAT is not null 
        and packaging is not null;

-- 3th Insert into Product References
INSERT INTO Product_References (barcode, product, format_format_type, format_amount, price, stock, min_stock, max_stock)
Select distinct
    barcode,
    product,
    CASE 
        WHEN FORMAT is not null and FORMAT like 'raw%' THEN 'raw grain'
        WHEN FORMAT is not null and FORMAT like 'roasted%' THEN 'roasted beans'
        WHEN FORMAT is not null and FORMAT like 'ground%' THEN 'ground'
        WHEN FORMAT is not null and FORMAT like 'freeze%' THEN 'freeze dried'
        WHEN FORMAT is not null and FORMAT like 'capsules%' THEN 'capsules'
        WHEN FORMAT is not null and FORMAT like 'prepared%' THEN 'prepared'
    END as format,
    packaging,
    to_number(regexp_replace(regexp_replace(retail_price, '[^0-9.]', ''), '[.]', ',')) as base_price,
    to_number(CUR_STOCK) as cur_stock,
    to_number(MIN_STOCK) as MIN_STOCK,
    to_number(MAX_STOCK) as MAX_STOCK
from fsdb.catalogue where barcode is not null 
                    and product is not null 
                    and packaging is not null 
                    and retail_price is not null 
                    and cur_stock is not null
                    and MIN_STOCK is not null
                    and MAX_STOCK is not null;

-- 4th Insert into Providers
INSERT INTO Providers (CIF, provider_name, sales_phone, sales_email, sales_name, provider_adress)
Select distinct
    PROV_TAXID, 
    SUPPLIER,
    PROV_MOBILE,
    PROV_EMAIL,
    --PROV_BANKACC,
    PROV_PERSON,
    PROV_ADDRESS
from fsdb.catalogue where PROV_TAXID is not null 
                    and SUPPLIER is not null 
                    and PROV_MOBILE is not null 
                    and PROV_EMAIL is not null 
                    and PROV_BANKACC is not null 
                    and PROV_PERSON is not null 
                    and PROV_MOBILE is not null;


-- 5th Insert into Product Providers
INSERT INTO Providers_References (provider_cif, product_reference, price)
Select distinct
    PROV_TAXID,
    barcode,
    to_number(regexp_replace(regexp_replace(retail_price, '[^0-9.]', ''), '[.]', ',')) as price
from fsdb.catalogue where PROV_TAXID is not null 
                    and barcode is not null 
                    and retail_price is not null;


-- 6th Insert Replacement Orders
--to_char(to_date(regexp_replace(ORDERDATE, '[\s]', ''), 'YYYY/MM/DD'), 'DD/MM/YYYY') as order_date,
-- We are leaving this insertion commented and unfiniched as the date is not inside the database, thus, there is information missing.
-- In our model, we have the date as a primary key, so we cannot leave it empty.
/*
SELECT DISTINCT
    to_date(regexp_replace(t.ORDERDATE, '[\s]', ''), 'YYYY/MM/DD') as order_date,
    t.BARCODE,
    c.PROV_TAXID,
    t.QUANTITY,
    to_date(regexp_replace(t.DLIV_DATE, '[\s]', ''), 'YYYY/MM/DD') as delivery_date,
    t.QUANTITY * to_number(regexp_replace(regexp_replace(c.RETAIL_PRICE, '[^0-9.]', ''), '[.]', ',')) as total_price
    CASE 
        WHEN 
FROM fsdb.trolley t
JOIN fsdb.catalogue c ON t.barcode = c.barcode;

*/

-- select count(BILL_TOWN) from fsdb.trolley;