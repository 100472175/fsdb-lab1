-- 1st Insert into products
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


-- 2nd Insert into Formats
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
INSERT INTO Providers (CIF, provider_name, sales_phone, sales_email, sales_name, provider_address)
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


-- 5th insert Addresses
/*
Comments: 
    - We are taking the n/n from the bill_gate and substituting it for null.
    - We are also taking the floor and substituting it for a number, if it is a number, or null if it is not.
    - We are taking the city and country and joining them together to generate the city_country.
*/
INSERT INTO Addresses (username, street_type, street_name, gateway_num, block_num, stairs_id, floor, door, ZIP_code, city_country)
    select distinct
        username,
        bill_waytype,
        bill_wayname,
        CASE
            WHEN REGEXP_LIKE(TRIM(bill_gate), '^[0-9]+$') THEN TO_NUMBER(TRIM(bill_gate))
            ELSE null
        END as bill_gate,
        bill_block,
        bill_stairw,
        CASE
            WHEN bill_floor IS NOT NULL AND bill_floor LIKE 'First%' THEN '1' 
            WHEN bill_floor IS NOT NULL AND bill_floor LIKE 'Second%' THEN '2'
            WHEN bill_floor IS NOT NULL AND bill_floor LIKE 'Third%' THEN '3'
            WHEN bill_floor IS NOT NULL AND bill_floor LIKE 'Fourth%' THEN '4'
            WHEN bill_floor IS NOT NULL AND bill_floor LIKE 'Fifth%' THEN '5'
            WHEN bill_floor IS NOT NULL AND bill_floor LIKE 'Sixth%' THEN '6'
            WHEN bill_floor IS NOT NULL AND bill_floor LIKE 'Ground%' THEN '0'
            WHEN REGEXP_LIKE(TRIM(bill_floor), '^[0-9]+$') THEN TRIM(bill_floor)
            ELSE null
        END as floor_num,
        bill_door,
        bill_zip,
        TRIm(bill_town) || ', ' || TRIM(bill_country) as city_country
        from fsdb.trolley where username is not null 
                            and bill_waytype is not null
                            and bill_wayname is not null
                            and bill_gate is not null
                            and bill_zip is not null
                            and bill_country is not null;


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



-- 7th Insert into Product Providers
INSERT INTO Providers_References(provider_cif, product_reference, price)
    Select distinct
        PROV_TAXID,
        barcode,
        CASE 
            WHEN (barcode = 'OII22831Q738220' AND PROV_TAXID = 'V16878068R') THEN 18.03
            WHEN (barcode = 'IIO51869I990018' AND PROV_TAXID = 'D14430184F') THEN 81.13
            WHEN (barcode = 'OQI13224O987826' AND PROV_TAXID = 'B29558354L') THEN 3.42
            WHEN (barcode = 'QOO64416O550165' AND PROV_TAXID = 'N13525202Y') THEN 5.56
            WHEN (barcode = 'QII47432I109160' AND PROV_TAXID = 'R63301935R') THEN 5.63
            ELSE to_number(regexp_replace(regexp_replace(cost_price, '[^0-9.]', ''), '[.]', ','))
        END as price
    from fsdb.catalogue where PROV_TAXID is not null 
                        and barcode is not null 
                        and cost_price is not null;





-- Deliveries
INSERT INTO Deliveries (delivery_date, delivery_address)
SELECT DISTINCT
    TO_DATE(dliv_date, 'YYYY/MM/DD') AS delivery_date,
     TRIM(',' FROM
        CONCAT(
            CONCAT(
                CONCAT(
                    CONCAT(
                        CONCAT(
                            CONCAT(
                                CONCAT(
                                    CONCAT(
                                        CONCAT(
                                            CONCAT(
                                                CONCAT(
                                                    CASE WHEN TRIM(dliv_waytype) IS NOT NULL THEN TRIM(dliv_waytype) ELSE '' END,
                                                    CASE WHEN TRIM(dliv_wayname) IS NOT NULL THEN TRIM(dliv_wayname) || ', ' ELSE '' END
                                                ),
                                                CASE WHEN TRIM(dliv_gate) IS NOT NULL THEN TRIM(dliv_gate) || ', ' ELSE '' END
                                            ),
                                            CASE WHEN TRIM(dliv_block) IS NOT NULL THEN TRIM(dliv_block) || ', ' ELSE '' END
                                        ),
                                        CASE WHEN TRIM(dliv_stairw) IS NOT NULL THEN TRIM(dliv_stairw) || ', ' ELSE '' END
                                    ),
                                    CASE WHEN TRIM(dliv_floor) IS NOT NULL THEN TRIM(dliv_floor) || ', ' ELSE '' END
                                ),
                                CASE WHEN TRIM(dliv_door) IS NOT NULL THEN TRIM(dliv_door) || ', ' ELSE '' END
                            ),
                            CASE WHEN TRIM(dliv_zip) IS NOT NULL THEN TRIM(dliv_zip) || ', ' ELSE '' END
                        ),
                        CASE WHEN TRIM(dliv_town) IS NOT NULL THEN TRIM(dliv_town) || ', ' ELSE '' END
                    ),
                    CASE WHEN TRIM(dliv_country) IS NOT NULL THEN TRIM(dliv_country) ELSE '' END
                ), ''), '')
    ) AS delivery_address
