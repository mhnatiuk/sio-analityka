drop table if exists szkoly07;
drop table if exists szkoly08;
drop table if exists szkoly09;
drop table if exists szkoly10;
drop table if exists szkoly11;

create temp table szkoly07 as 
select j.*,u.jedn_kodpoczt,substring(u.jedn_telefon from '[0-9]{7}$')::numeric as jedn_telefon, u.jedn_nazwa,
 u.jedn_ulica,u.jedn_domlokal,
m.miejscow_nazwa as miejscowosc, jedn_www , l_uczniow_1_3,l_uczniow_4_6,
g.gmina_nazwa, 
(g.wojew_idgus || g.powiat_idgus || g.gmina_idgus || g.gminatyp_id  ) as teryt7cyfr
, case when j.jednnadrz_id!=j.jedn_id then 'Tak' else 'Nie' end as w_zespole
, (case 
	when (j.jedn_id != j.jednnadrz_id and j.jedn_id != j.jednmacierz_id ) then 'Filia'
	when (j.jedn_id != j.jednnadrz_id and j.jedn_id = j.jednmacierz_id ) then 'Zespół'
	else '' end ) as "Złożoność"

	from sio2007.jedn j
		left join sio2007.jedn_uzup u on (j.jedn_id=u.jedn_id)
	
		LEFT OUTER JOIN (
		SELECT
			okl.jedn_id,
			sum(jednnaboddzkl_brokucz)
			 AS l_uczniow_1_3
			
			--count(*) AS l_rekordow,
			--sum(jednnaboddzkl_brokucz) AS sr_l_uczniow_w_oddziale 
			-- ma wartość ujemną, gdy sum(okl_x.jednnaboddzkl_brokoddz) równa 0
		FROM
			sio2007.jednnaboddzkl_uczbrok okl
			JOIN sio2007.jednnaboddz o ON okl.jednnaboddz_id=o.jednnaboddz_id
			JOIN sio2007.sklasa k ON okl.klasa_id=k.klasa_id
		WHERE
			okl.klasa_id in ('004','005','006')
			AND o.specoddzpodst_id IN ('001')
		GROUP BY
			1
		
			
	) AS klasy1_3 ON j.jedn_id=klasy1_3.jedn_id

	LEFT OUTER JOIN (
		SELECT
			okl.jedn_id,
			sum(jednnaboddzkl_brokucz)
			 AS l_uczniow_4_6
			
			--count(*) AS l_rekordow,
			--sum(jednnaboddzkl_brokucz) AS sr_l_uczniow_w_oddziale 
			-- ma wartość ujemną, gdy sum(okl_x.jednnaboddzkl_brokoddz) równa 0
		FROM
			sio2007.jednnaboddzkl_uczbrok okl
			JOIN sio2007.jednnaboddz o ON okl.jednnaboddz_id=o.jednnaboddz_id
			JOIN sio2007.sklasa k ON okl.klasa_id=k.klasa_id
		WHERE
			okl.klasa_id in ('007','008','009')
			AND o.specoddzpodst_id IN ('001')
		GROUP BY
			1
			
	) AS klasy4_6 ON j.jedn_id=klasy4_6.jedn_id
	
		left join sio2007.sMiejscow m on (m.miejscow_id=j.miejscow_id)
		left join sio2007.sGmina g on (m.gmina_id=g.gmina_id)
		
	where typjedn_id='00003'
	--AND j.jednnadrz_id[=/<>]j.jedn_id -- PYTANIE 3.2
	--AND j.organprow_id IN ('0001')
	
	AND j.kategucz_id IN ('001')
	AND j.specszk_id IN ('100')
	AND j.zwiazanie_id IN ('0100');

