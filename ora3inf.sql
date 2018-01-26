SET DEFINE OFF;

DELETE FROM MIEJSCA;
DELETE FROM SEKTORY;
DELETE FROM STADIONY;
DELETE FROM IMPREZY;
DELETE FROM CENA;
DELETE FROM PROMOCJE;
DELETE FROM TYPY_KARNETOW;
DELETE FROM REZERWACJE;
DELETE FROM BILETY;
DELETE FROM KLIENCI;
DELETE FROM TYPY_SEKTOROW;
DELETE FROM TYPY_IMPREZ;
DELETE FROM TYPY_KLIENTOW;
DELETE FROM ZAKUPY;
DELETE FROM KARNETY;

drop sequence dept_seq;
drop sequence dept_seq2;
drop sequence dept_seq3;
drop sequence dept_seq4;
drop sequence dept_seq5;
drop sequence dept_seq6;

DROP trigger create_sek_aft_ins_stadiony;
DROP trigger INCREMENT_stadiony_ID;
DROP trigger INCREMENT_imprezy_ID;
DROP trigger INCREMENT_zakupy_ID;
DROP trigger INCREMENT_karnety_ID;
DROP trigger create_msc_aft_ins_sektor;
DROP trigger create_ceny_aft_ins_imprezy;
DROP trigger create_rez_aft_ins_klienci;
DROP trigger bilet_and_zakup_aft_ins_rez;
DROP trigger karnety_aft_klienci;

DROP procedure wstaw_do_typy_sektorow;
DROP procedure wstaw_do_stadiony;
DROP procedure wstaw_do_typy_imprez;
DROP procedure wstaw_do_imprezy;
DROP procedure wstaw_do_typy_klientow;
DROP procedure wstaw_do_promocje;
DROP procedure wstaw_do_typy_karnetow;
DROP procedure wstaw_do_klienci;

/*SEKWENCJE*/
CREATE SEQUENCE dept_seq START WITH 1;
CREATE SEQUENCE dept_seq2 START WITH 1;
CREATE SEQUENCE dept_seq3 START WITH 1;
CREATE SEQUENCE dept_seq4 START WITH 1;
CREATE SEQUENCE dept_seq5 START WITH 1;
CREATE SEQUENCE dept_seq6 START WITH 1;
/*TRIGGERY*/


create or replace TRIGGER INCREMENT_imprezy_ID
BEFORE INSERT ON imprezy
FOR EACH ROW
BEGIN
  SELECT dept_seq2.NEXTVAL
  INTO   :new.ID_IMPREZY
  FROM   dual;
END;
/

create or replace TRIGGER INCREMENT_rezerwacje_ID
BEFORE INSERT ON rezerwacje
FOR EACH ROW
BEGIN
  SELECT dept_seq3.NEXTVAL
  INTO   :new.id_rezerwacji
  FROM   dual;
END;
/

create or replace TRIGGER INCREMENT_klienci_ID
BEFORE INSERT ON klienci
FOR EACH ROW
BEGIN
  SELECT dept_seq4.NEXTVAL
  INTO   :new.id_klienta
  FROM   dual;
END;
/

create or replace TRIGGER INCREMENT_zakupy_ID
BEFORE INSERT ON zakupy
FOR EACH ROW
BEGIN
  SELECT dept_seq5.NEXTVAL
  INTO   :new.ID_ZAKUPU
  FROM   dual;
END;
/

create or replace TRIGGER INCREMENT_karnety_ID
BEFORE INSERT ON karnety
FOR EACH ROW
BEGIN
  SELECT dept_seq6.NEXTVAL
  INTO   :new.ID_karnetu
  FROM   dual;
END;
/

create or replace trigger create_rez_aft_ins_klienci
after insert on klienci
for each row
DECLARE
rand_date DATE;
end_date DATE;
do_rez NUMBER;
begin

    FOR i IN 1..1 LOOP
        
        do_rez := DBMS_RANDOM.value(0,10);
        if do_rez > 6 then
        rand_date := TO_DATE(TRUNC(DBMS_RANDOM.value(TO_CHAR(date '2013-01-01','J'),TO_CHAR(DATE '2016-12-31','J'))),'J');
        end_date := add_months(rand_date,1);
		INSERT INTO REZERWACJE VALUES (i, rand_date, end_date, :NEW.id_klienta);
        end if;
        
    end loop;
