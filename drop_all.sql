DELETE FROM REZERWACJE;
DELETE FROM ZAKUPY;
DELETE FROM BILETY;
DELETE FROM KARNETY;
DELETE FROM TYPY_KARNETOW;
DELETE FROM PROMOCJE;
DELETE FROM KLIENCI;
DELETE FROM TYPY_KLIENTOW;
DELETE FROM CENY;
DELETE FROM IMPREZY;
DELETE FROM TYPY_IMPREZ;
DELETE FROM MIEJSCA;
DELETE FROM SEKTORY;
DELETE FROM STADIONY;
DELETE FROM TYPY_SEKTOROW;

/*drop view*/

drop sequence ID_TYPU_SEKTORA_seq;
drop sequence ID_STADIONU_seq;
drop sequence ID_SEKTORU_seq;
drop sequence ID_TYPU_IMPREZY_seq;
drop sequence ID_IMPREZY_seq;
drop sequence ID_TYPU_KLIENTA_seq;
drop sequence ID_KLIENTA_seq;
drop sequence ID_PROMOCJI_seq;
drop sequence ID_TYPU_KARNETU_seq;
drop sequence ID_KARNETU_seq;
drop sequence ID_REZERWACJI_seq;
drop sequence ID_ZAKUPU_seq;

DROP trigger INCREMENT_ID_TYPU_SEKTORA;
DROP trigger INCREMENT_ID_STADIONU;
DROP trigger INCREMENT_ID_SEKTORA;
DROP trigger INCREMENT_ID_TYPU_IMPREZY;
DROP trigger INCREMENT_ID_IMPREZY;
DROP trigger INCREMENT_ID_TYPU_KLIENTA;
DROP trigger INCREMENT_ID_KLIENTA;
DROP trigger INCREMENT_ID_PROMOCJI;
DROP trigger INCREMENT_ID_TYPU_KARNETU;
DROP trigger INCREMENT_ID_KARNETU;
DROP trigger INCREMENT_ID_REZERWACJI;
DROP trigger INCREMENT_ID_ZAKUPU;
DROP trigger DELETE_BILETY_FROM_REZERWACJE;
DROP trigger DELETE_BILETY_FROM_ZAKUPY;

DROP procedure wstaw_do_typy_sektorow;
DROP procedure stworz_sektor_i_miejsca;
DROP procedure stworz_stadiony;
DROP procedure wstaw_do_typy_imprez;
DROP procedure stworz_imprezy;
DROP procedure stworz_ceny;
DROP procedure wstaw_do_typy_klientow;
DROP procedure stworz_klientow;
DROP procedure wstaw_do_promocje;
DROP procedure wstaw_do_typy_karnetow;
DROP procedure stworz_karnety;
DROP procedure stworz_rezerwacje;
DROP function rezerwuj;
DROP procedure stworz_zakupy;
DROP function zakup;
DROP function zakup_z_rezerwacji;

COMMIT;