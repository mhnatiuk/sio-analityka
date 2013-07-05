--ZAPYTANIA ZWIAZANE Z LICZENIEM PUPIL TO TEACHER RATIO

--PUPIL TO TEACHER RATIO DLA GMIN

--liczba nauczycieli w bazie (tylko unikalne rekordy zapewnione opcja distinct)

select count(distinct jedn_ped.pedag_pesel) from sio2012.jedn_ped;

-- Liczba uczniów ogolem w bazie (na dzien badania) przy zalozeniu, ze uczen ma jedna szkole
-- sumujemy liczbe uczniow w klasach z dostepnej bazy

select sum(jednnaboddzkl_uczbrok.jednnaboddzkl_brokucz) from sio2012.jednnaboddzkl_uczbrok;