end;
/

create or replace TRIGGER create_sek_aft_ins_stadiony
AFTER INSERT ON STADIONY
FOR EACH ROW
BEGIN
  FOR i IN 1..12 LOOP
  
        if i<=4 then
		INSERT INTO SEKTORY(id_sektora ,id_typu, id_stadionu)
        VALUES (i, 1, :NEW.id_stadionu);
        end if;
        
        if (i>4 and i<=8) then
        INSERT INTO SEKTORY(id_sektora ,id_typu, id_stadionu)
        VALUES (i, 2, :NEW.id_stadionu);
        end if;
        
        if (i>8 and i<=12) then
        INSERT INTO SEKTORY(id_sektora ,id_typu, id_stadionu)
        VALUES (i, 3, :NEW.id_stadionu);
        end if;
  END LOOP;
  DBMS_OUTPUT.put_line('Dodano wszystkie sektory.');
END;
/

create or replace TRIGGER create_msc_aft_ins_sektor
AFTER INSERT ON SEKTORY
FOR EACH ROW
BEGIN
  if :new.id_typu = 1 then 
    for i in 1..50 LOOP
        FOR j IN 1..100 LOOP
            INSERT INTO MIEJSCA VALUES(i, j, :NEW.id_sektora, :NEW.id_stadionu);
        END LOOP;
    END LOOP;

  end if;
  
  if :new.id_typu = 2 then 
    for i in 1..100 LOOP
        FOR j IN 1..100 LOOP
            INSERT INTO MIEJSCA VALUES(i, j, :NEW.id_sektora, :NEW.id_stadionu);
        END LOOP;
    END LOOP;
  end if;
  
  if :new.id_typu = 3 then 
    for i in 1..50 LOOP
        FOR j IN 1..100 LOOP
            INSERT INTO MIEJSCA VALUES(i, j, :NEW.id_sektora, :NEW.id_stadionu);
        END LOOP;
    END LOOP;
  end if;   
  DBMS_OUTPUT.put_line('Dodano wszystkie miejsca dla sektora.');
END;
/

create or replace TRIGGER create_ceny_aft_ins_imprezy
AFTER INSERT ON IMPREZY
FOR EACH ROW
DECLARE
prize1 NUMBER(20,2);
prize2 NUMBER(20,2);
prize3 NUMBER(20,2);
BEGIN
    if :new.id_typu = 1 then
        prize1 := round(dbms_random.value(200,400),2);
        prize2 := round(dbms_random.value(150,200),2);
        prize3 := round(dbms_random.value(100,150),2);
		INSERT INTO CENA VALUES(prize1,1,:new.ID_IMPREZY,:new.id_typu);
        INSERT INTO CENA VALUES(prize2,2,:new.id_imprezy,:new.id_typu);
        INSERT INTO CENA VALUES(prize3,3,:new.id_imprezy,:new.id_typu);
    end if;

    if :new.id_typu = 2 then
        prize1 := round(dbms_random.value(150,250),2);
        prize2 := round(dbms_random.value(80,150),2);
        prize3 := round(dbms_random.value(50,80),2);
		INSERT INTO CENA VALUES(prize1,1,:new.id_imprezy,:new.id_typu);
        INSERT INTO CENA VALUES(prize2,2,:new.id_imprezy,:new.id_typu);
        INSERT INTO CENA VALUES(prize3,3,:new.id_imprezy,:new.id_typu);
    end if;

    if :new.id_typu = 3 then
        prize1 := round(dbms_random.value(100,200),2);
        prize2 := round(dbms_random.value(80,100),2);
        prize3 := round(dbms_random.value(40,80),2);
		INSERT INTO CENA VALUES(prize1,1,:new.id_imprezy,:new.id_typu);
        INSERT INTO CENA VALUES(prize2,2,:new.id_imprezy,:new.id_typu);
        INSERT INTO CENA VALUES(prize3,3,:new.id_imprezy,:new.id_typu);
    end if;
  DBMS_OUTPUT.put_line('Dodano wszystkie ceny dla imprezy.');
END;
/

