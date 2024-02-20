-- TODO: Naming all constraints

/*
The Products table has all the columns with Varchar 255 because we don't know the maximum length of the values.
Except for the decaffeinated column, which is a number 1 (== True) if it is decaffeinated and 0 (== False) if it is not.
And the primary key is the name of the product, which is unique.
*/

CREATE TABLE Products(
    name VARCHAR(255) NOT NULL,
    species VARCHAR(255) NOT NULL,
    variety VARCHAR(255) NOT NULL,
    origin VARCHAR(255) NOT NULL,
    roasting VARCHAR(255) NOT NULL,
    decaffeinated NUMBER(1) NOT NULL,
    CONSTRAINT PK_name PRIMARY KEY (name),
    CONSTRAINT CK_decaffeinated CHECK (decaffeinated IN (0, 1)).
    CONSTRAINT CK_roating CHECK (roasting IN ('natural', 'high-roast', 'mixture'))
);


/*
The Formats table had to have it's first atribure renamed because it was a reserved word in SQL.
And the primary key is the combination of the format_type and the amount, which is unique.
*/

CREATE TABLE Formats(
    format_type varchar(255) not null,
    amount varchar(255) not null,
    PRIMARY KEY (format_type, amount),
    CONSTRAINT CK_format_type CHECK (format_type IN ('grain', 'roasted beans', 'ground', 'freeze-dried', 'in capsules', 'prepared'))
);


/*
The Product_References is the table with the barcode, the product, the format etc.
The barcode is the primary key, and the foreign keys are the product and the format(type and amount).
*/

Create Table Product_References(
    barcode NUMBER NOT NULL,
    product VARCHAR(255) NOT NULL,
    format_format_type VARCHAR(255) NOT NULL,
    format_amount VARCHAR(255) NOT NULL,
    price NUMBER NOT NULL,
    stock NUMBER NOT NULL,
    PRIMARY KEY (barcode),
    FOREIGN KEY (product) REFERENCES Products(name),
    FOREIGN KEY (format_format_type, format_amount) REFERENCES Formats(format_type, amount)
);

/*
The providers table has the CIF as the primary key.
The only atribute we know the length of is the sales_phone, which is a char(9). 
*/

Create Table Providers(
    CIF CHAR(9) NOT NULL,
    name VARCHAR(255) NOT NULL,
    sales_name VARCHAR(255) NOT NULL,
    sales_phone CHAR(9) NOT NULL,
    sales_email VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    PRIMARY KEY (CIF)
    /*
    We know that all the atributes are unique but we are not going to mark them all as unique,
     as this would detriment considerably the performance of the database.
    */
);


/*
The replacement orders has the primary key as the reference, which is a foreign key to the Product_References table.
The provider can be Null, as well as the receiving_date and the payment.
*/

CREATE TABLE REPLACEMENT_ORDERS(
    status VARCHAR(255) NOT NULL,
    provider CHAR(9), -- This has the same type as the primary key of Providers
    amount_units NUMBER NOT NULL,
    order_date DATE NOT NULL,
    reference NUMBER NOT NULL,
    receiving_date DATE,
    payment VARCHAR(255),
    PRIMARY KEY (reference),
    FOREIGN KEY (reference) REFERENCES Product_References(barcode),
    FOREIGN KEY (provider) REFERENCES Providers(CIF),
    CONSTRAINT CK_status CHECK (status IN ('pending', 'received', 'paid'))
);


/*
The deliveries table is a combination of the delivery_date and the delivery_address, which is unique.
*/

CREATE TABLE Deliveries(
    delivery_date DATE NOT NULL,
    delivery_address VARCHAR(255) NOT NULL,
    PRIMARY KEY (delivery_date, delivery_address)
);

/*
-- After looking the statement again, it seems the voucher already has a date, so we don't need this table
Create Table Discounts(
    voucher VARCHAR(255) NOT NULL,
    date_voucher DATE NOT NULL,
    PRIMARY KEY (voucher, date_voucher)
);
*/

