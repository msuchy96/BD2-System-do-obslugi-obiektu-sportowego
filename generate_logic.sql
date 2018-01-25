/*SET DEFINE OFF;*/

/*SEKWENCJE*/

CREATE SEQUENCE ID_TYPU_SEKTORA_seq START WITH 1;
CREATE SEQUENCE ID_STADIONU_seq     START WITH 1;
CREATE SEQUENCE ID_SEKTORU_seq      START WITH 1;
CREATE SEQUENCE ID_TYPU_IMPREZY_seq START WITH 1;
CREATE SEQUENCE ID_IMPREZY_seq      START WITH 1;
CREATE SEQUENCE ID_TYPU_KLIENTA_seq START WITH 1;
CREATE SEQUENCE ID_KLIENTA_seq      START WITH 1;
CREATE SEQUENCE ID_PROMOCJI_seq     START WITH 1;
CREATE SEQUENCE ID_TYPU_KARNETU_seq START WITH 1;
CREATE SEQUENCE ID_KARNETU_seq      START WITH 1;
CREATE SEQUENCE ID_REZERWACJI_seq   START WITH 1;
CREATE SEQUENCE ID_ZAKUPU_seq       START WITH 1;


/*TRIGGERY*/

create or replace TRIGGER INCREMENT_ID_TYPU_SEKTORA
BEFORE INSERT ON TYPY_SEKTOROW
FOR EACH ROW
  WHEN (new.ID_TYPU_SEKTORA IS NULL)
BEGIN
  SELECT ID_TYPU_SEKTORA_seq.NEXTVAL
  INTO   :new.ID_TYPU_SEKTORA
  FROM   dual;
END;
/

create or replace TRIGGER INCREMENT_ID_STADIONU
BEFORE INSERT ON STADIONY
FOR EACH ROW
  WHEN (new.ID_STADIONU IS NULL)
BEGIN
  SELECT ID_STADIONU_seq.NEXTVAL
  INTO   :new.ID_STADIONU
  FROM   dual;
END;
/

create or replace TRIGGER INCREMENT_ID_SEKTORA
BEFORE INSERT ON SEKTORY
FOR EACH ROW
  WHEN (new.ID_SEKTORA IS NULL)
BEGIN
  SELECT ID_SEKTORU_seq.NEXTVAL
  INTO   :new.ID_SEKTORA
  FROM   dual;
END;
/

create or replace TRIGGER INCREMENT_ID_TYPU_IMPREZY
BEFORE INSERT ON TYPY_IMPREZ
FOR EACH ROW
  WHEN (new.ID_TYPU_IMPREZY IS NULL)
BEGIN
  SELECT ID_TYPU_IMPREZY_seq.NEXTVAL
  INTO   :new.ID_TYPU_IMPREZY
  FROM   dual;
END;
/

create or replace TRIGGER INCREMENT_ID_IMPREZY
BEFORE INSERT ON IMPREZY
FOR EACH ROW
  WHEN (new.ID_IMPREZY IS NULL)
BEGIN
  SELECT ID_IMPREZY_seq.NEXTVAL
  INTO   :new.ID_IMPREZY
  FROM   dual;
END;
/

create or replace TRIGGER INCREMENT_ID_TYPU_KLIENTA
BEFORE INSERT ON TYPY_KLIENTOW
FOR EACH ROW
  WHEN (new.ID_TYPU_KLIENTA IS NULL)
BEGIN
  SELECT ID_TYPU_KLIENTA_seq.NEXTVAL
  INTO   :new.ID_TYPU_KLIENTA
  FROM   dual;
END;
/

create or replace TRIGGER INCREMENT_ID_KLIENTA
BEFORE INSERT ON KLIENCI
FOR EACH ROW
  WHEN (new.ID_KLIENTA IS NULL)
BEGIN
  SELECT ID_KLIENTA_seq.NEXTVAL
  INTO   :new.ID_KLIENTA
  FROM   dual;
END;
/

create or replace TRIGGER INCREMENT_ID_PROMOCJI
BEFORE INSERT ON PROMOCJE
FOR EACH ROW
  WHEN (new.ID_PROMOCJI IS NULL)
BEGIN
  SELECT ID_PROMOCJI_seq.NEXTVAL
  INTO   :new.ID_PROMOCJI
  FROM   dual;
END;
/

create or replace TRIGGER INCREMENT_ID_TYPU_KARNETU
BEFORE INSERT ON TYPY_KARNETOW
FOR EACH ROW
  WHEN (new.ID_TYPU_KARNETU IS NULL)
BEGIN
  SELECT ID_TYPU_KARNETU_seq.NEXTVAL
  INTO   :new.ID_TYPU_KARNETU
  FROM   dual;
END;
/

create or replace TRIGGER INCREMENT_ID_KARNETU
BEFORE INSERT ON KARNETY
FOR EACH ROW
  WHEN (new.ID_KARNETU IS NULL)