create or replace TRIGGER karnety_aft_klienci
AFTER INSERT ON klienci
for each row
declare
kup_karnet NUMBER;
rand_date DATE;
end_date DATE;
jaki_karnet NUMBER;
cena_wej NUMBER;
okres_wyj NUMBER;
cena_wyj NUMBER(20,2);
rabat_wej NUMBER;
id_promo NUMBER;
begin
    kup_karnet := round(dbms_random.value(1,10));
    jaki_karnet := round(dbms_random.value(1,12));
    
    if kup_karnet > 7 then
    rand_date := TO_DATE(TRUNC(DBMS_RANDOM.value(TO_CHAR(date '2013-01-01','J'),TO_CHAR(DATE '2016-12-31','J'))),'J');
    
    
    SELECT cena, okres_waznosci into cena_wej, okres_wyj FROM typy_karnetow where id_typu_karnetu = jaki_karnet;
    end_date := add_months(rand_date,okres_wyj);
    select rabat, id_promocji into rabat_wej, id_promo from promocje where typy_klientow_id_typu = :new.typy_klientow_id_typu;
    if rabat_wej > 0 then
    cena_wyj := round(cena_wej*(rabat_wej*0.01),2);
    else 
    cena_wyj := round(cena_wej,2);
    end if;
    
    INSERT INTO karnety (data_wystawienia, data_waznosci, cena, klienci_id_klienta, id_typu_klienta, typy_karnetow_id_typu, id_promocji) 
        values (rand_date, end_date, cena_wyj,:new.id_klienta, :new.typy_klientow_id_typu, jaki_karnet, id_promo);
    end if;
end;
/

create or replace TRIGGER bilet_and_zakup_aft_ins_rez
AFTER INSERT ON rezerwacje
FOR EACH ROW
DECLARE
days_diff NUMBER;
id_typu_klienta NUMBER;
id_prom NUMBER;
new_id_zak NUMBER;
stad_id NUMBER;
imp_id NUMBER;
imp_data DATE;
numer_sektora NUMBER;
numer_rzedu NUMBER;
numer_miejsca NUMBER;
verification NUMBER;
BEGIN
    /*zakupy*/
    SELECT ID_stadionu, Id_imprezy, data INTO stad_id, imp_id, imp_data FROM IMPREZY WHERE DATA > :new.data AND ROWNUM <= 1 ORDER BY DATA ASC NULLS LAST;
    days_diff := imp_data - :new.data;
    days_diff := round(days_diff/2);
    INSERT INTO zakupy (data,id_klienta) VALUES(:new.data + days_diff,:new.id_klienta);
    select id_zakupu into new_id_zak from zakupy where rowid=(select max(rowid) from zakupy);



    /*bilety*/
    numer_sektora := round(dbms_random.value(1,12));
    verification := 0;

    if (numer_sektora <=4) then

        WHILE verification IS NOT NULL
        LOOP
            verification := NULL;
            numer_rzedu := round(dbms_random.value(1,50));
            numer_miejsca := round(dbms_random.value(1,100));
            BEGIN
                SELECT Id_rezerwacji into verification FROM bilety where ID_stadionu = stad_id AND Id_imprezy = imp_id AND id_sektora = numer_sektora AND rzad = numer_rzedu AND numer_miejsca=numer_miejsca AND ROWNUM <= 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                verification := NULL;
            END;
        END LOOP;
		INSERT INTO bilety VALUES(imp_id,stad_id,numer_sektora,numer_rzedu,numer_miejsca,:new.id_rezerwacji,new_id_zak);
    end if;

    if (numer_sektora > 4 and numer_sektora <= 8) then

        WHILE verification IS NOT NULL
        LOOP
            verification := NULL;
            numer_rzedu := round(dbms_random.value(1,100));
            numer_miejsca := round(dbms_random.value(1,100));
            BEGIN
                SELECT Id_rezerwacji into verification FROM bilety where ID_stadionu = stad_id AND Id_imprezy = imp_id AND id_sektora = numer_sektora AND rzad = numer_rzedu AND numer_miejsca=numer_miejsca AND ROWNUM <= 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                verification := NULL;
            END;
        END LOOP;
		INSERT INTO bilety VALUES(imp_id,stad_id,numer_sektora,numer_rzedu,numer_miejsca,:new.id_rezerwacji,new_id_zak);
    end if;

    if (numer_sektora > 8 and numer_sektora <=12 ) then

        WHILE verification IS NOT NULL
        LOOP
            verification := NULL;
            numer_rzedu := round(dbms_random.value(1,50));
            numer_miejsca := round(dbms_random.value(1,100));
            BEGIN
                SELECT Id_rezerwacji into verification FROM bilety where ID_stadionu = stad_id AND Id_imprezy = imp_id AND id_sektora = numer_sektora AND rzad = numer_rzedu AND numer_miejsca=numer_miejsca AND ROWNUM <= 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                verification := NULL;
            END;
        END LOOP;
		INSERT INTO bilety VALUES(imp_id,stad_id,numer_sektora,numer_rzedu,numer_miejsca,:new.id_rezerwacji,new_id_zak);
    end if;

  DBMS_OUTPUT.put_line('Dodano bilet i zakup.');