Create Table Credit_Cards(
    card_number CHAR(16) NOT NULL,
    expiration_date DATE NOT NULL,
    holder VARCHAR(255) NOT NULL,
    finance_company VARCHAR(255) NOT NULL,
    PRIMARY KEY (card_number)
);


/*
The only important aspect of the Adresses table is that the adress_id is unique.
Here is where I have some doubt of how can we do this.
*/

Create Table Addresses(
    street_type VARCHAR(255) NOT NULL,
    street_name VARCHAR(255) NOT NULL,
    gateway_num NUMBER NOT NULL,
    block_num NUMBER NOT NULL,
    status_id CHAR(5) NOT NULL,
    floor NUMBER NOT NULL,
    door CHAR(1) NOT NULL,
    ZIP_code CHAR(5) NOT NULL,
    town_city VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    address_id NUMBER unique, --Todo
    PRIMARY KEY (street_type, street_name, gateway_num, ZIP_code)
);


/*
Here, what we discus with the professor was applied. We cerated a contact_media and a contact_media_alternative.
The main is the one that will be always populated, and if the alternative is populated, the main one will be phone and the second one the email.
*/

Create Table Registered_Clients_Informations(
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    registration_date DATE NOT NULL,
    peronal_data VARCHAR(255) NOT NULL,
    contact_media VARCHAR(255) NOT NULL,
    conact_media_alternative VARCHAR(255),
    loyal_discount VARCHAR(255),
    credit_card CHAR(16) NOT NULL,
    address_id NUMBER unique not null,
    PRIMARY KEY (username),
    FOREIGN KEY (credit_card) REFERENCES Credit_Cards(card_number),
    FOREIGN KEY (address_id) REFERENCES Addresses(address_id)
);


/* 
The client table, is a mixture of the registered and unregistered clients.
The primary key is the main_contact, as it will be unique in both registered and unregistered clients.
And the main information of the client is in the Registered_Clients_Informations table.
*/

Create Table Clients(
    main_contact VARCHAR(255) NOT NULL,
    alt_contact VARCHAR(255),
    registered_client_information VARCHAR(255) NOT NULL,
    CONSTRAINT PK_main_contact PRIMARY KEY (main_contact),
    CONSTRAINT FK_registered_client_information FOREIGN KEY (registered_client_information) REFERENCES Registered_Clients_Informations(username)
);


/*

*/

Create Table Purchases(
    amount NUMBER NOT NULL,
    payment_date DATE,
    payment_type VARCHAR(255) NOT NULL,
    payment_detail VARCHAR(255),
    costumer VARCHAR(255) NOT NULL,
    deliver_date DATE NOT NULL,
    delivery_address VARCHAR(255) NOT NULL,
    product_reference NUMBER NOT NULL,
    total_price NUMBER NOT NULL,
    PRIMARY KEY (costumer, deliver_date, delivery_address, product_reference),
    FOREIGN KEY (costumer) REFERENCES Clients(main_contact),
    FOREIGN KEY (deliver_date, delivery_address) REFERENCES Deliveries(delivery_date, delivery_address),
    FOREIGN KEY (product_reference) REFERENCES Product_References(barcode)
);


/*

*/

Create Table Opinions_References(
    registered_client VARCHAR(255) NOT NULL,
    score NUMBER NOT NULL,
    text_opinion VARCHAR(511) NOT NULL,
    likes NUMBER NOT NULL,
    endorsement NUMBER NOT NULL,
    product_reference NUMBER NOT NULL,
    PRIMARY KEY (registered_client, product_reference),
    FOREIGN KEY (registered_client) REFERENCES Clients(main_contact),
    FOREIGN KEY (product_reference) REFERENCES Product_References(barcode)
);


/*

*/

Create Table Opinions_Products(
    registered_client VARCHAR(255) NOT NULL,
    score NUMBER NOT NULL,
    text_opinion VARCHAR(511) NOT NULL,
    likes NUMBER NOT NULL,
    endorsement NUMBER NOT NULL,
    product VARCHAR(255) NOT NULL,
    PRIMARY KEY (registered_client, product),
    FOREIGN KEY (registered_client) REFERENCES Clients(main_contact),
    FOREIGN KEY (product) REFERENCES Products(name)
);