BEGIN
  SELECT ID_KARNETU_seq.NEXTVAL
  INTO   :new.ID_KARNETU
  FROM   dual;
END;
/

create or replace TRIGGER INCREMENT_ID_REZERWACJI
BEFORE INSERT ON REZERWACJE
FOR EACH ROW
  WHEN (new.ID_REZERWACJI IS NULL)
BEGIN
  SELECT ID_REZERWACJI_seq.NEXTVAL
  INTO   :new.ID_REZERWACJI
  FROM   dual;
END;
/

create or replace TRIGGER INCREMENT_ID_ZAKUPU
BEFORE INSERT ON ZAKUPY
FOR EACH ROW
  WHEN (new.ID_ZAKUPU IS NULL)
BEGIN
  SELECT ID_ZAKUPU_seq.NEXTVAL
  INTO   :new.ID_ZAKUPU
  FROM   dual;
END;
/

create or replace TRIGGER DELETE_BILETY_FROM_REZERWACJE
BEFORE DELETE ON REZERWACJE
  FOR EACH ROW
BEGIN
  DELETE FROM BILETY  WHERE ID_REZERWACJI = :OLD.ID_REZERWACJI AND ID_ZAKUPU IS NULL;
  UPDATE BILETY SET ID_REZERWACJI = NULL WHERE ID_REZERWACJI = :OLD.ID_REZERWACJI;
END;
/

create or replace TRIGGER DELETE_BILETY_FROM_ZAKUPY
BEFORE DELETE ON ZAKUPY
  FOR EACH ROW
DECLARE
  id_rez NUMBER;
BEGIN
  SELECT DISTINCT ID_REZERWACJI INTO id_rez FROM BILETY WHERE ID_ZAKUPU = :OLD.ID_ZAKUPU;
  DELETE FROM REZERWACJE WHERE ID_REZERWACJI = id_rez;

  DELETE FROM BILETY WHERE ID_ZAKUPU = :OLD.ID_ZAKUPU AND ID_REZERWACJI IS NULL;

EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.put_line('Too Many different ID_REZERWACJI in BILETY when ID_ZAKUPU = :OLD.ID_ZAKUPU');
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.put_line('Table Bilety is empty');
END;
/


/*PROCEDURY*/

create or replace PROCEDURE wstaw_do_typy_sektorow
IS
BEGIN
    INSERT INTO typy_sektorow (NAZWA, OPIS) VALUES ('TYP 1','test_opis1');
    INSERT INTO typy_sektorow (NAZWA, OPIS) VALUES ('TYP 2','test_opis2');
    INSERT INTO typy_sektorow (NAZWA, OPIS) VALUES ('TYP 3','test_opis3');

	DBMS_OUTPUT.put_line('Dodano wszystkie typy sektorów.');
COMMIT;
END;
/

create or replace PROCEDURE stworz_sektor_i_miejsca (stadium NUMBER, type_sector NUMBER, rows NUMBER, seats_per_row NUMBER)
IS
BEGIN
	INSERT INTO SEKTORY (ID_TYPU_SEKTORA, ID_STADIONU) VALUES (type_sector, stadium);

  FOR i IN 1..rows LOOP
    FOR j IN 1..seats_per_row LOOP
      INSERT INTO MIEJSCA VALUES(i, j, ID_SEKTORU_seq.currval, stadium);
    END LOOP;
  END LOOP;

	COMMIT;
  DBMS_OUTPUT.PUT_LINE('Dodano sektor: ' || ID_SEKTORU_seq.currval || ' i miejsca: ' || rows  || 'x' || seats_per_row);
END;
/

create or replace PROCEDURE stworz_stadiony (nr_of_stadiums NUMBER)
IS
  	TYPE TABSTR IS TABLE OF VARCHAR2(250);
	name TABSTR;
	qname NUMBER(5);
  id NUMBER;