END;
/


/*PROCEDURY*/
create or replace PROCEDURE wstaw_do_typy_sektorow
IS
BEGIN
    INSERT INTO typy_sektorow VALUES (1, 'TYP 1','test_opis1');
    INSERT INTO typy_sektorow VALUES (2, 'TYP 2','test_opis2');
    INSERT INTO typy_sektorow VALUES (3, 'TYP 3','test_opis3');
	
	DBMS_OUTPUT.put_line('Dodano wszystkie typy sektorów.');
COMMIT;
END;
/

create or replace PROCEDURE wstaw_do_typy_klientow
IS
BEGIN
    INSERT INTO typy_klientow VALUES (1, 'Normalny',0,'Nie przysluguje znizka');
    INSERT INTO typy_klientow VALUES (2, 'Dziecko',50,'Dziecko do lat 12');
    INSERT INTO typy_klientow VALUES (3, 'Emeryt',70,'Po osiegnieciu wieku emerytalnego: 65 lat');
    INSERT INTO typy_klientow VALUES (4, 'Kombatant',95,'kombatant wojennych');
	DBMS_OUTPUT.put_line('Dodano wszystkie typy klientów.');
END;
/

create or replace PROCEDURE wstaw_do_stadiony
IS
  	TYPE TABSTR IS TABLE OF VARCHAR2(250);
	name TABSTR;
	qname NUMBER(5);
BEGIN
	name := TABSTR ('UGI', 'AES', 'Telephone Data Systems', 'Paccar', 'Philip Morris International', 'Avon Products', 'Parker Hannifin', 'Freeport-McMoRan Copper & Gold', 'Great Atlantic & Pacific Tea', 'General Motors', 'Staples', 'UnitedHealth Group', 'MetLife', 'National Oilwell Varco', 'NCR', 'Safeway', 'KBR', 'TravelCenters of America', 'Tesoro', 'Goodyear Tire & Rubber', 'Bemis', 'Time Warner Cable', 'HCA Holdings', 'J.M. Smucker', 'Owens & Minor', 'Owens-Illinois', 'Qwest Communications', 
	'Automatic Data Processing', 'Calpine', 'PNC Financial Services Group', 'J.P. Morgan Chase & Co.', 'NextEra Energy', 'Delta Air Lines', 'Avnet', 'First Data', 'Western Union', 'Chesapeake Energy', 'Best Buy', 'PG&E Corp.', 'Sonic Automotive', 'Qualcomm', 'International Business Machines', 'Universal Health Services', 'Ameren', 'General Electric', 'Texas Instruments', 'NII Holdings', 'Merck', 'Travelers Cos.', 'Community Health Systems', 'Entergy', 'WellPoint', 'Phillips-Van Heusen', 'Whole Foods Market', 'Autoliv', 'Thermo Fisher Scientific', 'Avery Dennison', 'Dr Pepper Snapple Group', 'Plains All American Pipeline', 'Aramark', 'Universal American', 'Virgin Media', 'Loews', 'Union Pacific', 'McGraw-Hill', 'Dover', 'Amazon.com', 'Reinsurance Group of America', 'Mattel', 'ITT', 'Comcast', 'Nike', 'General Cable', 'Enterprise Products Partners', 'Office Depot', 'Dollar General', 'Apple', 
	'Expeditors International of Washington', 'Micron Technology', 'Bank of New York Mellon Corp.', 'Alcoa', 'Applied Materials', 'BB&T Corp.', 'Williams', 'Aflac', 'Procter & Gamble', 'Harris', 'Citigroup', 'CB Richard Ellis Group', 'New York Life Insurance', 'EMC', 'Gannett', 'PPL', 'Tech Data', 'Verizon Communications', 'Costco Wholesale', 'Jabil Circuit', 'Broadcom', 'Home Depot', 'Starwood Hotels & Resorts', 'Cisco Systems', 'Progress Energy', 'Northrop Grumman', 'Corning', 'Unum Group', 'AutoZone', 'Icahn Enterprises', 'Dell', 'Prudential Financial', 'Kimberly-Clark', 'Public Service Enterprise Group', 'Henry Schein', 'Arrow Electronics', 'Host Hotels & Resorts', 'General Mills', 'Ryder System', 'Kellogg', 'Ashland', 'PetSmart', 'CenterPoint Energy', 'SAIC', 'OfficeMax', 'Mohawk Industries', 'Masco', 'Wal-Mart Stores', 'Express Scripts', 'Stryker', 'Xcel Energy', 'BJ''s Wholesale Club', 
	'FirstEnergy', 'Supervalu', 'Ball', 'Newmont Mining', 'Pitney Bowes', 'Eaton', 'Apollo Group', 'St. Jude Medical', 'Oneok', 'Nucor', 'Cameron International', 'Amgen', 'SPX', 'United Services Automobile Assn.', 'INTL FCStone', 'Regions Financial', 'Avaya', 'Southwest Airlines', 'State Farm Insurance Cos.', 'Omnicare', 'KeyCorp');
	qname := name.count;
	FOR i IN 1..2 LOOP /*liczba stadionow*/
		INSERT INTO stadiony VALUES (i, name(i));
	END LOOP;
	COMMIT;
	DBMS_OUTPUT.put_line('Dodano wszystkie stadiony.');