create temp table szkoly08 as 
select j.*,u.jedn_kodpoczt,substring(u.jedn_telefon from '[0-9]{7}$')::numeric as jedn_telefon, u.jedn_nazwa, 
u.jedn_ulica,u.jedn_domlokal,m.miejscow_nazwa as miejscowosc, jedn_www , l_uczniow_1_3,l_uczniow_4_6,
	g.gmina_nazwa, (g.wojew_idgus || g.powiat_idgus || g.gmina_idgus || g.gminatyp_id  ) as teryt7cyfr
	, (case 
	when (j.jedn_id != j.jednnadrz_id and j.jedn_id != j.jednmacierz_id ) then 'Filia'
	when (j.jedn_id != j.jednnadrz_id and j.jedn_id = j.jednmacierz_id ) then 'Zespół'
	else '' end ) as "Złożoność"
	from sio2008.jedn j
		left join sio2008.jedn_uzup u on (j.jedn_id=u.jedn_id)
			LEFT OUTER JOIN (
		SELECT
			okl.jedn_id,
			sum(jednnaboddzkl_brokucz)
			 AS l_uczniow_1_3
			
			--count(*) AS l_rekordow,
			--sum(jednnaboddzkl_brokucz) AS sr_l_uczniow_w_oddziale 
			-- ma wartość ujemną, gdy sum(okl_x.jednnaboddzkl_brokoddz) równa 0
		FROM
			sio2008.jednnaboddzkl_uczbrok okl
			JOIN sio2008.jednnaboddz o ON okl.jednnaboddz_id=o.jednnaboddz_id
			JOIN sio2008.sklasa k ON okl.klasa_id=k.klasa_id
		WHERE
			okl.klasa_id in ('004','005','006')
			AND o.specoddzpodst_id IN ('001')
		GROUP BY
			1
		
			
	) AS klasy1_3 ON j.jedn_id=klasy1_3.jedn_id

	LEFT OUTER JOIN (
		SELECT
			okl.jedn_id,
			sum(jednnaboddzkl_brokucz)
			 AS l_uczniow_4_6
			
			--count(*) AS l_rekordow,
			--sum(jednnaboddzkl_brokucz) AS sr_l_uczniow_w_oddziale 
			-- ma wartość ujemną, gdy sum(okl_x.jednnaboddzkl_brokoddz) równa 0
		FROM
			sio2008.jednnaboddzkl_uczbrok okl
			JOIN sio2008.jednnaboddz o ON okl.jednnaboddz_id=o.jednnaboddz_id
			JOIN sio2008.sklasa k ON okl.klasa_id=k.klasa_id
		WHERE
			okl.klasa_id in ('007','008','009')
			AND o.specoddzpodst_id IN ('001')
		GROUP BY
			1
		
			
	) AS klasy4_6 ON j.jedn_id=klasy4_6.jedn_id
	
		left join sio2008.sMiejscow m on (m.miejscow_id=j.miejscow_id)
		left join sio2008.sGmina g on (m.gmina_id=g.gmina_id)
		
	where typjedn_id='00003'
		--AND j.jednnadrz_id[=/<>]j.jedn_id -- PYTANIE 3.2
	--AND j.organprow_id IN ('0001')
	
	AND j.kategucz_id IN ('001')
	AND j.specszk_id IN ('100')
	AND j.zwiazanie_id IN ('0100');






	
