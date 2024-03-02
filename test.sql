INSERT INTO Purchases(customer,
                    mobile,
                    delivery_date,
                    purchases_address,
                    product_reference,
                    amount,
                    payment_date,
                    payment_type,
                    card_data,
                    total_price)
	select distinct
		NVL(trolley.CLIENT_EMAIL, trolley.CLIENT_MOBILE) as customer,
        NVL(trolley.CLIENT_MOBILE,NVL(trolley.CLIENT_EMAIL,'#')) as mobile,
        to_date(trolley.DLIV_DATE,'yyyy/mm/dd') AS delivery_date,
        TRIM(DLIV_WAYTYPE)||TRIM(DLIV_WAYNAME)||NVL2(DLIV_GATE,', '||TRIM(DLIV_GATE),'')||NVL2(DLIV_BLOCK,', '||TRIM(DLIV_BLOCK),'')||NVL2(DLIV_STAIRW, ', '||TRIM(DLIV_STAIRW),'')||NVL2(DLIV_FLOOR,', '||TRIM(DLIV_FLOOR),'')||NVL2(DLIV_ZIP,  ', '||TRIM(DLIV_ZIP),'')||NVL2(DLIV_TOWN,  ', '||TRIM(DLIV_TOWN),'')||NVL2(DLIV_COUNTRY,  ', '||TRIM(DLIV_COUNTRY),'') as purchases_address,
        trolley.barcode AS product_reference,
        trolley.QUANTITY AS amount,
        to_date(trolley.PAYMENT_DATE||' '||trolley.PAYMENT_TIME, 'yyyy/mm/dd hh:mi:ss pm') AS payment_date,
        trolley.PAYMENT_TYPE AS payment_type,
        trolley.CARD_NUMBER AS card_data,
        to_number(replace(TRIM(REGEXP_REPLACE(trolley.BASE_PRICE, '[[:alpha:]]','')),'.',','))*to_number(QUANTITY) AS total_price
    from fsdb.trolley trolley, Deliveries delive
	where delive.delivery_date = to_date(trolley.DLIV_DATE, 'yyyy-mm-dd')
	and delive.delivery_address = TRIM(DLIV_WAYTYPE)||TRIM(DLIV_WAYNAME)||NVL2(DLIV_GATE,', '||TRIM(DLIV_GATE),'')||NVL2(DLIV_BLOCK,', '||TRIM(DLIV_BLOCK),'')||NVL2(DLIV_STAIRW, ', '||TRIM(DLIV_STAIRW),'')||NVL2(DLIV_FLOOR,', '||TRIM(DLIV_FLOOR),'')||NVL2(DLIV_ZIP,  ', '||TRIM(DLIV_ZIP),'')||NVL2(DLIV_TOWN,  ', '||TRIM(DLIV_TOWN),'')||NVL2(DLIV_COUNTRY,  ', '||TRIM(DLIV_COUNTRY),'');

select distinct
		NVL(trolley.CLIENT_EMAIL, trolley.CLIENT_MOBILE) as customer,
        NVL(trolley.CLIENT_MOBILE,NVL(trolley.CLIENT_EMAIL,'#')) as mobile,
        to_date(trolley.DLIV_DATE,'yyyy/mm/dd') AS delivery_date,
        TRIM(DLIV_WAYTYPE)||TRIM(DLIV_WAYNAME)||NVL2(DLIV_GATE,', '||TRIM(DLIV_GATE),'')||NVL2(DLIV_BLOCK,', '||TRIM(DLIV_BLOCK),'')||NVL2(DLIV_STAIRW, ', '||TRIM(DLIV_STAIRW),'')||NVL2(DLIV_FLOOR,', '||TRIM(DLIV_FLOOR),'')||NVL2(DLIV_ZIP,  ', '||TRIM(DLIV_ZIP),'')||NVL2(DLIV_TOWN,  ', '||TRIM(DLIV_TOWN),'')||NVL2(DLIV_COUNTRY,  ', '||TRIM(DLIV_COUNTRY),'') as purchases_address,
        trolley.barcode AS product_reference
    from fsdb.trolley trolley;