END;
/

create or replace PROCEDURE wstaw_do_typy_imprez
IS
BEGIN
	
    INSERT INTO typy_imprez VALUES (1, 'Koncert','test_opis1');
    INSERT INTO typy_imprez VALUES (2, 'Wydarzenie sportowe','test_opis2');
    INSERT INTO typy_imprez VALUES (3, 'Występ','test_opis3');
	
	DBMS_OUTPUT.put_line('Dodano wszystkie typy imprez.');
COMMIT;
END;
/

create or replace PROCEDURE wstaw_do_typy_karnetow
IS
BEGIN
	
    INSERT INTO typy_karnetow VALUES (1, 'Karnet Ligi Diamentowej Premium', 4000, 6, 'brak opisu', 1, 2);
    INSERT INTO typy_karnetow VALUES (2, 'Karnet Ligi Diamentowej Normal', 3000, 6, 'brak opisu', 2, 2);
    INSERT INTO typy_karnetow VALUES (3, 'Karnet Ligi Diamentowej Cheap', 2000, 6, 'brak opisu', 3, 2);
    INSERT INTO typy_karnetow VALUES (4, 'Karnet Klubu Kabaretowego Premium', 200, 3, 'brak opisu', 1, 3);
    INSERT INTO typy_karnetow VALUES (5, 'Karnet Klubu Kabaretowego Normal', 150, 3, 'brak opisu', 2, 3);
    INSERT INTO typy_karnetow VALUES (6, 'Karnet Klubu Kabaretowego Cheap', 100, 3, 'brak opisu', 3, 3);
    INSERT INTO typy_karnetow VALUES (7, 'Karnet Sezonu Piłkarskiego Premium',600, 9, 'brak opisu', 1, 2);
    INSERT INTO typy_karnetow VALUES (8, 'Karnet Sezonu Piłkarskiego Normal',400, 9, 'brak opisu', 2, 2);
    INSERT INTO typy_karnetow VALUES (9, 'Karnet Sezonu Piłkarskiego Cheap',200, 9, 'brak opisu', 3, 2);
    INSERT INTO typy_karnetow VALUES (10, 'Karnet Koncertowy Premium',1000, 2, 'brak opisu', 1, 1);
    INSERT INTO typy_karnetow VALUES (11, 'Karnet Koncertowy Normal',800, 2, 'brak opisu', 2, 1);
    INSERT INTO typy_karnetow VALUES (12, 'Karnet Koncertowy Cheap',600, 2, 'brak opisu', 3, 1);
	
	DBMS_OUTPUT.put_line('Dodano wszystkie typy karnetów.');