create temp table szkoly09 as
select j.*,u.jedn_kodpoczt,substring(u.jedn_telefon from '[0-9]{7}$')::numeric as jedn_telefon, u.jedn_nazwa,
 u.jedn_ulica,u.jedn_domlokal,m.miejscow_nazwa as miejscowosc, jedn_www , l_uczniow_1_3,l_uczniow_4_6,
		g.gmina_nazwa, (g.wojew_idgus || g.powiat_idgus || g.gmina_idgus || g.gminatyp_id  ) as teryt7cyfr
	, (case 
	when (j.jedn_id != j.jednnadrz_id and j.jedn_id != j.jednmacierz_id ) then 'Filia'
	when (j.jedn_id != j.jednnadrz_id and j.jedn_id = j.jednmacierz_id ) then 'Zespół'
	else '' end ) as "Złożoność"
	
	from sio2009.jedn j 
		left join sio2009.jedn_uzup u on (j.jedn_id=u.jedn_id)
			LEFT OUTER JOIN (
		SELECT
			okl.jedn_id,
			sum(jednnaboddzkl_brokucz)
			 AS l_uczniow_1_3
			
			--count(*) AS l_rekordow,
			--sum(jednnaboddzkl_brokucz) AS sr_l_uczniow_w_oddziale 
			-- ma wartość ujemną, gdy sum(okl_x.jednnaboddzkl_brokoddz) równa 0
		FROM
			sio2009.jednnaboddzkl_uczbrok okl
			JOIN sio2009.jednnaboddz o ON okl.jednnaboddz_id=o.jednnaboddz_id
			JOIN sio2009.sklasa k ON okl.klasa_id=k.klasa_id
		WHERE
			okl.klasa_id in ('004','005','006')
			AND o.specoddzpodst_id IN ('001')
		GROUP BY
			1
		
			
	) AS klasy1_3 ON j.jedn_id=klasy1_3.jedn_id

	LEFT OUTER JOIN (
		SELECT
			okl.jedn_id,
			sum(jednnaboddzkl_brokucz)
			 AS l_uczniow_4_6
			
			--count(*) AS l_rekordow,
			--sum(jednnaboddzkl_brokucz) AS sr_l_uczniow_w_oddziale 
			-- ma wartość ujemną, gdy sum(okl_x.jednnaboddzkl_brokoddz) równa 0
		FROM
			sio2009.jednnaboddzkl_uczbrok okl
			JOIN sio2009.jednnaboddz o ON okl.jednnaboddz_id=o.jednnaboddz_id
			JOIN sio2009.sklasa k ON okl.klasa_id=k.klasa_id
		WHERE
			okl.klasa_id in ('007','008','009')
			AND o.specoddzpodst_id IN ('001')
		GROUP BY
			1
		
			
	) AS klasy4_6 ON j.jedn_id=klasy4_6.jedn_id
	
		left join sio2009.sMiejscow m on (m.miejscow_id=j.miejscow_id)
		left join sio2009.sGmina g on (m.gmina_id=g.gmina_id)
	where typjedn_id='00003'
		--AND j.jednnadrz_id[=/<>]j.jedn_id -- PYTANIE 3.2
	--AND j.organprow_id IN ('0001')
	
	AND j.kategucz_id IN ('001')
	AND j.specszk_id IN ('100')
	AND j.zwiazanie_id IN ('0100');

	
create temp table szkoly10 as 
select j.*,u.jedn_kodpoczt,substring(u.jedn_telefon from '[0-9]{7}$')::numeric as jedn_telefon,
 u.jedn_nazwa, u.jedn_ulica,u.jedn_domlokal,
