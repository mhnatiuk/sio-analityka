-- ZAPYTANIA DOTYCZACE NAUCZYCIELI

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

