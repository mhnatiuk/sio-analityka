set search_path TO 'sio2007'; -- ustaw domyslny schemat na sio2012 
--drop table if exists szkoly;
-- explain : sprawdzanie optymalności selecta przed zadaniem skomplikowanego zapytania



select 
(g.wojew_idgus || g.powiat_idgus || g.gmina_idgus || g.gminatyp_id  ) as "Teryt 7 cyfr", -- '||' : łączenie tekstów
g.gmina_nazwa as "Nazwa gminy", 
(u.jedn_ulica || u.jedn_domlokal) as "Ulica",
u.jedn_kodpoczt as "KodPcz",
m.miejscow_nazwa as "Miejscowosc",
u.jedn_www as "www",
u.jedn_telefon as "Telefon",
j.jedn_id as "jedn_id",
jedn_identyfikator as "Identyfikator",
jedn_nazwa as "Nazwa",
OrganProw_Id::text as "organ.prowadzacy", -- '::text / ::integer / ::float' : przekształca cokolwiek na tekst/liczbe całk./liczbę zmiennoprzecinkową
jedn_regon::text,
l_uczniow_1_3,
l_uczniow_4_6,
 (case 
	when (j.jedn_id != j.jednnadrz_id and j.jedn_id != j.jednmacierz_id ) then 'Filia'
	when (j.jedn_id != j.jednnadrz_id and j.jedn_id = j.jednmacierz_id ) then 'Zespół'
	else '' end ) as "Złożoność", -- 'wielokrotny if'
j.publiczn_id as "Publiczna (001)"

, j.kategucz_id as "Kategoria uczniow:dzieci/dorosli"
, j.specszk_id as "Specjalnosc?" -- czy szkola specjalna '100': niespecjalna '001': specjalna
, j.zwiazanie_id as "Zwiazanie" -- związanie z instytucja typu więzienie, szpital


	from jedn j
		left outer join jedn_uzup u on (j.jedn_id=u.jedn_id)
	
		LEFT OUTER JOIN (
		        SELECT
			        okl.jedn_id,
			        sum(jednnaboddzkl_brokucz)
			         AS l_uczniow_1_3
			
		        FROM
			        jednnaboddzkl_uczbrok okl -- tabela zawiera dane o uczniach w oddziałach w bieżącym roku
			        JOIN jednnaboddz o ON okl.jednnaboddz_id=o.jednnaboddz_id
			        JOIN sklasa k ON okl.klasa_id=k.klasa_id
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
			jednnaboddzkl_uczbrok okl
			JOIN jednnaboddz o ON okl.jednnaboddz_id=o.jednnaboddz_id
			JOIN sklasa k ON okl.klasa_id=k.klasa_id
		WHERE
			okl.klasa_id in ('007','008','009')
			AND o.specoddzpodst_id IN ('001')
		GROUP BY
			1
			
	) AS klasy4_6 ON j.jedn_id=klasy4_6.jedn_id
	
		left outer join sMiejscow m on (m.miejscow_id=j.miejscow_id)
		left outer join sGmina g on (m.gmina_id=g.gmina_id)
		
	where typjedn_id='00004'
	--AND j.jednnadrz_id[=/<>]j.jedn_id -- PYTANIE 3.2
	--AND j.organprow_id IN ('0001')
	
	--AND j.kategucz_id IN ('001')
	--AND j.specszk_id IN ('100')
	--AND j.zwiazanie_id IN ('0100') 