m.miejscow_nazwa as miejscowosc, jedn_www,  l_uczniow_1_3,l_uczniow_4_6,
	g.gmina_nazwa, (g.wojew_idgus || g.powiat_idgus || g.gmina_idgus || g.gminatyp_id  ) as teryt7cyfr
	, (case 
	when (j.jedn_id != j.jednnadrz_id and j.jedn_id != j.jednmacierz_id ) then 'Filia'
	when (j.jedn_id != j.jednnadrz_id and j.jedn_id = j.jednmacierz_id ) then 'Zespół'
	else '' end ) as "Złożoność"
	
	from sio2010.jedn j 
		left join sio2010.jedn_uzup u on (j.jedn_id=u.jedn_id)


		LEFT OUTER JOIN (
		SELECT
			okl.jedn_id,
			sum(jednnaboddzkl_brokucz)
			 AS l_uczniow_1_3
			
			--count(*) AS l_rekordow,
			--sum(jednnaboddzkl_brokucz) AS sr_l_uczniow_w_oddziale 
			-- ma wartość ujemną, gdy sum(okl_x.jednnaboddzkl_brokoddz) równa 0
		FROM
			sio2010.jednnaboddzkl_uczbrok okl
			JOIN sio2010.jednnaboddz o ON okl.jednnaboddz_id=o.jednnaboddz_id
			JOIN sio2010.sklasa k ON okl.klasa_id=k.klasa_id
		WHERE
			okl.klasa_id in ('004','005','006')
			AND o.specoddzpodst_id IN ('001')
		GROUP BY
			1
		
			
	) AS klasy1_3 ON j.jedn_id=klasy1_3.jedn_id

	LEFT OUTER JOIN (
		SELECT
			okl.jedn_id,
			sum(jednnaboddzkl_brokucz)
			 AS l_uczniow_4_6
			
			--count(*) AS l_rekordow,
			--sum(jednnaboddzkl_brokucz) AS sr_l_uczniow_w_oddziale 
			-- ma wartość ujemną, gdy sum(okl_x.jednnaboddzkl_brokoddz) równa 0
		FROM
			sio2010.jednnaboddzkl_uczbrok okl
			JOIN sio2010.jednnaboddz o ON okl.jednnaboddz_id=o.jednnaboddz_id
			JOIN sio2010.sklasa k ON okl.klasa_id=k.klasa_id
		WHERE
			okl.klasa_id in ('007','008','009')
			AND o.specoddzpodst_id IN ('001')
		GROUP BY
			1
		
	) AS klasy4_6 ON j.jedn_id=klasy4_6.jedn_id
	
		left join sio2010.sMiejscow m on (m.miejscow_id=j.miejscow_id)
		left join sio2010.sGmina g on (m.gmina_id=g.gmina_id)
	where typjedn_id='00003'
		--AND j.jednnadrz_id[=/<>]j.jedn_id -- PYTANIE 3.2
	--AND j.organprow_id IN ('0001')
	
	AND j.kategucz_id IN ('001')
	AND j.specszk_id IN ('100')
	AND j.zwiazanie_id IN ('0100');



	
create temp table szkoly11 as 
select j.*,u.jedn_kodpoczt,substring(u.jedn_telefon from '[0-9]{7}$')::numeric as jedn_telefon, u.jedn_nazwa, 
u.jedn_ulica,u.jedn_domlokal,m.miejscow_nazwa as miejscowosc, jedn_www,  l_uczniow_1_3,l_uczniow_4_6,
g.gmina_nazwa, (g.wojew_idgus || g.powiat_idgus || g.gmina_idgus || g.gminatyp_id  ) as teryt7cyfr
	, (case 
	when (j.jedn_id != j.jednnadrz_id and j.jedn_id != j.jednmacierz_id ) then 'Filia'
	when (j.jedn_id != j.jednnadrz_id and j.jedn_id = j.jednmacierz_id ) then 'Zespół'
	else '' end ) as "Złożoność"
	
	from sio2011.jedn j 
		left join sio2011.jedn_uzup u on (j.jedn_id=u.jedn_id)
			LEFT OUTER JOIN (
		SELECT
			okl.jedn_id,
			sum(jednnaboddzkl_brokucz)
			 AS l_uczniow_1_3
			
			--count(*) AS l_rekordow,
			--sum(jednnaboddzkl_brokucz) AS sr_l_uczniow_w_oddziale 
			-- ma wartość ujemną, gdy sum(okl_x.jednnaboddzkl_brokoddz) równa 0
		FROM
			sio2011.jednnaboddzkl_uczbrok okl
			JOIN sio2011.jednnaboddz o ON okl.jednnaboddz_id=o.jednnaboddz_id
			JOIN sio2011.sklasa k ON okl.klasa_id=k.klasa_id
		WHERE
			okl.klasa_id in ('004','005','006')
			AND o.specoddzpodst_id IN ('001')
		GROUP BY
			1
		
			
	) AS klasy1_3 ON j.jedn_id=klasy1_3.jedn_id

	LEFT OUTER JOIN (
		SELECT
			okl.jedn_id,
			sum(jednnaboddzkl_brokucz)
			 AS l_uczniow_4_6
			
			--count(*) AS l_rekordow,
			--sum(jednnaboddzkl_brokucz) AS sr_l_uczniow_w_oddziale 
			-- ma wartość ujemną, gdy sum(okl_x.jednnaboddzkl_brokoddz) równa 0
		FROM
			sio2011.jednnaboddzkl_uczbrok okl
			JOIN sio2011.jednnaboddz o ON okl.jednnaboddz_id=o.jednnaboddz_id
			JOIN sio2011.sklasa k ON okl.klasa_id=k.klasa_id
		WHERE
			okl.klasa_id in ('007','008','009')
			AND o.specoddzpodst_id IN ('001')
		GROUP BY
			1
		
			
	) AS klasy4_6 ON j.jedn_id=klasy4_6.jedn_id
	
		left join sio2011.sMiejscow m on (m.miejscow_id=j.miejscow_id)
		left join sio2011.sGmina g on (m.gmina_id=g.gmina_id)
	where typjedn_id='00003'
		--AND j.jednnadrz_id[=/<>]j.jedn_id -- PYTANIE 3.2
	--AND j.organprow_id IN ('0001')
	
	AND j.kategucz_id IN ('001')
	AND j.specszk_id IN ('100')
	AND j.zwiazanie_id IN ('0100');

