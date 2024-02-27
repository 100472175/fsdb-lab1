

Select product
    FROM (select product, coffea, varietal, origin, roasting, decaf from fsdb.catalogue where product is not null)
    GROUP BY product HAVING COUNT('x') > 1;


insert into products (select distinct product, coffea, varietal, origin, roasting, decaf from fsdb.catalogue where product is not null)


insert into ntitulacion select distinct titulacion from oldmatriculas where titulacion is not null;
INSERT INTO NTITULACION SELECT DISTINCT TITULACION FROM OLDMATRICULAS WHERE TITULACION IS NOT NULL;