BEGIN
	name := TABSTR ('UGI', 'AES', 'Telephone Data Systems', 'Paccar', 'Philip Morris International', 'Avon Products', 'Parker Hannifin', 'Freeport-McMoRan Copper & Gold', 'Great Atlantic & Pacific Tea', 'General Motors', 'Staples', 'UnitedHealth Group', 'MetLife', 'National Oilwell Varco', 'NCR', 'Safeway', 'KBR', 'TravelCenters of America', 'Tesoro', 'Goodyear Tire & Rubber', 'Bemis', 'Time Warner Cable', 'HCA Holdings', 'J.M. Smucker', 'Owens & Minor', 'Owens-Illinois', 'Qwest Communications',
	'Automatic Data Processing', 'Calpine', 'PNC Financial Services Group', 'J.P. Morgan Chase & Co.', 'NextEra Energy', 'Delta Air Lines', 'Avnet', 'First Data', 'Western Union', 'Chesapeake Energy', 'Best Buy', 'PG&E Corp.', 'Sonic Automotive', 'Qualcomm', 'International Business Machines', 'Universal Health Services', 'Ameren', 'General Electric', 'Texas Instruments', 'NII Holdings', 'Merck', 'Travelers Cos.', 'Community Health Systems', 'Entergy', 'WellPoint', 'Phillips-Van Heusen', 'Whole Foods Market', 'Autoliv', 'Thermo Fisher Scientific', 'Avery Dennison', 'Dr Pepper Snapple Group', 'Plains All American Pipeline', 'Aramark', 'Universal American', 'Virgin Media', 'Loews', 'Union Pacific', 'McGraw-Hill', 'Dover', 'Amazon.com', 'Reinsurance Group of America', 'Mattel', 'ITT', 'Comcast', 'Nike', 'General Cable', 'Enterprise Products Partners', 'Office Depot', 'Dollar General', 'Apple',
	'Expeditors International of Washington', 'Micron Technology', 'Bank of New York Mellon Corp.', 'Alcoa', 'Applied Materials', 'BB&T Corp.', 'Williams', 'Aflac', 'Procter & Gamble', 'Harris', 'Citigroup', 'CB Richard Ellis Group', 'New York Life Insurance', 'EMC', 'Gannett', 'PPL', 'Tech Data', 'Verizon Communications', 'Costco Wholesale', 'Jabil Circuit', 'Broadcom', 'Home Depot', 'Starwood Hotels & Resorts', 'Cisco Systems', 'Progress Energy', 'Northrop Grumman', 'Corning', 'Unum Group', 'AutoZone', 'Icahn Enterprises', 'Dell', 'Prudential Financial', 'Kimberly-Clark', 'Public Service Enterprise Group', 'Henry Schein', 'Arrow Electronics', 'Host Hotels & Resorts', 'General Mills', 'Ryder System', 'Kellogg', 'Ashland', 'PetSmart', 'CenterPoint Energy', 'SAIC', 'OfficeMax', 'Mohawk Industries', 'Masco', 'Wal-Mart Stores', 'Express Scripts', 'Stryker', 'Xcel Energy', 'BJ''s Wholesale Club',
	'FirstEnergy', 'Supervalu', 'Ball', 'Newmont Mining', 'Pitney Bowes', 'Eaton', 'Apollo Group', 'St. Jude Medical', 'Oneok', 'Nucor', 'Cameron International', 'Amgen', 'SPX', 'United Services Automobile Assn.', 'INTL FCStone', 'Regions Financial', 'Avaya', 'Southwest Airlines', 'State Farm Insurance Cos.', 'Omnicare', 'KeyCorp');
	qname := name.count;
	FOR i IN 1..nr_of_stadiums LOOP /*liczba stadionow*/
    id := ID_STADIONU_seq.NEXTVAL;
		INSERT INTO stadiony VALUES (id, name(id));


    FOR j IN 1..4 LOOP
      STWORZ_SEKTOR_I_MIEJSCA(id, 1, 50, 100);
    END LOOP;

    FOR j IN 5..8 LOOP
      STWORZ_SEKTOR_I_MIEJSCA(id, 2, 100, 100);
    END LOOP;

    FOR j IN 9..12 LOOP
      STWORZ_SEKTOR_I_MIEJSCA(id, 3, 50, 100);
    END LOOP;
    DBMS_OUTPUT.put_line('Dodano wszystkie sektory w stadionie: ' || id);


	END LOOP;
	COMMIT;
	DBMS_OUTPUT.put_line('Dodano wszystkie stadiony.');
END;
/

create or replace PROCEDURE wstaw_do_typy_imprez
IS
BEGIN

    INSERT INTO typy_imprez (NAZWA, OPIS) VALUES ('Występ','test_opis1');
    INSERT INTO typy_imprez (NAZWA, OPIS) VALUES ('Wydarzenie sportowe','test_opis2');
    INSERT INTO typy_imprez (NAZWA, OPIS) VALUES ('Koncert','test_opis3');

	DBMS_OUTPUT.put_line('Dodano wszystkie typy imprez.');
COMMIT;
END;
/

create or replace PROCEDURE stworz_ceny (curr_id_imprezy NUMBER)
is
  prize NUMBER;
  curr_id_typu_imprezy NUMBER;
  /*curr_id_typu_imprezy NUMBER;*/
BEGIN
  SELECT ID_TYPU_IMPREZY INTO curr_id_typu_imprezy FROM IMPREZY WHERE ID_IMPREZY = curr_id_imprezy;
  /*SELECT DISTINCT ID_TYPU_SEKTORA FROM SEKTORY WHERE ID_STADIONU = (SELECT DISTINCT ID_STADIONU FROM IMPREZY WHERE ID_IMPREZY = curr_id_imprezy);*/

  prize := 50 * curr_id_typu_imprezy;

  FOR i IN 1..ID_TYPU_SEKTORA_seq.currval LOOP
    INSERT INTO CENY (CENA, ID_TYPU_SEKTORA, ID_IMPREZY, ID_TYPU_IMPREZY)
      VALUES(round(dbms_random.value(prize*i,prize*(i+1)),2), i, curr_id_imprezy, curr_id_typu_imprezy);
  END LOOP;

	COMMIT;
  DBMS_OUTPUT.put_line('Dodano ceny do imprezy: ' || curr_id_imprezy);