---------------------------------------------
--------------------------
CREATE INDEX temp07_jedn_identyfikator_idx
   ON szkoly07 (jedn_identyfikator ASC NULLS LAST);

CREATE INDEX temp08_jedn_identyfikatoridx
   ON szkoly08 (jedn_identyfikator  ASC NULLS LAST);

CREATE INDEX temp09_jedn_identyfikator_idx
   ON szkoly09 (jedn_identyfikator  ASC NULLS LAST);

CREATE INDEX temp10_jedn_identyfikator_idx
   ON szkoly10 (jedn_identyfikator  ASC NULLS LAST);

CREATE INDEX temp11_jedn_identyfikator_idx
   ON szkoly11 (jedn_identyfikator ASC NULLS LAST);
---------------------------------------------

CREATE INDEX temp07_jedn_telefon_kod_idx
   ON szkoly07 (jedn_kodpoczt ASC NULLS LAST,jedn_telefon ASC NULLS LAST);

CREATE INDEX temp08_jedn_telefon_kod_idx
   ON szkoly08 (jedn_kodpoczt ASC NULLS LAST,jedn_telefon ASC NULLS LAST);

CREATE INDEX temp09_jedn_telefon_kod_idx
   ON szkoly09 (jedn_kodpoczt ASC NULLS LAST, jedn_telefon ASC NULLS LAST);

CREATE INDEX temp10_jedn_telefon_kod_idx
   ON szkoly10 (jedn_kodpoczt ASC NULLS LAST, jedn_telefon ASC NULLS LAST);

CREATE INDEX temp11_jedn_telefon_kod_idx
   ON szkoly11 (jedn_kodpoczt ASC NULLS LAST, jedn_telefon ASC NULLS LAST);
-------------------------------------


select 
j07.teryt7cyfr as "Tertyt 2007 7 cyfr",
j07.gmina_nazwa as "Nazwa gminy 2007",
(j07.jedn_ulica || j07.jedn_domlokal) as "Ulica 2007",
j07.jedn_kodpoczt as "Kod 2007",
j07.miejscowosc as "Miejscowosc 2007",
j07.jedn_www as "WWW 2007",
j07.jedn_telefon as "Telefon 2007",

j11.teryt7cyfr as "Tertyt 2011 7 cyfr",
j11.gmina_nazwa as "Nazwa gminy 2011",
(j11.jedn_ulica || j11.jedn_domlokal) as "Ulica 2011",
j11.jedn_kodpoczt as "Kod 2011",
j11.miejscowosc as "Miejscowosc 2011",
j11.jedn_www as "WWW 2011",
j11.jedn_telefon as "Telefon 2011",

j07.jedn_nazwa as "nazwa07",
j08.jedn_nazwa as "nazwa08",
 j09.jedn_nazwa as "nazwa09", 
 j10.jedn_nazwa as "nazwa10", 
 j11.jedn_nazwa as "nazwa11", 
