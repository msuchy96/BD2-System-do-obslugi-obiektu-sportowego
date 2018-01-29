/*SET DEFINE OFF;*/

/*SEKWENCJE*/

CREATE SEQUENCE ID_TYPU_SEKTORA_seq START WITH 1;
CREATE SEQUENCE ID_STADIONU_seq     START WITH 1;
CREATE SEQUENCE ID_SEKTORU_seq      START WITH 1;
CREATE SEQUENCE ID_TYPU_IMPREZY_seq START WITH 1;
CREATE SEQUENCE ID_IMPREZY_seq      START WITH 1;


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
      stworz_sektor_i_miejsca(id, 1, 50, 100);
    END LOOP;

    FOR j IN 5..8 LOOP
      stworz_sektor_i_miejsca(id, 2, 100, 100);
    END LOOP;

    FOR j IN 9..12 LOOP
      stworz_sektor_i_miejsca(id, 3, 50, 100);
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

    INSERT INTO typy_imprez (NAZWA, OPIS) VALUES ('Koncert','test_opis1');
    INSERT INTO typy_imprez (NAZWA, OPIS) VALUES ('Wydarzenie sportowe','test_opis2');
    INSERT INTO typy_imprez (NAZWA, OPIS) VALUES ('Występ','test_opis3');

	DBMS_OUTPUT.put_line('Dodano wszystkie typy imprez.');
COMMIT;
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

  dates := TABSTR2(DATE'2013-02-14',DATE'2013-03-23',DATE'2013-04-02',DATE'2013-07-16',
                    DATE'2013-09-18',DATE'2013-10-15',DATE'2013-11-11',DATE'2013-12-30',
                    DATE'2013-02-02',DATE'2013-03-10',DATE'2013-04-04',DATE'2013-06-12',
                    DATE'2013-05-30',DATE'2013-03-03',DATE'2013-04-23',DATE'2013-09-23',
                    DATE'2013-10-07',DATE'2013-11-14',DATE'2013-11-22',DATE'2013-12-14');
  qdates := dates.count;
  FOR i IN 0..(years-1) LOOP
    FOR j IN 1..imprezy_per_year LOOP
        INSERT into imprezy (NAZWA, DATA_IMPREZY, ID_STADIONU, ID_TYPU_IMPREZY, OPIS)
          values (nazwa(round(dbms_random.value(1,qnazwa))), add_months(dates(j),12*i), round(dbms_random.value(1,ID_STADIONU_seq.currval)), round(dbms_random.value(1,ID_TYPU_IMPREZY_seq.currval)),'test_opis');
    END LOOP;
  END LOOP;
	COMMIT;
  DBMS_OUTPUT.put_line('Dodano wszystkie imprezy.');
END;
/

