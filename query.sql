/*WYGENERUJ NOWE DANE*/

/*upewnic sie ze wszystko sie usunelo*/
DELETE FROM BILETY;
DELETE FROM ZAKUPY;
DELETE FROM REZERWACJE;
DELETE FROM KARNETY;
DELETE FROM TYPY_KARNETOW;
DELETE FROM PROMOCJE;
DELETE FROM KLIENCI;
DELETE FROM TYPY_KLIENTOW;
DELETE FROM CENA;
DELETE FROM IMPREZY;
DELETE FROM TYPY_IMPREZ;
DELETE FROM MIEJSCA;
DELETE FROM SEKTORY;
DELETE FROM TYPY_SEKTOROW;
DELETE FROM STADIONY;

drop sequence dept_seq;
drop sequence dept_seq2;
drop sequence dept_seq3;
drop sequence dept_seq4;
drop sequence dept_seq5;
drop sequence dept_seq6;

CREATE SEQUENCE dept_seq START WITH 1;
CREATE SEQUENCE dept_seq2 START WITH 1;
CREATE SEQUENCE dept_seq3 START WITH 1;
CREATE SEQUENCE dept_seq4 START WITH 1;
CREATE SEQUENCE dept_seq5 START WITH 1;
CREATE SEQUENCE dept_seq6 START WITH 1;

/*WSTAW DO WSZYSTKIEGO*/
BEGIN
    WSTAW_DO_TYPY_SEKTOROW;
    WSTAW_DO_TYPY_IMPREZ;
    WSTAW_DO_TYPY_KLIENTOW;
    WSTAW_DO_STADIONY;
    WSTAW_DO_IMPREZY;
    WSTAW_DO_PROMOCJE;
    WSTAW_DO_TYPY_KARNETOW;
    WSTAW_DO_KLIENCI;
END;

/* Uzupełnienie promocja_id_promocji */
DECLARE
typ_klienta NUMBER;
prom_id NUMBER;
CURSOR zakupy_cur IS
    Select id_klienta, promocja_id_promocji 
    from zakupy for update;
BEGIN

  FOR zakup IN zakupy_cur 
  LOOP
    SELECT typy_klientow_id_typu into typ_klienta from klienci where id_klienta = zakup.id_klienta;
    SELECT id_promocji into prom_id from promocje where typy_klientow_id_typu = typ_klienta;
    update zakupy set promocja_id_promocji = prom_id where current of zakupy_cur;
  END LOOP;
END;
/
/*KONIEC GENERACJI DANYCH*/

/*TEST WYGENEROWANYCH DANYCH*/
SELECT * FROM typy_sektorow;
SELECT * FROM typy_klientow;
SELECT * FROM TYPY_karnetow;
SELECT * FROM IMPREZY ORDER BY Id_imprezy;
SELECT * FROM STADIONY ORDER BY ID_STADIONU;
SELECT * FROM SEKTORY ORDER BY ID_STADIONU;
SELECT * FROM STADIONY;
SELECT COUNT(*) FROM MIEJSCA WHERE id_sektora=6;
SELECT * FROM IMPREZY ORDER BY data;
SELECT * FROM PROMOCJE;
SELECT Count(*) FROM Klienci ORDER BY PESEL;
SELECT count(*) FROM REZERWACJE;
SELECT * FROM REZERWACJE;
SELECT * FROM bilety;
SELECT * FROM zakupy;
SELECT * FROM karnety;
/*KONIEC TESTÓW WYGENEROWANYCH DANYCH*/