FROM fsdb.trolley
WHERE dliv_date IS NOT NULL;







-- Registered_Clients_Informations

INSERT INTO Registered_Clients_Informations (username, client_password, registration_date, peronal_data, loyal_discount)
    SELECT
        username,
        MIN(user_passw) AS user_passw,
        MIN(TO_DATE(reg_date, 'YYYY/MM/DD')) AS registration_date,
        MIN(TRIM(client_name || ' ' || client_surn1 || ' ' || client_surn2)) AS full_name,
        MIN(discount) AS discount
    FROM fsdb.trolley
    WHERE username IS NOT NULL 
        AND user_passw IS NOT NULL 
        AND reg_date IS NOT NULL 
        AND client_name IS NOT NULL 
        AND client_surn1 IS NOT NULL 
        AND discount IS NOT NULL 
    GROUP BY
        username
    Order by
        username;
            


-- Credit_Cards
INSERT INTO Credit_Cards (card_number, expiration_date, holder, finance_company, username)
Select distinct
    card_number,
    to_date(card_expiratn, 'MM/YY') as card_expiration,
    card_holder,
    card_company,
    username
from fsdb.trolley where card_number is not null AND (length(card_number) > 0)
                    and card_expiratn is not null 
                    and card_holder is not null 
                    and card_company is not null
                    and username is not null;



-- Clients
insert into Clients (main_contact, alt_contact, registered_client_information)
	select
    NVL(a.CLIENT_EMAIL, a.CLIENT_MOBILE) as main_contact,
    CASE 
        WHEN a.CLIENT_EMAIL IS NOT NULL THEN a.CLIENT_MOBILE
        ELSE NULL
    END as alt_contact,
    a.USERNAME registered_client_information
	from fsdb.trolley a
	group by a.CLIENT_EMAIL ,a.CLIENT_MOBILE , a.USERNAME;


-- Purchases


-- Opinions_References
INSERT INTO Opinions_References(registered_client, product_reference, score, text_opinion, likes, endorsement, references_date)
    select 
    A.USERNAME,
    A.BARCODE,
    A.SCORE,
    A.TEXT,
    A.LIKES,
    NVL(A.ENDORSED, 0), 
    to_date(a.POST_DATE||' '||a.POST_TIME,'yyyy/mm/dd hh:mi:ss pm')
    from fsdb.posts A,
        Registered_Clients_Informations B,
        Product_References C
    where A.USERNAME = B.username and A.BARCODE = C.barcode;

-- Opinions_Products
INSERT INTO Opinions_Products(registered_client, product, score, text_opinion, likes, endorsement, products_date)
    select 
    A.USERNAME,
    A.PRODUCT,
    A.SCORE,
    A.TEXT,
    A.LIKES,
    NVL(A.ENDORSED, 0),
    to_date(a.POST_DATE||' '||a.POST_TIME,'yyyy/mm/dd hh:mi:ss pm')
    from fsdb.posts A, 
        Registered_Clients_Informations B, 
        Products C
    where A.USERNAME = B.username and A.product = C.name;


/*
Check wich ones had problems, aka, there are two prices for the same cif and barcode.
Select PROV_TAXID, barcode, cost_price 
    from fsdb.catalogue 
        where barcode IN 
        ('QOO64416O550165',
         'IIO51869I990018',
         'OQI13224O987826',
         'OII22831Q738220',
         'QII47432I109160');

V16878068R OII22831Q738220 18.03 ? --
D14430184F IIO51869I990018 81.13 ?--
B29558354L OQI13224O987826 3.42 ? --
N13525202Y QOO64416O550165 5.56 ? --
R63301935R QII47432I109160 5.63 ? --
*/