j07.jedn_id::text as "sio_id_07",
j08.jedn_id::text as "sio_id_08",
j09.jedn_id::text as "sio_id_09",
j10.jedn_id::text as "sio_id_10",
j11.jedn_id::text as "sio_id_11",
j07.OrganProw_Id::text as "organ.prowadzacy.07",
j08.OrganProw_Id::text as "organ.prowadzacy.08",
j09.OrganProw_Id::text as "organ.prowadzacy.09",
j10.OrganProw_Id::text as "organ.prowadzacy.10",
j11.OrganProw_Id::text as "organ.prowadzacy.11",
j07.jedn_regon::text as "regon07", j08.jedn_regon::text as "regon08",
 j09.jedn_regon::text as "regon09", 
j10.jedn_regon::text as "regon10", j11.jedn_regon::text as "regon11",
j07.l_uczniow_1_3 as "lba_uczniow_I_III_2007", 
j08.l_uczniow_1_3 as "lba_uczniow_I_III_2008",
j09.l_uczniow_1_3 as "lba_uczniow_I_III_2009",
j10.l_uczniow_1_3 as "lba_uczniow_I_III_2010",
j11.l_uczniow_1_3 as "lba_uczniow_I_III_2011",

j07.l_uczniow_4_6 as "lba_uczniow_IV_VI_2007", 
j08.l_uczniow_4_6 as "lba_uczniow_IV_VI_08",
j09.l_uczniow_4_6 as "lba_uczniow_IV_VI_09",
j10.l_uczniow_4_6 as "lba_uczniow_IV_VI_10",
j11.l_uczniow_4_6 as "lba_uczniow_IV_VI_11",

j07."Złożoność" as "Złożoność 2007",
j08."Złożoność" as "Złożoność 2008",
j09."Złożoność" as "Złożoność 2009",
j10."Złożoność" as "Złożoność 2010",
j11."Złożoność" as "Złożoność 2011",

j07.publiczn_id as "Publiczna (001) 2007",
j08.publiczn_id as "Publiczna (001) 2008",
j09.publiczn_id as "Publiczna (001) 2009",
j10.publiczn_id as "Publiczna (001) 2010",
j11.publiczn_id as "Publiczna (001) 2011",


(case when j07.OrganProw_Id='0001' and j08.OrganProw_Id='0022' then 1 else 0 end) as "Przejeta07-08",
(case when j08.OrganProw_Id='0001' and j09.OrganProw_Id='0022' then 1 else 0 end) as "Przejeta08-09",
(case when j09.OrganProw_Id='0001' and j10.OrganProw_Id='0022' then 1 else 0 end) as "Przejeta09-10",
(case when j10.OrganProw_Id='0001' and j11.OrganProw_Id='0022' then 1 else 0 end) as "Przejeta10-11"

from szkoly11 as j11


left outer join 
		szkoly10
		 as j10 on (j10.jedn_identyfikator=j11.jedn_identyfikator or ( (j10.teryt7cyfr=j11.teryt7cyfr) and (j10.jedn_kodpoczt=j11.jedn_kodpoczt) and (j10.jedn_telefon=j11.jedn_telefon) ) )
		
left outer join 
		szkoly09
		as j09 on (j09.jedn_identyfikator=j10.jedn_identyfikator or ( (j09.teryt7cyfr=j10.teryt7cyfr) and (j09.jedn_kodpoczt=j10.jedn_kodpoczt) and (j09.jedn_telefon=j10.jedn_telefon) ) )
left outer join 
		szkoly08
		as j08 on (j09.jedn_identyfikator=j08.jedn_identyfikator or ( (j09.teryt7cyfr=j08.teryt7cyfr) and (j09.jedn_kodpoczt=j08.jedn_kodpoczt) and (j09.jedn_telefon=j08.jedn_telefon) ) )
left outer join 
		szkoly07
		as j07 on (j07.jedn_identyfikator=j08.jedn_identyfikator or ( (j07.teryt7cyfr=j08.teryt7cyfr) and (j07.jedn_kodpoczt=j08.jedn_kodpoczt) and (j07.jedn_telefon=j08.jedn_telefon) ) )
--where 
--(j11.typjedn_id = '00003' or j10.typjedn_id = '00003' or j09.typjedn_id = '00003' or j08.typjedn_id = '00003' or j07.typjedn_id = '00003')



