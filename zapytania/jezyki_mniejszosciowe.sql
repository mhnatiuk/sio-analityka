--W ilu szkolach uczono jezykow mniejszosciowych
select count(distinct jedn_id) from sio2012.jednnabjmnkl;

--jakich jezykow mniejszosciowych uczono i w ilu szkolach?
select jezmn_nazwa, count(distinct jedn_id) from sio2012.jednnabjmnkl, sio2012.sjezmn where sjezmn.jezmn_id=jednnabjmnkl.jezmn_id group by sjezmn.jezmn_id, jednnabjmnkl.jezmn_id;

--ilu jezykow mniejszosciowych uczono w poszczegolnych jednostkach?
select jedn_id, count(distinct jezmn_id) from sio2012.jednnabjmnkl group by jedn_id;

--ilu najwiecej uczono jezykow mniejszosciowych i w ktorych placowkach?
select query1.*
from (select count(distinct jezmn_id) as liczba_jez, jedn_id from sio2012.jednnabjmnkl group by jedn_id) query1,
(select max(query2.liczba_jez) as maksimum from (select count(distinct jezmn_id) as liczba_jez, jedn_id from sio2012.jednnabjmnkl group by jedn_id) query2) query3
where query1.liczba_jez=query3.maksimum;

--ilu srednio jezykow mniejszosciowych uczono w szkolach?
select avg(liczba_jez) from
(select count(distinct jezmn_id) as liczba_jez, jedn_id from sio2012.jednnabjmnkl group by jedn_id) pomocnicza;

--W ilu szkolach uczono jezykow mniejszosciowych (i jakich), ale braly w tym udzial osoby tylko spoza tych szkol

select jezmn_nazwa, count(distinct jedn_id) from sio2012.jednnabjmnkl, sio2012.sjezmn where jednnabjmnkl_uczbrokzeszkoly=0 and jednnabjmnkl_uczbrokspozaszk!=0 and sjezmn.jezmn_id=jednnabjmnkl.jezmn_id group by jednnabjmnkl.jezmn_id, sjezmn.jezmn_id;
