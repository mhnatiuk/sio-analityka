-- ZAPYTANIA, KTORYCH KATEGORIE TRUDNO OKRESLIC

--srednia liczba uczniow uczestniczacych w placowce w zajeciach przygotowanie do zycia w rodzinie 
select avg(uczniowie_zyc) from (select sum(jednkl_zycrodzog) as uczniowie_zyc, jedn_id from sio2012.jednklasa_ucz group by jedn_id) q;

--srednia liczba klas, w ktorych prowadzono przedmiot przygotowanie do zycia w rodzinie/placowke
select avg(klasa_zyc) from (select count(klasa_id) as klasa_zyc, jedn_id from sio2012.jednklasa_ucz group by jedn_id) q;