END;
/

create or replace PROCEDURE stworz_imprezy (years NUMBER, imprezy_per_year NUMBER)
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

  dates := TABSTR2(DATE'2018-01-03',DATE'2018-02-02',DATE'2018-02-14',DATE'2018-03-10',DATE'2018-03-23',
                   DATE'2018-04-02',DATE'2018-04-04',DATE'2018-04-23',DATE'2018-05-30',DATE'2018-06-12',
                   DATE'2018-07-16',DATE'2018-09-18',DATE'2018-09-23',DATE'2018-10-07',DATE'2018-10-15',
                   DATE'2018-11-11',DATE'2018-11-14',DATE'2018-11-22',DATE'2018-12-14',DATE'2018-12-30');

  qdates := dates.count;
  FOR i IN 0..(years-1) LOOP
    FOR j IN 1..imprezy_per_year LOOP
        INSERT into imprezy (NAZWA, DATA_IMPREZY, ID_STADIONU, ID_TYPU_IMPREZY, OPIS)
          values (nazwa(round(dbms_random.value(1,qnazwa))), add_months(dates(21-j),-12*i) + (1/24*20), round(dbms_random.value(1,ID_STADIONU_seq.currval)), round(dbms_random.value(1,ID_TYPU_IMPREZY_seq.currval)),'test_opis');
          STWORZ_CENY(ID_IMPREZY_seq.currval);
    END LOOP;
  END LOOP;
	COMMIT;
  DBMS_OUTPUT.put_line('Dodano wszystkie imprezy.');
END;
/

create or replace PROCEDURE wstaw_do_typy_klientow
IS
BEGIN
    INSERT INTO typy_klientow (NAZWA, OPIS) VALUES ('Normalny', 'Dorosly');
    INSERT INTO typy_klientow (NAZWA, OPIS) VALUES ('Dziecko',  'Dziecko do lat 12');
    INSERT INTO typy_klientow (NAZWA, OPIS) VALUES ('Emeryt',   'Po osiegnieciu wieku emerytalnego: 65 lat');
    INSERT INTO typy_klientow (NAZWA, OPIS) VALUES ('Kombatant','kombatant wojennych');

    INSERT INTO typy_klientow (NAZWA, OPIS) VALUES ('Normalny/Stały klient 1', 'Dorosly');
    INSERT INTO typy_klientow (NAZWA, OPIS) VALUES ('Dziecko/Stały klient 1',  'Dziecko do lat 12');
    INSERT INTO typy_klientow (NAZWA, OPIS) VALUES ('Emeryt/Stały klient 1',   'Po osiegnieciu wieku emerytalnego: 65 lat');
    INSERT INTO typy_klientow (NAZWA, OPIS) VALUES ('Kombatant/Stały klient 1','kombatant wojennych');

    INSERT INTO typy_klientow (NAZWA, OPIS) VALUES ('Normalny/Stały klient 2', 'Dorosly');
    INSERT INTO typy_klientow (NAZWA, OPIS) VALUES ('Dziecko/Stały klient 2',  'Dziecko do lat 12');
    INSERT INTO typy_klientow (NAZWA, OPIS) VALUES ('Emeryt/Stały klient 2',   'Po osiegnieciu wieku emerytalnego: 65 lat');
    INSERT INTO typy_klientow (NAZWA, OPIS) VALUES ('Kombatant/Stały klient 2','kombatant wojennych');
	DBMS_OUTPUT.put_line('Dodano wszystkie typy klientów.');
END;
/

create or replace PROCEDURE stworz_klientow (klienci NUMBER)
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


	FOR i IN 1..klienci LOOP
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
          (NAZWISKO, IMIE, ZDJECIE, TELEFON_KONTAKTOWY, PESEL, ID_TYPU_KLIENTA)
        VALUES
          (nazw_w, imie_w, EMPTY_BLOB(), got_telefon, got_pesel, typ_klienta);

	END LOOP;
  COMMIT;
  DBMS_OUTPUT.put_line('Dodano wszystkich Klientow: ' || klienci);
END;
/

