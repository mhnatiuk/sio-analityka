--ZAPYTANIA DOTYCZACE LICZBY UCZNIOW I SZKOL

--liczba uczniow w poszczegolnych jednostkach na dzien badania

select jedn_id, sum(jednnaboddzkl_brokucz) from sio2012.jednnaboddzkl_uczbrok group by jedn_id;

--Znajdz szkoly, w ktorych na dzien badania bylo mniej uczniow niz na koniec poprzedniego roku

create view uczniowie1 as select jednnaboddzkl_uczbrok.jedn_id, sum(jednnaboddzkl_brokucz) as brok, sum(jednnaboddzkl_prokucz) as prok from sio2012.jednnaboddzkl_uczbrok, sio2012.jednnaboddzkl_uczprok where jednnaboddzkl_uczbrok.jedn_id=jednnaboddzkl_uczprok.jedn_id group by jednnaboddzkl_uczbrok.jedn_id;

select jedn_id from uczniowie1 where prok>brok;

-- i ile bylo takich szkol?

select count(jedn_id) from uczniowie1 where prok>brok;

