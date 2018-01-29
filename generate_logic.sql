/*SET DEFINE OFF;*/

/*SEKWENCJE*/

CREATE SEQUENCE ID_TYPU_SEKTORA_seq START WITH 4;
CREATE SEQUENCE ID_TYPU_IMPREZY_seq START WITH 4;
CREATE SEQUENCE ID_TYPU_KLIENTA_seq START WITH 13;
CREATE SEQUENCE ID_PROMOCJI_seq     START WITH 30;
CREATE SEQUENCE ID_TYPU_KARNETU_seq START WITH 13;

CREATE SEQUENCE ID_STADIONU_seq     START WITH 1;
CREATE SEQUENCE ID_SEKTORU_seq      START WITH 1;
CREATE SEQUENCE ID_IMPREZY_seq      START WITH 1;
CREATE SEQUENCE ID_KLIENTA_seq      START WITH 1;
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
    INSERT INTO typy_sektorow (ID_TYPU_SEKTORA, NAZWA, OPIS) VALUES (1, 'TYP 1','test_opis1');
    INSERT INTO typy_sektorow (ID_TYPU_SEKTORA, NAZWA, OPIS) VALUES (2, 'TYP 2','test_opis2');
    INSERT INTO typy_sektorow (ID_TYPU_SEKTORA, NAZWA, OPIS) VALUES (3, 'TYP 3','test_opis3');

	DBMS_OUTPUT.put_line('Dodano wszystkie typy sektorów.');
COMMIT;
END;
/

create or replace PROCEDURE wstaw_do_typy_imprez
IS
BEGIN

    INSERT INTO typy_imprez (ID_TYPU_IMPREZY, NAZWA, OPIS) VALUES (1, 'Występ','test_opis1');
    INSERT INTO typy_imprez (ID_TYPU_IMPREZY, NAZWA, OPIS) VALUES (2, 'Wydarzenie sportowe','test_opis2');
    INSERT INTO typy_imprez (ID_TYPU_IMPREZY, NAZWA, OPIS) VALUES (3, 'Koncert','test_opis3');

	DBMS_OUTPUT.put_line('Dodano wszystkie typy imprez.');
COMMIT;
END;
/

create or replace PROCEDURE wstaw_do_typy_klientow
IS
BEGIN
    INSERT INTO typy_klientow (ID_TYPU_KLIENTA, NAZWA, OPIS) VALUES (1, 'Normalny', 'Dorosly');
    INSERT INTO typy_klientow (ID_TYPU_KLIENTA, NAZWA, OPIS) VALUES (2, 'Dziecko',  'Dziecko do lat 12');
    INSERT INTO typy_klientow (ID_TYPU_KLIENTA, NAZWA, OPIS) VALUES (3, 'Emeryt',   'Po osiegnieciu wieku emerytalnego: 65 lat');
    INSERT INTO typy_klientow (ID_TYPU_KLIENTA, NAZWA, OPIS) VALUES (4, 'Kombatant','kombatant wojennych');

    INSERT INTO typy_klientow (ID_TYPU_KLIENTA, NAZWA, OPIS) VALUES (5, 'Normalny/Stały klient 1', 'Dorosly');
    INSERT INTO typy_klientow (ID_TYPU_KLIENTA, NAZWA, OPIS) VALUES (6, 'Dziecko/Stały klient 1',  'Dziecko do lat 12');
    INSERT INTO typy_klientow (ID_TYPU_KLIENTA, NAZWA, OPIS) VALUES (7, 'Emeryt/Stały klient 1',   'Po osiegnieciu wieku emerytalnego: 65 lat');
    INSERT INTO typy_klientow (ID_TYPU_KLIENTA, NAZWA, OPIS) VALUES (8, 'Kombatant/Stały klient 1','kombatant wojennych');

    INSERT INTO typy_klientow (ID_TYPU_KLIENTA, NAZWA, OPIS) VALUES (9, 'Normalny/Stały klient 2', 'Dorosly');
    INSERT INTO typy_klientow (ID_TYPU_KLIENTA, NAZWA, OPIS) VALUES (10,'Dziecko/Stały klient 2',  'Dziecko do lat 12');
    INSERT INTO typy_klientow (ID_TYPU_KLIENTA, NAZWA, OPIS) VALUES (11,'Emeryt/Stały klient 2',   'Po osiegnieciu wieku emerytalnego: 65 lat');
    INSERT INTO typy_klientow (ID_TYPU_KLIENTA, NAZWA, OPIS) VALUES (12,'Kombatant/Stały klient 2','kombatant wojennych');
	DBMS_OUTPUT.put_line('Dodano wszystkie typy klientów.');
