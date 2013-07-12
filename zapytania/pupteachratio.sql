--ZAPYTANIA ZWIAZANE Z LICZENIEM PUPIL TO TEACHER RATIO

--PUPIL TO TEACHER RATIO DLA GMIN

--liczba nauczycieli w bazie (tylko unikalne rekordy zapewnione opcja distinct)

select count(distinct jedn_ped.pedag_pesel) from sio2012.jedn_ped;

-- Liczba uczniów ogolem w bazie (na dzien badania) przy zalozeniu, ze uczen ma jedna szkole
-- sumujemy liczbe uczniow w klasach z dostepnej bazy

select sum(jednnaboddzkl_uczbrok.jednnaboddzkl_brokucz) from sio2012.jednnaboddzkl_uczbrok;

--zapytanie dajace jednoczenie liczbe uczniow, liczbe nauczycieli pogrupowane wzgledem gmin

select sum(jednnaboddzkl_uczbrok.jednnaboddzkl_brokucz) as liczba_uczniow, count(distinct jedn_ped.pedag_pesel) as liczba_nauczycieli, smiejscow.gmina_id as kod_gminy from sio2012.jedn, sio2012.smiejscow, sio2012.jedn_ped, sio2012.jednnaboddzkl_uczbrok where smiejscow.miejscow_id=jedn.miejscow_id and jedn_ped.jedn_id=jedn.jedn_id and jednnaboddzkl_uczbrok.jedn_id=jedn_ped.jedn_id and jednnaboddzkl_uczbrok.jedn_id=jedn.jedn_id group by smiejscow.gmina_id;