create or replace PROCEDURE wstaw_do_promocje
IS
BEGIN
  FOR i IN 1..ID_TYPU_KLIENTA_seq.currval LOOP
    INSERT INTO PROMOCJE (NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES ('Brak',0,'Nie przysluguje znizka', i);
  END LOOP;

  FOR i IN 0..2 LOOP
    INSERT INTO promocje (NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES ('Zniżka dziecięca',50,'50% zniżki od ceny oryginalnej', 2 + i*4 );
  END LOOP;

  FOR i IN 0..2 LOOP
    INSERT INTO promocje (NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES ('Zniżka dla emeryta',70,'70% zniżki od ceny oryginalnej', 3 + i*4);
  END LOOP;

  FOR i IN 0..2 LOOP
    INSERT INTO promocje (NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES ('Zniżka dla kombatanta',95,'90% zniżki od ceny oryginalnej', 4 + i*4);
  END LOOP;

  FOR i IN 5..8 LOOP
    INSERT INTO PROMOCJE (NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES ('Stały klient 1',10,'10% zniżki od ceny oryginalnej dla osob, które kupiły n biletów w ciągu ostatniego pol roku', i);
  END LOOP;

  FOR i IN 9..12 LOOP
    INSERT INTO PROMOCJE (NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES ('Stały klient 2',20,'20% zniżki od ceny oryginalnej dla osob, które wydaly n zlotych w ciągu ostatniego pol roku', i);
  END LOOP;

	DBMS_OUTPUT.put_line('Dodano wszystkie promocje.');
COMMIT;
END;
/

create or replace PROCEDURE wstaw_do_typy_karnetow
IS
BEGIN

    INSERT INTO typy_karnetow (NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES ('Karnet Ligi Diamentowej Cheap', 2000, 6, 'brak opisu', 1, 2);
    INSERT INTO typy_karnetow (NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES ('Karnet Ligi Diamentowej Normal', 3000, 6, 'brak opisu', 2, 2);
    INSERT INTO typy_karnetow (NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES ('Karnet Ligi Diamentowej Premium', 4000, 6, 'brak opisu', 3, 2);

    INSERT INTO typy_karnetow (NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES ('Karnet Klubu Kabaretowego Cheap', 100, 3, 'brak opisu', 1, 3);
    INSERT INTO typy_karnetow (NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES ('Karnet Klubu Kabaretowego Normal', 150, 3, 'brak opisu', 2, 3);
    INSERT INTO typy_karnetow (NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES ('Karnet Klubu Kabaretowego Premium', 200, 3, 'brak opisu', 3, 3);

    INSERT INTO typy_karnetow (NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES ('Karnet Sezonu Piłkarskiego Cheap',200, 9, 'brak opisu', 1, 2);
    INSERT INTO typy_karnetow (NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES ('Karnet Sezonu Piłkarskiego Normal',400, 9, 'brak opisu', 2, 2);
    INSERT INTO typy_karnetow (NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES ('Karnet Sezonu Piłkarskiego Premium',600, 9, 'brak opisu', 3, 2);

    INSERT INTO typy_karnetow (NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES ('Karnet Koncertowy Cheap',600, 2, 'brak opisu', 1, 1);
    INSERT INTO typy_karnetow (NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES ('Karnet Koncertowy Normal',800, 2, 'brak opisu', 2, 1);
    INSERT INTO typy_karnetow (NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES ('Karnet Koncertowy Premium',1000, 2, 'brak opisu', 3, 1);

	DBMS_OUTPUT.put_line('Dodano wszystkie typy karnetów.');
COMMIT;
END;
/

create or replace PROCEDURE stworz_karnety (nr_karnety NUMBER)
IS
  rand_date DATE;
  end_date DATE;
  jaki_karnet NUMBER;
  cena_wej NUMBER;
  okres_wyj NUMBER;
  cena_wyj NUMBER(20,2);
  rabat_wej NUMBER;
  curr_id_klienta NUMBER;
  curr_id_typu_klienta NUMBER;
BEGIN

  FOR i IN 1..nr_karnety LOOP
    jaki_karnet := round(dbms_random.value(1, ID_TYPU_KARNETU_seq.currval));
    rand_date := TO_DATE(TRUNC(DBMS_RANDOM.value(TO_CHAR(date '2013-01-01','J'),TO_CHAR(DATE '2017-12-31','J'))),'J');
    SELECT CENA, OKRES_WAZNOSCI INTO cena_wej, okres_wyj FROM typy_karnetow WHERE ID_TYPU_KARNETU = jaki_karnet;
    end_date := add_months(rand_date,okres_wyj);

    curr_id_klienta := round(dbms_random.value(1, ID_KLIENTA_seq.currval));
    SELECT ID_TYPU_KLIENTA INTO curr_id_typu_klienta FROM KLIENCI WHERE ID_KLIENTA = curr_id_klienta;

    cena_wyj := round(cena_wej,2);

    INSERT INTO karnety (DATA_WYSTAWIENIA, DATA_WAZNOSCI, CENA, ID_KLIENTA, ID_TYPU_KLIENTA, ID_TYPU_KARNETU)
        values (rand_date, end_date, cena_wyj, curr_id_klienta, curr_id_typu_klienta, jaki_karnet);

  END LOOP;

	DBMS_OUTPUT.put_line('Stworzono karnety.');
  COMMIT;
END;
/

create or replace FUNCTION rezerwuj (biletow NUMBER, curr_id_klienta NUMBER, curr_id_imprezy NUMBER, curr_id_sektora NUMBER, curr_data_rezerwacji DATE DEFAULT (DATE'2000-01-01'))
RETURN NUMBER IS
  k_exst NUMBER;
  m_exst NUMBER;
  b_exst NUMBER;
  curr_id_stadionu NUMBER;
  rzedow NUMBER;
  miejsc NUMBER;
  curr_date DATE;
  data_i DATE;
  biletow_count NUMBER;

BEGIN
  SELECT DISTINCT ID_STADIONU INTO curr_id_stadionu FROM IMPREZY WHERE ID_IMPREZY = curr_id_imprezy;

  /*Sprawdzam czy ilosc biletow jest z zakresu (1,10)*/
  IF biletow < 1 OR biletow > 10 THEN
    RETURN -5;
  END IF;

  IF curr_data_rezerwacji = (DATE'2000-01-01') THEN
    curr_date := SYSDATE;
  ELSE
    curr_date := curr_data_rezerwacji;
  END IF;

  /*Sprawdzam czy da się zarezerwować impreze - wydarzy sie za wiecej niz 7 dni*/
  SELECT DATA_IMPREZY INTO data_i FROM IMPREZY WHERE ID_IMPREZY = curr_id_imprezy;
  IF data_i - 7 < curr_date THEN
    RETURN -4;
  END IF;

  /*Sprawdzam czy jest wystarczajaca liczba miejsc w danym sektorze: m_exst - b_exst >= biletow - jest*/
  SELECT count(*) INTO m_exst FROM MIEJSCA WHERE ID_SEKTORA = curr_id_sektora AND ID_STADIONU = curr_id_stadionu;
  SELECT count(*) INTO b_exst FROM BILETY WHERE ID_SEKTORA = curr_id_sektora AND ID_STADIONU = curr_id_stadionu AND ID_IMPREZY = curr_id_imprezy;
  IF m_exst - b_exst < biletow THEN
    /*DBMS_OUTPUT.put_line('miejsc: ' || m_exst || ' biletow: ' || b_exst);*/
    RETURN -1;
  END IF;

  /*Sprawdzam czy klient curr_id_klienta ma juz rezerwacje na impreze curr_id_imprezy: k_exst=0 - nie ma, k_exst>0 - ma*/
  SELECT count(*) INTO k_exst FROM REZERWACJE R JOIN BILETY B ON R.ID_REZERWACJI = B.ID_REZERWACJI WHERE ID_KLIENTA = curr_id_klienta AND ID_IMPREZY = curr_id_imprezy;
  IF k_exst > 0 THEN
    /*DBMS_OUTPUT.put_line('Klien: ' || curr_id_klienta || ' ma juz rezerwacje');*/
    RETURN -2;
  END IF;

  /*Sprawdzam czy klient curr_id_klienta ma juz kupione bilety na impreze curr_id_imprezy: k_exst=0 - nie ma, k_exst>0 - ma*/
  SELECT count(*) INTO k_exst FROM ZAKUPY Z JOIN BILETY B ON Z.ID_ZAKUPU = B.ID_ZAKUPU WHERE ID_KLIENTA = curr_id_klienta AND ID_IMPREZY = curr_id_imprezy;
  IF k_exst > 0 THEN
    /*DBMS_OUTPUT.put_line('Klien: ' || curr_id_klienta || ' ma juz zakupione bilety');*/
    RETURN -3;
  END IF;

  INSERT INTO REZERWACJE (DATA_REZERWACJI, OKRES, ID_KLIENTA)
    VALUES (curr_date, LEAST(curr_date + 30, data_i - 7), curr_id_klienta);

  SELECT count(*) INTO rzedow FROM MIEJSCA B WHERE ID_STADIONU = curr_id_stadionu AND ID_SEKTORA = curr_id_sektora AND NR_MIEJSCA = 1;
  SELECT count(*) INTO miejsc FROM MIEJSCA B WHERE ID_STADIONU = curr_id_stadionu AND ID_SEKTORA = curr_id_sektora AND RZAD = 1;

  biletow_count := biletow;

  FOR i IN 1..rzedow LOOP
    FOR j IN 1..miejsc LOOP

      IF biletow_count <= 0 THEN
        EXIT;
      END IF;

      /*Sprawdzam czy miejsce zajete*/
      SELECT count(*) INTO b_exst FROM BILETY WHERE ID_IMPREZY = curr_id_imprezy AND ID_SEKTORA = curr_id_sektora AND RZAD = i AND NR_MIEJSCA = j;
      IF b_exst = 0 THEN
        biletow_count := biletow_count -1;
        INSERT INTO BILETY (ID_IMPREZY, ID_STADIONU, ID_SEKTORA, RZAD, NR_MIEJSCA, ID_REZERWACJI)
          VALUES (curr_id_imprezy, curr_id_stadionu, curr_id_sektora, i, j, ID_REZERWACJI_seq.currval);
      END IF;
    END LOOP;
  END LOOP;

  COMMIT;
	DBMS_OUTPUT.put_line('Stworzono recerwacje: ' || ID_REZERWACJI_seq.currval);
  RETURN ID_REZERWACJI_seq.currval;
END;
/

create or replace PROCEDURE stworz_rezerwacje (rezerwacje_per_impreza NUMBER)
IS
  data_i DATE;
  k_exst NUMBER;
  r_per_i NUMBER;
BEGIN

  FOR i IN 1..ID_IMPREZY_seq.currval LOOP
    SELECT DATA_IMPREZY INTO data_i FROM IMPREZY WHERE ID_IMPREZY = i;
    IF data_i - 7 > SYSDATE THEN
      r_per_i := rezerwacje_per_impreza;
      FOR j IN 1..ID_KLIENTA_seq.currval LOOP
        IF r_per_i > 0 THEN
          k_exst := REZERWUJ(round(dbms_random.value(1, 10),0), j, i, round(dbms_random.value(1, ID_SEKTORU_seq.currval),0), SYSDATE - dbms_random.value(0, 30));
          IF k_exst > 0 THEN
            r_per_i := r_per_i - 1;
          END IF;
        ELSE
          EXIT;
        END IF;
      END LOOP;
    END IF;
  END LOOP;

	DBMS_OUTPUT.put_line('Stworzono recerwacje.');
  COMMIT;
END;
/

create or replace FUNCTION zakup (biletow NUMBER, curr_id_klienta NUMBER, curr_id_imprezy NUMBER, curr_id_sektora NUMBER, curr_id_promocji NUMBER DEFAULT 0, curr_data_zakupu DATE DEFAULT (DATE'2000-01-01'))
RETURN NUMBER IS
  k_exst NUMBER;
  m_exst NUMBER;
  b_exst NUMBER;
  curr_id_stadionu NUMBER;
  rzedow NUMBER;
  miejsc NUMBER;
  curr_date DATE;
  data_i DATE;
  biletow_count NUMBER;
  cena_wyj NUMBER(20,2);
  rabat_wej NUMBER;

BEGIN
  SELECT DISTINCT ID_STADIONU INTO curr_id_stadionu FROM IMPREZY WHERE ID_IMPREZY = curr_id_imprezy;

  /*Sprawdzam czy ilosc biletow jest z zakresu (1,10)*/
  IF biletow < 1 OR biletow > 10 THEN
    RETURN -5;
  END IF;

  IF curr_data_zakupu = (DATE'2000-01-01') THEN
    curr_date := SYSDATE;
  ELSE
    curr_date := curr_data_zakupu;
  END IF;

  /*Sprawdzam czy da się kupić bilety - impreza wydarzy się przed data zakupu*/
  SELECT DATA_IMPREZY INTO data_i FROM IMPREZY WHERE ID_IMPREZY = curr_id_imprezy;
  IF data_i < curr_date THEN
    RETURN -4;
  END IF;

  /*Sprawdzam czy klient curr_id_klienta ma juz rezerwacje na impreze curr_id_imprezy: k_exst=0 - nie ma, k_exst>0 - ma*/
  SELECT count(*) INTO k_exst FROM REZERWACJE R JOIN BILETY B ON R.ID_REZERWACJI = B.ID_REZERWACJI WHERE ID_KLIENTA = curr_id_klienta AND ID_IMPREZY = curr_id_imprezy;
  IF k_exst > 0 THEN
    /*DBMS_OUTPUT.put_line('Klien: ' || curr_id_klienta || ' ma juz rezerwacje');*/
    RETURN -2;
  END IF;

  /*Sprawdzam czy klient curr_id_klienta ma juz kupione bilety na impreze curr_id_imprezy: k_exst=0 - nie ma, k_exst>0 - ma*/
  SELECT count(*) INTO k_exst FROM ZAKUPY Z JOIN BILETY B ON Z.ID_ZAKUPU = B.ID_ZAKUPU WHERE ID_KLIENTA = curr_id_klienta AND ID_IMPREZY = curr_id_imprezy;
  IF k_exst > 0 THEN
    /*DBMS_OUTPUT.put_line('Klien: ' || curr_id_klienta || ' ma juz kupione bilety');*/
    RETURN -3;
  END IF;

  /*Sprawdzam czy jest wystarczajaca liczba miejsc w danym sektorze: m_exst - b_exst >= biletow - jest*/
  SELECT count(*) INTO m_exst FROM MIEJSCA WHERE ID_SEKTORA = curr_id_sektora AND ID_STADIONU = curr_id_stadionu;
  SELECT count(*) INTO b_exst FROM BILETY WHERE ID_SEKTORA = curr_id_sektora AND ID_STADIONU = curr_id_stadionu AND ID_IMPREZY = curr_id_imprezy;
  IF m_exst - b_exst < biletow THEN
    /*DBMS_OUTPUT.put_line('miejsc: ' || m_exst || ' biletow: ' || b_exst);*/
    RETURN -1;
  END IF;

  SELECT SUM(CENA) INTO cena_wyj FROM CENY WHERE ID_IMPREZY = curr_id_imprezy AND ID_TYPU_SEKTORA = (SELECT DISTINCT ID_TYPU_SEKTORA FROM SEKTORY WHERE ID_SEKTORA = curr_id_sektora);

  IF curr_id_promocji = 0 THEN
    INSERT INTO ZAKUPY (DATA_ZAKUPU, CENA, ID_KLIENTA)
      VALUES (curr_date, cena_wyj, curr_id_klienta);
  ELSE
    SELECT RABAT INTO rabat_wej FROM PROMOCJE WHERE ID_PROMOCJI = curr_id_promocji;
    IF rabat_wej > 0 THEN
      cena_wyj := round(cena_wyj*(rabat_wej*0.01),2);
    ELSE
      cena_wyj := round(cena_wyj,2);
    END IF;
    INSERT INTO ZAKUPY (DATA_ZAKUPU, CENA, ID_KLIENTA, ID_PROMOCJI)
      VALUES (curr_date, cena_wyj, curr_id_klienta, curr_id_promocji);
  END IF;

  SELECT count(*) INTO rzedow FROM MIEJSCA B WHERE ID_STADIONU = curr_id_stadionu AND ID_SEKTORA = curr_id_sektora AND NR_MIEJSCA = 1;
  SELECT count(*) INTO miejsc FROM MIEJSCA B WHERE ID_STADIONU = curr_id_stadionu AND ID_SEKTORA = curr_id_sektora AND RZAD = 1;

  biletow_count := biletow;

  FOR i IN 1..rzedow LOOP
    FOR j IN 1..miejsc LOOP

      IF biletow_count <= 0 THEN
        EXIT;
      END IF;

      /*Sprawdzam czy miejsce zajete*/
      SELECT count(*) INTO b_exst FROM BILETY WHERE ID_IMPREZY = curr_id_imprezy AND ID_SEKTORA = curr_id_sektora AND RZAD = i AND NR_MIEJSCA = j;
      IF b_exst = 0 THEN
        biletow_count := biletow_count -1;
        INSERT INTO BILETY (ID_IMPREZY, ID_STADIONU, ID_SEKTORA, RZAD, NR_MIEJSCA, ID_ZAKUPU)
          VALUES (curr_id_imprezy, curr_id_stadionu, curr_id_sektora, i, j, ID_ZAKUPU_seq.currval);
      END IF;
    END LOOP;
  END LOOP;

  COMMIT;
	DBMS_OUTPUT.put_line('Stworzono zakup: ' || ID_ZAKUPU_seq.currval);
  RETURN ID_ZAKUPU_seq.currval;
END;
/

create or replace FUNCTION zakup_z_rezerwacji (curr_id_rezerwacji NUMBER, curr_id_promocji NUMBER DEFAULT 0)
RETURN NUMBER IS
BEGIN
  COMMIT;
	DBMS_OUTPUT.put_line('Stworzono zakup: ' || ID_ZAKUPU_seq.currval);
  RETURN ID_ZAKUPU_seq.currval;
END;
/

create or replace PROCEDURE stworz_zakupy (zakupy_per_impreza NUMBER)
IS
  data_i DATE;
  k_exst NUMBER;
  r_per_i NUMBER;
  data_z DATE;
BEGIN

  FOR i IN 1..ID_IMPREZY_seq.currval LOOP
    SELECT DATA_IMPREZY INTO data_i FROM IMPREZY WHERE ID_IMPREZY = i;
    IF data_i - 7 < SYSDATE THEN
      r_per_i := zakupy_per_impreza;
      FOR j IN 1..ID_KLIENTA_seq.currval LOOP
        IF r_per_i > 0 THEN

          data_z := TO_DATE(TRUNC(DBMS_RANDOM.value(TO_CHAR(DATE '2013-01-01','J'),TO_CHAR(LEAST(SYSDATE,data_i), 'J'))),'J');

          k_exst := ZAKUP(round(dbms_random.value(1, 10),0), j, i, round(dbms_random.value(1, ID_SEKTORU_seq.currval),0), 0, data_z);
          IF k_exst > 0 THEN
            r_per_i := r_per_i - 1;
          END IF;
        ELSE
          EXIT;
        END IF;
      END LOOP;
    END IF;
  END LOOP;

	DBMS_OUTPUT.put_line('Stworzono zakupy.');
  COMMIT;
END;
/