COMMIT;
END;
/

create or replace PROCEDURE wstaw_do_promocje
IS
BEGIN
    INSERT INTO promocje VALUES (1, 'Brak',0,'Nie przysluguje znizka',1);
    INSERT INTO promocje VALUES (2, 'Zniżka dziecięca',50,'50% zniżki od ceny oryginalnej',2);
    INSERT INTO promocje VALUES (3, 'Zniżka dla emeryta',70,'70% zniżki od ceny oryginalnej',3);
    INSERT INTO promocje VALUES (4, 'Zniżka dla kombatanta',95,'90% zniżki od ceny oryginalnej',4);
	DBMS_OUTPUT.put_line('Dodano wszystkie promocje.');
COMMIT;
END;
/

create or replace PROCEDURE wstaw_do_imprezy
is
  TYPE TABSTR IS TABLE OF VARCHAR2(250);
    nazwa TABSTR;
    qnazwa NUMBER(5);

  TYPE TABSTR2 IS TABLE OF DATE;
    dates TABSTR2;
    qdates NUMBER(5);

BEGIN  
  nazwa := TABSTR('Praha','Centurion','Forum','ZaEkranem','5 po piatej','Syrena','Pokoj','Helios','CinemaCity','Multikino','Ton',
  'Riot','Iluzjon','Taras','Cheaper','Greater','GoldenScreen','BlueCity','GoldenGobles','All for All','Brok','Brzmien','Pod Baranami','Pod Gwiazdami',
  'Ponad Podzialami','Brak','Brzmienie','Trust','Chrust','BezNas','Z Nami','Zaczarowany Olowek','Tanie Kino');
  qnazwa := nazwa.count;

  dates := TABSTR2(DATE'2013-02-14',DATE'2013-03-23',DATE'2013-04-02',DATE'2013-07-16',
                    DATE'2013-09-18',DATE'2013-10-15',DATE'2013-11-11',DATE'2013-12-30',
                    DATE'2013-02-02',DATE'2013-03-10',DATE'2013-04-04',DATE'2013-06-12',
                    DATE'2013-05-30',DATE'2013-03-03',DATE'2013-04-23',DATE'2013-09-23',
                    DATE'2013-10-07',DATE'2013-11-14',DATE'2013-11-22',DATE'2013-12-14');
  qdates := dates.count;
  FOR i IN 0..4 LOOP
    FOR j IN 1..qdates LOOP
        INSERT into imprezy values(j,nazwa(round(dbms_random.value(1,qnazwa))),add_months(dates(j),12*i),round(dbms_random.value(1,2)),round(dbms_random.value(1,3)),'test_opis');
    END LOOP;
  END LOOP;
	COMMIT;
  DBMS_OUTPUT.put_line('Dodano wszystkie imprezy.');
END;
/

create or replace PROCEDURE wstaw_do_klienci
IS
	TYPE TABSTR IS TABLE OF VARCHAR2(500);
	imie TABSTR;
    TYPE TABSTR2 IS TABLE OF VARCHAR2(500);
	nazwisko TABSTR2;
  
	tel_number NUMBER(9);
    kierunkowy NUMBER(3);
    qname NUMBER(5);
    qsurname NUMBER(5);
    imie_w STRING (20);
    nazw_w STRING (20);
    rok_pesel NUMBER(2);
    miesiac_pesel NUMBER(2);
    dzien_pesel NUMBER(2);
    reszta_pesel NUMBER(5);
    got_pesel VARCHAR(11);
    got_telefon VARCHAR(16);
    typ_klienta NUMBER;
    
    
