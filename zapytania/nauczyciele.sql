-- ZAPYTANIA DOTYCZACE NAUCZYCIELI

-- stopnie awansu zawodowego nauczycieli (nazwy i symbole)

select awanssto_nazwa, awanssto_id from sio2012.sawanssto;

-- liczba nauczycieli w poszczegolnych stopniach awansu zawodowego

select count(distinct pedag_pesel), awanssto_id  from sio2012.jedn_ped group by awanssto_id

-- stopien awansu zawodowego, ktory posiada najwieksza liczba nauczycieli + liczba nauczycieli posiadajaca ten stopien (jedna kwerenda)

select query1.*
from (select count(distinct pedag_pesel) as licznik, awanssto_id from sio2012.jedn_ped group by awanssto_id) query1,
(select max(query2.licznik) as maksimum
from (select count(distinct pedag_pesel) as licznik, awanssto_id from sio2012.jedn_ped group by awanssto_id) query2) query3
where query1.licznik=query3.maksimum;

--nazwa stopnia awansu zawodowego, jaki posiada najwieksza liczba nauczycieli

select awanssto_nazwa from sio2012.sawanssto where sawanssto.awanssto_id=(select query1.awanssto_id                                                                                                         from (select count(distinct pedag_pesel) as licznik, awanssto_id from sio2012.jedn_ped group by awanssto_id) query1,                            
(select max(query2.licznik) as maksimum
from (select count(distinct pedag_pesel) as licznik, awanssto_id from sio2012.jedn_ped group by awanssto_id) query2) query3
where query1.licznik=query3.maksimum);

-- w ilu srednio placowkach zatrudnieni byli nauczyciele
select avg(liczba_plac) from (select pedag_pesel, count(jedn_id) as liczba_plac from sio2012.jedn_ped group by jedn_ped.pedag_pesel) pomocnicza;

--srednia liczba nauczycieli w placowkach
select avg(liczba_naucz) from (select jedn_id, count(pedag_pesel) as liczba_naucz from sio2012.jedn_ped group by jedn_id) pomocnicza;

--liczba nauczycieli w poszczegolnych typach placowek
select typjedn_id, count(pedag_pesel) from sio2012.jedn, sio2012.jedn_ped where jedn_ped.jedn_id=jedn.jedn_id group by typjedn_id;

-- kwerendy dzialajace, ale niezbyt piekne...
-- Widok: pesel nauczyciela + liczba jednostek, w ktorych jest zatrudniony

create view jednostki as select count(jedn_id), pedag_pesel from sio2012.jedn_ped group by jedn_ped.pedag_pesel;

--W ilu najwiecej placowkach zatrudniony byl nauczyciel rekordzista?

select max(count) from jednostki;

--Znalezienie nauczyciela, ktory byl zatrudniony w najwiekszej liczbie placowek (malo przydatne, ale mozna, raczej jako element innych zapytan)

select pesel_id from jednostki where jednostki.count=max(count);

--Znalezienie stopnia awansu zawodowego nauczyciela rekordzisty

select distinct awanssto_id from sio2012.jedn_ped, jednostki where jedn_ped.pedag_pesel=jednostki.pedag_pesel and jednostki1.count=(select max(count) from jednostki);

--Znalezienie pelnej nazwy tego stopnia (oczywiscie majac poprzednie zapytanie mozemy wpisac jego wynik w '')

select awanssto_nazwa from sio2012.sawanssto where anwanssto_id = (select distinct awanssto_id from sio2012.jedn_ped, jednostki where jedn_ped.pedag_pesel=jednostki.pedag_pesel and jednostki1.count=(select max(count) from jednostki));

--Znalezienie id szkol w ktorych byl zatrudniony nauczyciel rekordzista

select jedn_id from sio2012.jedn_ped, jednostki where jedn_ped.pedag_pesel=jednostki.pedag_pesel and jednostki.count= (select max(count) from jednostki);

--znalezienie wojewodztw, w ktorych byly szkoly, w ktorych zatrudniono nauczyciela rekordziste (distinct zwroci bez duplikatow)

select distinct jedn.wojew_id from sio2012.jedn where jedn_id in (select jedn_id from sio2012.jedn_ped, jednostki where jedn_ped.pedag_pesel=jednostki.pedag_pesel and jednostki.count= (select max(count) from jednostki));

--i spotyka nas rozczarowanie, bo te wojewodztwa to whitespace.
--ale baza nie zawiera brakow

select count(*) from sio2012.jedn where not exists (select jedn.wojew_id from sio2012.jedn);

--znalezienie wojewodztw, pod ktore podlegaja szkoly, w ktorych zatrudniony jest nauczyciel rekordzista (opcja distinct gwarantuje brak duplikatow)

select distinct organprowwojew_id from sio2012.jedn where jedn.jedn_id in (select jedn_id from sio2012.jedn_ped, jednostki where jedn_ped.pedag_pesel=jednostki.pedag_pesel and jednostki.count= (select max(count) from jednostki));

--znalezienie nazw tych wojewodztw (oczywiscie mozna posluzyc sie wynikami poprzedniego zapytania w '')

Select wojew_nazwa from sio2012.swojew where wojew_id in (select distinct organprowwojew_id from sio2012.jedn where jedn.jedn_id in (select jedn_id from sio2012.jedn_ped, jednostki where jedn_ped.pedag_pesel=jednostki.pedag_pesel and jednostki.count= (select max(count) from jednostki)));

