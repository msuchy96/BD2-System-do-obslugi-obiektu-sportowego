BEGIN
    WSTAW_DO_TYPY_SEKTOROW();
    WSTAW_DO_TYPY_IMPREZ();
    WSTAW_DO_TYPY_KLIENTOW();
    WSTAW_DO_PROMOCJE();
    WSTAW_DO_TYPY_KARNETOW();

    STWORZ_STADIONY(1);
    STWORZ_IMPREZY(1,20);
    STWORZ_KLIENTOW(10);
    STWORZ_KARNETY(10);
    STWORZ_REZERWACJE(5);
    STWORZ_ZAKUPY(10);
END;
/

DECLARE
    out NUMBER;
BEGIN
    DELETE_FROM_TABLES(out);
    DBMS_OUTPUT.put_line('Usunieto wszystki z tabel: ' || out);
END;
/

DECLARE
    out NUMBER;
BEGIN
    POPULATE(out);
    DBMS_OUTPUT.put_line('Usunieto wszystki z tabel: ' || out);
END;
/