COMMIT;
END;
/

create or replace PROCEDURE wstaw_do_promocje
IS
BEGIN
  FOR i IN 1..12 LOOP
    INSERT INTO PROMOCJE (ID_PROMOCJI, NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES (i,'Brak',0,'Nie przysluguje znizka', i);
  END LOOP;

  INSERT INTO promocje (ID_PROMOCJI, NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES (13,'Zniżka dziecięca',50,'50% zniżki od ceny oryginalnej', 2 );
  INSERT INTO promocje (ID_PROMOCJI, NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES (14,'Zniżka dziecięca',50,'50% zniżki od ceny oryginalnej', 6 );
  INSERT INTO promocje (ID_PROMOCJI, NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES (15,'Zniżka dziecięca',50,'50% zniżki od ceny oryginalnej', 10 );

  INSERT INTO promocje (ID_PROMOCJI, NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES (16, 'Zniżka dla emeryta',70,'70% zniżki od ceny oryginalnej', 3);
  INSERT INTO promocje (ID_PROMOCJI, NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES (17, 'Zniżka dla emeryta',70,'70% zniżki od ceny oryginalnej', 7);
  INSERT INTO promocje (ID_PROMOCJI, NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES (18, 'Zniżka dla emeryta',70,'70% zniżki od ceny oryginalnej', 11);

  INSERT INTO promocje (ID_PROMOCJI, NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES (19, 'Zniżka dla kombatanta',95,'90% zniżki od ceny oryginalnej', 4);
  INSERT INTO promocje (ID_PROMOCJI, NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES (20, 'Zniżka dla kombatanta',95,'90% zniżki od ceny oryginalnej', 8);
  INSERT INTO promocje (ID_PROMOCJI, NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES (21, 'Zniżka dla kombatanta',95,'90% zniżki od ceny oryginalnej', 12);

  FOR i IN 0..3 LOOP
    INSERT INTO PROMOCJE (ID_PROMOCJI, NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES (22 + i, 'Stały klient 1',10,'10% zniżki od ceny oryginalnej dla osob, które kupiły n biletów w ciągu ostatniego pol roku', 5 + i);
  END LOOP;

  FOR i IN 0..3 LOOP
    INSERT INTO PROMOCJE (ID_PROMOCJI, NAZWA, RABAT, OPIS, ID_TYPU_KLIENTA) VALUES (26 + i, 'Stały klient 2',20,'20% zniżki od ceny oryginalnej dla osob, które wydaly n zlotych w ciągu ostatniego pol roku', 9 + i);
  END LOOP;

	DBMS_OUTPUT.put_line('Dodano wszystkie promocje.');
COMMIT;
END;
/

create or replace PROCEDURE wstaw_do_typy_karnetow
IS
BEGIN

    INSERT INTO typy_karnetow (ID_TYPU_KARNETU, NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES (1, 'Karnet Ligi Diamentowej Cheap', 2000, 6, 'brak opisu', 1, 2);
    INSERT INTO typy_karnetow (ID_TYPU_KARNETU, NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES (2, 'Karnet Ligi Diamentowej Normal', 3000, 6, 'brak opisu', 2, 2);
    INSERT INTO typy_karnetow (ID_TYPU_KARNETU, NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES (3, 'Karnet Ligi Diamentowej Premium', 4000, 6, 'brak opisu', 3, 2);

    INSERT INTO typy_karnetow (ID_TYPU_KARNETU, NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES (4, 'Karnet Klubu Kabaretowego Cheap', 100, 3, 'brak opisu', 1, 3);
    INSERT INTO typy_karnetow (ID_TYPU_KARNETU, NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES (5,'Karnet Klubu Kabaretowego Normal', 150, 3, 'brak opisu', 2, 3);
    INSERT INTO typy_karnetow (ID_TYPU_KARNETU, NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES (6, 'Karnet Klubu Kabaretowego Premium', 200, 3, 'brak opisu', 3, 3);

    INSERT INTO typy_karnetow (ID_TYPU_KARNETU, NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES (7, 'Karnet Sezonu Piłkarskiego Cheap',200, 9, 'brak opisu', 1, 2);
    INSERT INTO typy_karnetow (ID_TYPU_KARNETU, NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES (8, 'Karnet Sezonu Piłkarskiego Normal',400, 9, 'brak opisu', 2, 2);
    INSERT INTO typy_karnetow (ID_TYPU_KARNETU, NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES (9, 'Karnet Sezonu Piłkarskiego Premium',600, 9, 'brak opisu', 3, 2);

    INSERT INTO typy_karnetow (ID_TYPU_KARNETU, NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES (10, 'Karnet Koncertowy Cheap',600, 2, 'brak opisu', 1, 1);
    INSERT INTO typy_karnetow (ID_TYPU_KARNETU, NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES (11, 'Karnet Koncertowy Normal',800, 2, 'brak opisu', 2, 1);
    INSERT INTO typy_karnetow (ID_TYPU_KARNETU, NAZWA, CENA, OKRES_WAZNOSCI, OPIS, ID_TYPU_SEKTORA, ID_TYPU_IMPREZY) VALUES (12, 'Karnet Koncertowy Premium',1000, 2, 'brak opisu', 3, 1);

	DBMS_OUTPUT.put_line('Dodano wszystkie typy karnetów.');
COMMIT;
END;
/

create or replace PROCEDURE stworz_sektor_i_miejsca (curr_id_stadionu NUMBER, type_sector NUMBER, rows NUMBER, seats_per_row NUMBER, curr_id_sektora NUMBER DEFAULT NULL)
IS
  curr_id_s NUMBER;
BEGIN
	INSERT INTO SEKTORY (ID_SEKTORA, ID_TYPU_SEKTORA, ID_STADIONU) VALUES (curr_id_sektora, type_sector, curr_id_stadionu);

  IF curr_id_sektora IS NULL THEN
    curr_id_s := ID_SEKTORU_seq.currval;
  ELSE
    curr_id_s := curr_id_sektora;
  END IF;

  FOR i IN 1..rows LOOP
    FOR j IN 1..seats_per_row LOOP
      INSERT INTO MIEJSCA VALUES(i, j, curr_id_s, curr_id_stadionu);
    END LOOP;
  END LOOP;

	COMMIT;
  DBMS_OUTPUT.PUT_LINE('Dodano sektor: ' || curr_id_s || ' i miejsca: ' || rows  || 'x' || seats_per_row);
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
      STWORZ_SEKTOR_I_MIEJSCA(id, 1, 50, 100, j);
    END LOOP;

    FOR j IN 5..8 LOOP
      STWORZ_SEKTOR_I_MIEJSCA(id, 2, 100, 100, j);
    END LOOP;

    FOR j IN 9..12 LOOP
      STWORZ_SEKTOR_I_MIEJSCA(id, 3, 50, 100, j);
    END LOOP;
    DBMS_OUTPUT.put_line('Dodano wszystkie sektory w stadionie: ' || id);


	END LOOP;
	COMMIT;
	DBMS_OUTPUT.put_line('Dodano wszystkie stadiony.');
END;
/

create or replace PROCEDURE stworz_ceny (curr_id_imprezy NUMBER)
is
  CURSOR id_typu_sektora_cur IS
    SELECT DISTINCT ID_TYPU_SEKTORA
    FROM SEKTORY
    WHERE ID_STADIONU = (SELECT I.ID_STADIONU FROM IMPREZY I WHERE ID_IMPREZY = curr_id_imprezy)
    ORDER BY ID_TYPU_SEKTORA;

  price NUMBER;
  curr_id_typu_imprezy NUMBER;
  curr_id_typu_sektora NUMBER;

BEGIN
  SELECT ID_TYPU_IMPREZY INTO curr_id_typu_imprezy FROM IMPREZY WHERE ID_IMPREZY = curr_id_imprezy;

  price := 50 * curr_id_typu_imprezy;

  OPEN id_typu_sektora_cur;
  LOOP
    FETCH id_typu_sektora_cur INTO curr_id_typu_sektora;
    EXIT WHEN id_typu_sektora_cur%NOTFOUND;

    INSERT INTO CENY (CENA, ID_TYPU_SEKTORA, ID_IMPREZY, ID_TYPU_IMPREZY)
      VALUES(round(dbms_random.value(price*curr_id_typu_sektora,price*(curr_id_typu_sektora+1)),2), curr_id_typu_sektora, curr_id_imprezy, curr_id_typu_imprezy);
  END LOOP;

  CLOSE id_typu_sektora_cur;

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


  CURSOR id_stadionu_cur IS
    SELECT DISTINCT ID_STADIONU
    FROM STADIONY
    ORDER BY ID_STADIONU;

  curr_id_stadionu NUMBER;

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

  OPEN id_stadionu_cur;
  LOOP
    FETCH id_stadionu_cur INTO curr_id_stadionu;
    EXIT WHEN id_stadionu_cur%NOTFOUND;

    FOR i IN 0..(years-1) LOOP
      FOR j IN 1..imprezy_per_year LOOP
          INSERT into imprezy (NAZWA, DATA_IMPREZY, ID_STADIONU, ID_TYPU_IMPREZY, OPIS)
            values (nazwa(round(dbms_random.value(1,qnazwa))), add_months(dates(21-j),-12*i) + (1/24*20), curr_id_stadionu, round(dbms_random.value(1,3)), 'test_opis');
            STWORZ_CENY(ID_IMPREZY_seq.currval);
      END LOOP;
    END LOOP;
  END LOOP;
  CLOSE id_stadionu_cur;

	COMMIT;
  DBMS_OUTPUT.put_line('Dodano wszystkie imprezy.');
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

create or replace FUNCTION stworz_karnet (curr_id_klienta NUMBER, curr_id_typu_karnetu NUMBER, curr_id_promocji NUMBER DEFAULT 0, curr_data_wystawienia DATE DEFAULT (DATE'2000-01-01'))
RETURN NUMBER IS
  curr_data DATE;
  curr_cena NUMBER;
  curr_id_typu_klienta NUMBER;
  okres_wyj NUMBER;
  rabat_wej NUMBER;
  p_exst NUMBER;

BEGIN
  /*Sprawdzam czy Klinet posiada dana promocje*/
  IF curr_id_promocji > 0 THEN
    SELECT count(*) INTO p_exst FROM KLIENCI K JOIN PROMOCJE P ON K.ID_TYPU_KLIENTA = P.ID_TYPU_KLIENTA WHERE ID_KLIENTA = curr_id_klienta AND ID_PROMOCJI = curr_id_promocji;
    IF p_exst = 0 THEN
      RETURN -1;
    END IF;
  END IF;

  IF curr_data_wystawienia = (DATE'2000-01-01') THEN
    curr_data := SYSDATE;
  ELSE
    curr_data := curr_data_wystawienia;
  END IF;

  SELECT ID_TYPU_KLIENTA INTO curr_id_typu_klienta FROM KLIENCI WHERE ID_KLIENTA = curr_id_klienta;

  SELECT CENA, OKRES_WAZNOSCI INTO curr_cena, okres_wyj FROM typy_karnetow WHERE ID_TYPU_KARNETU = curr_id_typu_karnetu;

  IF curr_id_promocji <= 0 THEN
    INSERT INTO KARNETY (DATA_WYSTAWIENIA, DATA_WAZNOSCI, CENA, ID_KLIENTA, ID_TYPU_KLIENTA, ID_TYPU_KARNETU)
      VALUES (curr_data, add_months(curr_data,okres_wyj), curr_cena, curr_id_klienta, curr_id_typu_klienta, curr_id_typu_karnetu);

  ELSE
    SELECT RABAT INTO rabat_wej FROM PROMOCJE WHERE ID_PROMOCJI = curr_id_promocji;
    IF rabat_wej > 0 THEN
      curr_cena := round(curr_cena - curr_cena*(rabat_wej*0.01),2);
    ELSE
      curr_cena := round(curr_cena,2);
    END IF;
    INSERT INTO KARNETY (DATA_WYSTAWIENIA, DATA_WAZNOSCI, CENA, ID_KLIENTA, ID_TYPU_KLIENTA, ID_TYPU_KARNETU, ID_PROMOCJI)
      VALUES (curr_data, add_months(curr_data,okres_wyj), curr_cena, curr_id_klienta, curr_id_typu_klienta, curr_id_typu_karnetu, curr_id_promocji);
  END IF;

  COMMIT;
	DBMS_OUTPUT.put_line('Stworzono karnet: ' || ID_KARNETU_seq.currval);
  RETURN ID_KARNETU_seq.currval;
END;
/

create or replace PROCEDURE stworz_karnety (nr_karnety NUMBER)
IS
  rand_date DATE;
  typ_karnetu NUMBER;

  CURSOR id_klienta_cur IS
    SELECT  ID_KLIENTA
    FROM KLIENCI;

  curr_id_klienta NUMBER;
  size_klienci NUMBER;
  repeatt NUMBER;

  k_exst NUMBER;

BEGIN

  SELECT count(*) INTO size_klienci FROM KLIENCI;
  repeatt := round(nr_karnety/size_klienci + 1/2 - 1/1000000);

  OPEN id_klienta_cur;

  FOR i IN 0..(nr_karnety-1) LOOP

    IF MOD(i,repeatt) = 0 THEN
      FETCH id_klienta_cur INTO curr_id_klienta;
      EXIT WHEN id_klienta_cur%NOTFOUND;
    END IF;

    typ_karnetu := round(dbms_random.value(1, 12));
    rand_date := TO_DATE(TRUNC(DBMS_RANDOM.value(TO_CHAR(date '2013-01-01','J'),TO_CHAR(DATE '2017-12-31','J'))),'J');

    k_exst := STWORZ_KARNET(curr_id_klienta, typ_karnetu, 0, rand_date);

  END LOOP;
  CLOSE id_klienta_cur;

	DBMS_OUTPUT.put_line('Stworzono karnety: ' || nr_karnety);
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

  CURSOR miejsca_rzad_miejsca_cur IS
    SELECT RZAD, NR_MIEJSCA
    FROM MIEJSCA
    WHERE ID_STADIONU = curr_id_stadionu AND ID_SEKTORA = curr_id_sektora
    ORDER BY RZAD, NR_MIEJSCA;

  miejsca_r_m miejsca_rzad_miejsca_cur%ROWTYPE;

  CURSOR bilety_rzad_miejsca_cur IS
    SELECT RZAD, NR_MIEJSCA
    FROM BILETY
    WHERE ID_STADIONU = curr_id_stadionu AND ID_SEKTORA = curr_id_sektora AND ID_IMPREZY = curr_id_imprezy
    ORDER BY RZAD, NR_MIEJSCA;

  bilety_r_m bilety_rzad_miejsca_cur%ROWTYPE;

BEGIN
  SELECT DISTINCT ID_STADIONU INTO curr_id_stadionu FROM IMPREZY WHERE ID_IMPREZY = curr_id_imprezy;

  /*Sprawdzam czy ilosc biletow jest z zakresu (1,10)*/
  IF biletow < 1 OR biletow > 10 THEN
    RETURN -5;
  END IF;

  IF curr_data_rezerwacji <= (DATE'2000-01-01') THEN
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
    RETURN -1;
  END IF;

  /*Sprawdzam czy klient curr_id_klienta ma juz rezerwacje na impreze curr_id_imprezy: k_exst=0 - nie ma, k_exst>0 - ma*/
  SELECT count(*) INTO k_exst FROM REZERWACJE R JOIN BILETY B ON R.ID_REZERWACJI = B.ID_REZERWACJI WHERE ID_KLIENTA = curr_id_klienta AND ID_IMPREZY = curr_id_imprezy;
  IF k_exst > 0 THEN
    RETURN -2;
  END IF;

  /*Sprawdzam czy klient curr_id_klienta ma juz kupione bilety na impreze curr_id_imprezy: k_exst=0 - nie ma, k_exst>0 - ma*/
  SELECT count(*) INTO k_exst FROM ZAKUPY Z JOIN BILETY B ON Z.ID_ZAKUPU = B.ID_ZAKUPU WHERE ID_KLIENTA = curr_id_klienta AND ID_IMPREZY = curr_id_imprezy;
  IF k_exst > 0 THEN
    RETURN -3;
  END IF;

  INSERT INTO REZERWACJE (DATA_REZERWACJI, OKRES, ID_KLIENTA)
    VALUES (curr_date, LEAST(curr_date + 30, data_i - 7), curr_id_klienta);


  biletow_count := biletow;

  OPEN miejsca_rzad_miejsca_cur;
  OPEN bilety_rzad_miejsca_cur;
  FETCH bilety_rzad_miejsca_cur INTO bilety_r_m;
  LOOP
    FETCH miejsca_rzad_miejsca_cur INTO miejsca_r_m;
    EXIT WHEN miejsca_rzad_miejsca_cur%NOTFOUND;
    EXIT WHEN biletow_count <= 0;

    IF bilety_rzad_miejsca_cur%NOTFOUND THEN
      INSERT INTO BILETY (ID_IMPREZY, ID_STADIONU, ID_SEKTORA, RZAD, NR_MIEJSCA, ID_REZERWACJI)
          VALUES (curr_id_imprezy, curr_id_stadionu, curr_id_sektora, miejsca_r_m.RZAD, miejsca_r_m.NR_MIEJSCA, ID_REZERWACJI_seq.currval);
      biletow_count := biletow_count -1;
    ELSE
      IF  miejsca_r_m.RZAD =  bilety_r_m.RZAD AND miejsca_r_m.NR_MIEJSCA = bilety_r_m.NR_MIEJSCA THEN
        FETCH bilety_rzad_miejsca_cur INTO bilety_r_m;
      ELSE
        INSERT INTO BILETY (ID_IMPREZY, ID_STADIONU, ID_SEKTORA, RZAD, NR_MIEJSCA, ID_REZERWACJI)
          VALUES (curr_id_imprezy, curr_id_stadionu, curr_id_sektora, miejsca_r_m.RZAD, miejsca_r_m.NR_MIEJSCA, ID_REZERWACJI_seq.currval);
      biletow_count := biletow_count -1;
      END IF;
    END IF;

  END LOOP;
  CLOSE bilety_rzad_miejsca_cur;
  CLOSE miejsca_rzad_miejsca_cur;

  COMMIT;
	DBMS_OUTPUT.put_line('Stworzono recerwacje: ' || ID_REZERWACJI_seq.currval);
  RETURN ID_REZERWACJI_seq.currval;
END;
/

create or replace PROCEDURE stworz_rezerwacje (rezerwacje_per_impreza NUMBER)
IS
  CURSOR id_imprezy_cur IS
    SELECT ID_IMPREZY
    FROM IMPREZY;

  curr_id_imprezy NUMBER;

  CURSOR id_klienta_cur IS
    SELECT ID_KLIENTA
    FROM KLIENCI;

  curr_id_klienta NUMBER;

  data_i DATE;
  k_exst NUMBER;
  r_per_i NUMBER;

BEGIN

  OPEN id_imprezy_cur;
  LOOP
    FETCH id_imprezy_cur INTO curr_id_imprezy;
    EXIT WHEN id_imprezy_cur%NOTFOUND;

    SELECT DATA_IMPREZY INTO data_i FROM IMPREZY WHERE ID_IMPREZY = curr_id_imprezy;
    IF data_i - 7 > SYSDATE THEN
      r_per_i := rezerwacje_per_impreza;

      OPEN id_klienta_cur;
      LOOP
        FETCH id_klienta_cur INTO curr_id_klienta;
        EXIT WHEN id_klienta_cur%NOTFOUND;

        EXIT WHEN r_per_i <= 0;
        k_exst := REZERWUJ(round(dbms_random.value(1, 10)), curr_id_klienta, curr_id_imprezy, round(dbms_random.value(1, 12)), SYSDATE - dbms_random.value(0, 30));
        IF k_exst > 0 THEN
          r_per_i := r_per_i - 1;
        END IF;
      END LOOP;
      CLOSE id_klienta_cur;
    END IF;
  END LOOP;
  CLOSE id_imprezy_cur;

	DBMS_OUTPUT.put_line('Stworzono recerwacje.');
COMMIT;
END;
/

create or replace FUNCTION zakup_z_rezerwacji (curr_id_rezerwacji NUMBER, curr_id_promocji NUMBER DEFAULT 0)
RETURN NUMBER IS
  r_exst NUMBER;
  id_k NUMBER;
  p_exst NUMBER;
  cena_wyj NUMBER(20,2);
  rabat_wej NUMBER;
  count_b NUMBER;
BEGIN
  /*Sprawdzam czy da się kupić bilety - impreza wydarzy się przed data zakupu*/
  /*dopisac....*/

  /*Sprawdzam czy curr_id_rezerwacji istnieje*/
  SELECT count(*) INTO r_exst FROM REZERWACJE WHERE ID_REZERWACJI = curr_id_rezerwacji;
  IF r_exst = 0 THEN
    RETURN -1;
  END IF;

  /*Sprawdzam czy bilety z rezerwacji zostaly juz kupione*/
  SELECT count(*) INTO r_exst FROM BILETY WHERE ID_REZERWACJI = curr_id_rezerwacji AND ID_ZAKUPU IS NOT NULL;
  IF r_exst > 0 THEN
    RETURN -2;
  END IF;

  SELECT ID_KLIENTA INTO id_k FROM REZERWACJE WHERE ID_REZERWACJI = curr_id_rezerwacji;

  /*Sprawdzam czy Klinet posiada dana promocje*/
  IF curr_id_promocji > 0 THEN
    SELECT count(*) INTO p_exst FROM KLIENCI K JOIN PROMOCJE P ON K.ID_TYPU_KLIENTA = P.ID_TYPU_KLIENTA WHERE ID_KLIENTA = id_k AND ID_PROMOCJI = curr_id_promocji;
    IF p_exst = 0 THEN
      RETURN -3;
    END IF;
  END IF;


  SELECT CENA INTO cena_wyj FROM CENY WHERE
    ID_IMPREZY = (SELECT  DISTINCT B.ID_IMPREZY FROM BILETY B WHERE ID_REZERWACJI = curr_id_rezerwacji) AND
    ID_TYPU_SEKTORA = (SELECT DISTINCT S.ID_TYPU_SEKTORA FROM SEKTORY S WHERE ID_SEKTORA = (SELECT  DISTINCT B.ID_SEKTORA FROM BILETY B WHERE ID_REZERWACJI = curr_id_rezerwacji));

  SELECT count(*) INTO count_b FROM BILETY WHERE ID_REZERWACJI = curr_id_rezerwacji;
  cena_wyj := cena_wyj * count_b;

  IF curr_id_promocji <= 0 THEN
    INSERT INTO ZAKUPY (DATA_ZAKUPU, CENA, ID_KLIENTA)
      VALUES (SYSDATE, cena_wyj, id_k);
  ELSE
    SELECT RABAT INTO rabat_wej FROM PROMOCJE WHERE ID_PROMOCJI = curr_id_promocji;
    IF rabat_wej > 0 THEN
      cena_wyj := round(cena_wyj*(rabat_wej*0.01),2);
    ELSE
      cena_wyj := round(cena_wyj,2);
    END IF;
    INSERT INTO ZAKUPY (DATA_ZAKUPU, CENA, ID_KLIENTA, ID_PROMOCJI)
      VALUES (SYSDATE, cena_wyj, id_k, curr_id_promocji);
  END IF;

  UPDATE BILETY SET ID_ZAKUPU = ID_ZAKUPU_seq.currval WHERE ID_REZERWACJI = curr_id_rezerwacji;

  DELETE FROM REZERWACJE WHERE ID_REZERWACJI = curr_id_rezerwacji;

  COMMIT;
	DBMS_OUTPUT.put_line('Stworzono zakup z rezerwacji: ' || ID_ZAKUPU_seq.currval);
  RETURN ID_ZAKUPU_seq.currval;
END;
/

create or replace FUNCTION zakup (biletow NUMBER, curr_id_klienta NUMBER, curr_id_imprezy NUMBER, curr_id_sektora NUMBER, curr_id_promocji NUMBER DEFAULT 0, curr_data_zakupu DATE DEFAULT (DATE'2000-01-01'))
RETURN NUMBER IS
  ret_rezerwuj NUMBER;
  ret_zakup NUMBER;
BEGIN
  ret_rezerwuj := REZERWUJ(biletow, curr_id_klienta, curr_id_imprezy, curr_id_sektora, curr_data_zakupu - 7);

  IF ret_rezerwuj <= 0 THEN
    RETURN ret_rezerwuj;
  END IF;

  ret_zakup := ZAKUP_Z_REZERWACJI(ret_rezerwuj, curr_id_promocji);

  IF ret_zakup <= 0 THEN
    DELETE FROM REZERWACJE WHERE ID_REZERWACJI = ret_rezerwuj;
    RETURN ret_zakup;
  END IF;

  IF curr_data_zakupu <= (DATE'2000-01-01') THEN
    UPDATE ZAKUPY SET DATA_ZAKUPU = curr_data_zakupu WHERE ID_ZAKUPU = ret_zakup;
  END IF;

  COMMIT;
	DBMS_OUTPUT.put_line('Stworzono zakup: ' || ID_ZAKUPU_seq.currval);
  RETURN ID_ZAKUPU_seq.currval;
END;
/

create or replace PROCEDURE stworz_zakupy (zakupy_per_impreza NUMBER)
IS
  CURSOR id_imprezy_cur IS
    SELECT ID_IMPREZY
    FROM IMPREZY;

  curr_id_imprezy NUMBER;

  CURSOR id_klienta_cur IS
    SELECT ID_KLIENTA
    FROM KLIENCI;

  curr_id_klienta NUMBER;

  data_i DATE;
  k_exst NUMBER;
  r_per_i NUMBER;
  data_z DATE;
BEGIN

  OPEN id_imprezy_cur;
  LOOP
    FETCH id_imprezy_cur INTO curr_id_imprezy;
    EXIT WHEN id_imprezy_cur%NOTFOUND;

    SELECT DATA_IMPREZY INTO data_i FROM IMPREZY WHERE ID_IMPREZY = curr_id_imprezy;
    IF data_i - 7 < SYSDATE THEN
      r_per_i := zakupy_per_impreza;

      OPEN id_klienta_cur;
      LOOP
        FETCH id_klienta_cur INTO curr_id_klienta;
        EXIT WHEN id_klienta_cur%NOTFOUND;

        EXIT WHEN r_per_i <= 0;

        data_z := TO_DATE(TRUNC(DBMS_RANDOM.value(TO_CHAR(DATE '2013-01-01','J'),TO_CHAR(LEAST(SYSDATE,data_i), 'J'))),'J');
        k_exst := ZAKUP(round(dbms_random.value(1, 10)), curr_id_klienta, curr_id_imprezy, round(dbms_random.value(1, 12)), 0, data_z);
        IF k_exst > 0 THEN
          r_per_i := r_per_i - 1;
        END IF;
      END LOOP;
      CLOSE id_klienta_cur;
    END IF;
  END LOOP;
  CLOSE id_imprezy_cur;

	DBMS_OUTPUT.put_line('Stworzono zakupy.');
  COMMIT;
END;
/
