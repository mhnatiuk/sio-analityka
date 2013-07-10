--ZAPYTANIA DOTYCZACE LICZBY UCZNIOW I SZKOL

--liczba uczniow w poszczegolnych jednostkach na dzien badania

select jedn_id, sum(jednnaboddzkl_brokucz) from sio2012.jednnaboddzkl_uczbrok group by jedn_id;

-- srednia liczba uczniow
select jedn_id, sum(jednnaboddzkl_brokucz) from sio2012.jednnaboddzkl_uczbrok group by jedn_id;
sio=> select avg(liczba_ucz) from (select jedn_id, sum(jednnaboddzkl_brokucz) as liczba_ucz from sio2012.jednnaboddzkl_uczbrok group by jedn_id) pomocnicza;

--liczba szkol, w ktorych bylo wiecej uczniow niz srednia z calej proby
select count (jedn_id) from sio2012.jednnaboddzkl_uczbrok having sum(jednnaboddzkl_brokucz) > (select avg(liczba_ucz) from (select jedn_id, sum(jednnaboddzkl_brokucz) as liczba_ucz from sio2012.jednnaboddzkl_uczbrok group by jedn_id) pomocnicza);

--srednia liczba osob powtarzajacych rok w placowkach
select avg(powtarzajacy) from (select sum(jednnabkl_uczbrokpowtarz) as powtarzajacy, jedn_id from sio2012.jednnabkl_uczog group by jedn_id) q;

--najwieksza liczba powtarzajacych rok uczniow w jednostce
select query1.powtarzajacy
from (select sum(jednnabkl_uczbrokpowtarz) as powtarzajacy, jedn_id from sio2012.jednnabkl_uczog group by jedn_id) query1,
(select max(powtarzajacy) as maksimum from (select sum(jednnabkl_uczbrokpowtarz) as powtarzajacy, jedn_id from sio2012.jednnabkl_uczog group by jedn_id) query2) query3 where query1.powtarzajacy=query3.maksimum; i

--najwieksza liczba indywidualnie nauczanych w placowce
select query1.ind
from (select sum(jednnabkl_uczbrokindywnau) as ind, jedn_id from sio2012.jednnabkl_uczog group by jedn_id) query1,
(select max(ind) as maksimum from (select sum(jednnabkl_uczbrokindywnau) as ind, jedn_id from sio2012.jednnabkl_uczog group by jedn_id) query2) query3 where query1.ind=query3.maksimum;

--Znajdz szkoly, w ktorych na dzien badania bylo mniej uczniow niz na koniec poprzedniego roku

create view uczniowie1 as select jednnaboddzkl_uczbrok.jedn_id, sum(jednnaboddzkl_brokucz) as brok, sum(jednnaboddzkl_prokucz) as prok from sio2012.jednnaboddzkl_uczbrok, sio2012.jednnaboddzkl_uczprok where jednnaboddzkl_uczbrok.jedn_id=jednnaboddzkl_uczprok.jedn_id group by jednnaboddzkl_uczbrok.jedn_id;

select jedn_id from uczniowie1 where prok>brok;

-- i ile bylo takich szkol?

select count(jedn_id) from uczniowie1 where prok>brok;

--liczba uczniow z obwodu uczacych sie w jednostkach
select jedn_id, jednobszk_uczog from sio2012.jednobszk where obszk_id='001';

--liczba uczniow z obwodu uczacych sie w jednostkach z Warszawy
select jedn.jedn_id, jednobszk_uczog from sio2012.jednobszk, sio2012.jedn where obszk_id='001' and jedn.jedn_id=jednobszk.jedn_id and jedn.miejscow_id=(select miejscow_id from sio2012.smiejscow where miejscow_nazwa='Warszawa');

--liczba uczniow z obwodu uczacych sie szkolach podstawowych w Warszawie
select jedn.jedn_id, jednobszk_uczog from sio2012.jednobszk, sio2012.jedn where obszk_id='001' and jedn.jedn_id=jednobszk.jedn_id and jedn.miejscow_id=(select miejscow_id from sio2012.smiejscow where miejscow_nazwa='Warszawa') and jedn.typjedn_id=(select typjedn_id from sio2012.stypjedn where typjedn_nazwa~'Szkoła podstawowa');

--liczba uczniow w podstawowkach warszawskich, ktorych szkoly realizuja obowiazek szkolny "inne szkoly"
select jedn.jedn_id, jednobszk_uczog from sio2012.jednobszk, sio2012.jedn where obszk_id='002' and jedn.jedn_id=jednobszk.jedn_id and jedn.miejscow_id=(select miejscow_id from sio2012.smiejscow where miejscow_nazwa='Warszawa') and jedn.typjedn_id=(select typjedn_id from sio2012.stypjedn where typjedn_nazwa~'Szkoła podstawowa');