BEGIN
	imie := TABSTR ('Jan','Stanislaw','Andrzej','Jozef','Tadeusz','Jerzy','Zbigniew','Krzysztof','Henryk',
    'Ryszard','Marek','Kazimierz','Marian','Piotr','Janusz','Wladyslaw','Adam','Wieslaw','Zdzislaw','Edward',
    'Mieczyslaw','Roman','Miroslaw','Grzegorz','Czeslaw','Dariusz','Wojciech','Jacek','Eugeniusz','Maria','Tomasz',
    'Krystyna','Anna','Barbara','Teresa','Elzbieta','Janina','Zofia','Jadwiga','Danuta','Halina','Irena','Ewa',
    'Malgorzata','Helena','Grazyna','Bozena','Stanislawa','Marianna','Jolanta','Urszula','Wanda','Alicja','Dorota',
    'Agnieszka','Beata','Katarzyna','Joanna','Wieslawa','Renata');
    qname := imie.count;
  
    nazwisko := TABSTR2 ('Nowak','Kowalski','Wisniewski','Dabrowski','Lewandowski','Wojcik','Kaminski','Kowalczyk',
    'Zielinski','Szymanski','Kozlowski','Wozniak','Jankowski','Wojciechowski','Kwiatkowski','Kaczmarek','Mazur',
    'Krawczyk','Piotrowski','Grabowski','Nowakowski','Pawlowski','Michalski','Nowicki','Adamczyk','Dudek','Zajac',
    'Wieczorek','Jablonski','Majewski','Krol','Olszewski','Jaworski','Wróbel','Malinowski','Pawlak','Witkowski',
    'Walczak','Stepien','Gorski','Rutkowski','Michalak','Sikora','Ostrowski','Baran','Duda','Szewczyk','Tomaszewski',
    'Marciniak','Pietrzak','Wroblewski','Zalewski','Jakubowski','Jasinski','Zawadzki','Sadowski','Bak','Chmielewski',
    'Wlodarczyk','Borkowski','Czarnecki','Sawicki','Sokolowski','Urbanski','Kubiak','Maciejewski','Szczepanski'
    ,'Wilk','Kucharski','Kalinowski','Lis','Mazurek','Wysocki','Adamski','Kazimierczak','Wasilewski','Sobczak',
    'Czerwinski','Andrzejewski','Cieslak','Glowacki','Zakrzewski','Kolodziej','Sikorski','Krajewski','Gajewski',
    'Szulc','Szymczak','Baranowski','Laskowski','Brzezinski','Makowski','Ziolkowski','Przybylski','Domanski',
    'Nowacki','Borowski','Blaszczyk','Chojnacki','Ciesielski','Mroz','Szczepaniak','Wesolowski','Garecki','Krupa',
    'Kaczmarczyk','Leszczynski','Lipinski');
	qsurname := nazwisko.count;
  

	FOR i IN 1..500 LOOP /*ilosc klientow */
		tel_number := round(dbms_random.value(600000000,899999999));
        kierunkowy := round(dbms_random.value(1,999));
        rok_pesel := round(dbms_random.value(0,99));
        miesiac_pesel := round(dbms_random.value(1,12));
        dzien_pesel := round(dbms_random.value(1,28));
        reszta_pesel := round(dbms_random.value(10000,99999));
		imie_w := imie(round(dbms_random.value(1,qname)));
        nazw_w := nazwisko(round(dbms_random.value(1,qsurname)));
        
        
            got_pesel := to_char(rok_pesel);
        if rok_pesel<10 then
            got_pesel  := concat('0',to_char(rok_pesel));
        end if;
        
        
        if miesiac_pesel<10 then
            got_pesel  := concat(got_pesel,concat('0',to_char(miesiac_pesel)));
        else
            got_pesel := concat(got_pesel,to_char(miesiac_pesel));
        end if;
        
        
        if dzien_pesel<10 then
            got_pesel  := concat(got_pesel,concat('0',to_char(dzien_pesel)));
        else
            got_pesel := concat(got_pesel,to_char(dzien_pesel));
        end if;
        
        got_pesel := concat(got_pesel, to_char(reszta_pesel));
        got_telefon := concat(concat('+',concat(to_char(kierunkowy),' ')),to_char(tel_number));
        
        if rok_pesel<18 and rok_pesel>6 then
            typ_klienta := 2;
        elsif rok_pesel<53 and rok_pesel>30 then
            typ_klienta := 3;
        else
            typ_klienta := 1;
        end if;
        
        INSERT INTO KLIENCI
        (id_klienta, 
        nazwisko, 
        imie,
        PESEL,
        zdjecie,
        telefon_kontaktowy,
        TYPY_KLIENTOW_ID_TYPU)
        
        VALUES 
        (i, 
        nazw_w, 
        imie_w,
        got_pesel,
        EMPTY_BLOB(),
        got_telefon,
        typ_klienta);
        
        COMMIT;
	END LOOP;
  DBMS_OUTPUT.put_line('All klienci added.');
END;
/