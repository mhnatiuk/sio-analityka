set search_path TO 'sio2012';



select 
j.jedn_id as "jedn_id",
jedn_identyfikator as "Identyfikator",
(g.wojew_idgus || g.powiat_idgus || g.gmina_idgus || g.gminatyp_id  ) as "Teryt 7 cyfr",
g.gmina_nazwa as "Nazwa gminy",
jedn_regon::text as "REGON",
jedn_nazwa as "Nazwa szkoły",
(u.jedn_ulica || u.jedn_domlokal) as "Ulica",
u.jedn_kodpoczt as "KodPcz",
m.miejscow_nazwa as "Miejscowosc",
u.jedn_telefon as "Telefon",
j.specszk_id as "Specjalna?",
j.zwiazanie_id as "Zwiazanie",
 (case 
	when (j.jedn_id != j.jednnadrz_id and j.jedn_id != j.jednmacierz_id ) then 'Filia'
	when (j.jedn_id != j.jednnadrz_id and j.jedn_id = j.jednmacierz_id ) then 'Zespół'
	else '' end ) as "Złożoność",
j.publiczn_id as "Publiczna (001)",
j.OrganProw_Id::text as "Kod organu prowądzacego",
j.organprow_nazwa as "Nazwa organu prowadzącego",
--u.jedn_www as "www",

lu."LUczniow - Klasa I",
lu."LUczniow - Klasa II",
lu."LUczniow - Klasa III",
lu."LUczniow - Klasa IV",
lu."LUczniow - Klasa V", 
lu."LUczniow - Klasa VI",
lo."L Oddzialow Klasa I", 
lo."L Oddzialow Klasa II",
lo."L Oddzialow Klasa III",
lo."L Oddzialow Klasa IV",
lo."L Oddzialow Klasa V",
lo."L Oddzialow Klasa VI", 
tablicowi.liczba,
tablicowi.liczba_godzin,
nietablicowi.liczba,
nietablicowi.liczba_godzin,

wn.JednNiepAdmLba as "Lba pracownikow ekono-admin",
wn.JednNiepAdmWymiarPracyPelnoz as "Lba pelnozatrudnionych pracownikow ekono-admin",

wn.JednNiepStoLba as "Lba pracownikow kuchni/stołówki",
wn.JednNiepStoLbaPelnoz as "Lba pelnozatrudnionych pracownikow kuchni/stołówki",

wn.JednNiepObsLba as "Lba pracownikow obsługi",
wn.JednNiepObsLbaPelnoz as "Lba pelnozatrudnionych pracownikow obsługi",
swietlica.suma as "Świetlica - lba uczniów",
pozalek.suma as "Pozalekcyjne - lba uczniów",
posilki.suma as "Posiłki - lba uczniów średnio dziennie",

(dowoz.Upraw35kmKl14 +  dowoz.Upraw45kmKl56) as "Dowóz - uprawnieni 3-5 km",
dowoz.Dowoz35kmKl14 +  dowoz.Dowoz45kmKl56 as "Dowóz - dowożeni 3-5 km",
dowoz.Upraw510kmSp  as "Dowóz: uprawnieni 5-10 km",
dowoz.Dowoz510kmSp as "Dowóz: dowożeni 5-10 km",
dowoz.Upraw10kmSp as "Dowóz: uprawnieni > 10 km",
dowoz.Dowoz10kmSp as "Dowóz: dowożeni > 10 km"



--, j.kategucz_id as "Kategoria uczniow:dzieci/dorosli"


	from jedn j
		left outer join jedn_uzup u on (j.jedn_id=u.jedn_id)
	    left outer join Sorgan so on (j.organprow_id = so.organprow_id)
		/*LEFT OUTER JOIN (
		SELECT
			okl.jedn_id,
			sum(jednnaboddzkl_brokucz)
			 AS l_uczniow_1_3
			
			--count(*) AS l_rekordow,
			--sum(jednnaboddzkl_brokucz) AS sr_l_uczniow_w_oddziale 
			-- ma wartość ujemną, gdy sum(okl_x.jednnaboddzkl_brokoddz) równa 0
		FROM
			jednnaboddzkl_uczbrok okl
			JOIN jednnaboddz o ON okl.jednnaboddz_id=o.jednnaboddz_id
			JOIN sklasa k ON okl.klasa_id=k.klasa_id
		WHERE
			okl.klasa_id in ('004','005','006')
			AND o.specoddzpodst_id IN ('001')
		GROUP BY
			1
		
			
	) AS klasy1_3 ON j.jedn_id=klasy1_3.jedn_id*/

	/*LEFT OUTER JOIN (
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
			
	) AS klasy4_6 ON j.jedn_id=klasy4_6.jedn_id*/
	
		left outer join sMiejscow m on (m.miejscow_id=j.miejscow_id)
		left outer join sGmina g on (m.gmina_id=g.gmina_id)
		

     left outer join (
                  select * FROM crosstab(
                    'select jedn_id::text, (''klasa_''||k.klasa_nazwa) as "klasa",
                    sum(jednnaboddzkl_brokucz)::integer AS l_uczniow
                   FROM 
                   jednnaboddzkl_uczbrok okl
                   left outer join sKlasa k on okl.klasa_id=k.klasa_id
                  where k.klasa_id in 
                  (''004'',''005'',''006'',''007'',''008'',''009'')
                 group by 1,2 order by 1,2'
             ) as ct (row_name text, "LUczniow - Klasa I" int, "LUczniow - Klasa II" int
		, "LUczniow - Klasa III" int,"LUczniow - Klasa IV" int,
		"LUczniow - Klasa V" int, "LUczniow - Klasa VI" int)
                                ) as lu on lu.jedn_id=j.jedn_id

    left outer join ( select * FROM crosstab(
                    'select jedn_id::text, (''klasa_''||k.klasa_nazwa) as "klasa",
                    sum(JednNabOddzKl_BRokOddz)::integer AS l_oddz
                   FROM 
                    jednnaboddzkl_uczbrok okl
                   left outer join sKlasa k on okl.klasa_id=k.klasa_id
                  where k.klasa_id in 
                  (''004'',''005'',''006'',''007'',''008'',''009'')
                 group by 1,2 order by 1,2'
             ) as ct (row_name text, "L Oddzialow Klasa I" int, "L Oddzialow Klasa II" int
		, "L Oddzialow Klasa III" int,"L Oddzialow Klasa IV" int,
		"L Oddzialow Klasa V" int, "L Oddzialow Klasa VI" int)
        ) as lo on lo.jedn_id=j.jedn_id


    left outer join (
        select ped.jedn_id,
	        count(distinct pedag_pesel) as liczba,
	        sum(JednPedZatrObow_LbaGodzLicz /JednPedZatrObow_LbaGodzMian) as liczba_godzin
	        from JednPedZatrObow zo

	        left outer join Jedn_Ped ped on (zo.pedag_id=ped.pedag_id)
	        left outer join sObowiazk ob on (ob.obowiazk_id=zo.obowiazk_id)
	
	        where ob.obowiazk_czynauczanie = -1
        	group by 1
        ) as tablicowi 

    left outer join (
         select ped.jedn_id,
	        count(distinct pedag_pesel) as liczba,
	        sum(JednPedZatrObow_LbaGodzLicz /JednPedZatrObow_LbaGodzMian) as liczba_godzin
	        from JednPedZatrObow zo

	        left outer join Jedn_Ped ped on (zo.pedag_id=ped.pedag_id)
	        left outer join sObowiazk ob on (ob.obowiazk_id=zo.obowiazk_id)
	
	        where ob.obowiazk_czynauczanie = 0
	        group by 1
        ) as nietablicowi 



    left outer join Jedn_WynNiep wn on (j.jedn_id=wn.jedn_id)
    left outer join ( select jedn_id, sum(JednNab_UczBRokDoSwietlicy) as suma FROM JednNab_Ucz group by 1  ) 
        as swietlica on (j.jedn_id=swietlica.jedn_id)
   
    left outer join (select jedn_id, sum(JednNabZajPozal_LbaUcz) as suma from JednNabZajPozal  group by 1)
         as pozalek  on (j.jedn_id=pozalek.jedn_id)
    left outer join ( select jedn_id, sum(JednPosilek_liczba) as suma from JednPosilek) 
				as posilki on (j.jedn_id=posilki.jedn_id)

    left outer join Jedn_Dowoz as dowoz on (dowoz.jedn_id = j.jedn_id)


	﻿set search_path TO 'sio2012';
drop table if exists szkoly;




select 
j.jedn_id as "jedn_id",
jedn_identyfikator as "Identyfikator",
(g.wojew_idgus || g.powiat_idgus || g.gmina_idgus || g.gminatyp_id  ) as "Teryt 7 cyfr",
g.gmina_nazwa as "Nazwa gminy",
jedn_regon::text as "REGON",
jedn_nazwa as "Nazwa szkoły",
(u.jedn_ulica || u.jedn_domlokal) as "Ulica",
u.jedn_kodpoczt as "KodPcz",
m.miejscow_nazwa as "Miejscowosc",
u.jedn_telefon as "Telefon",
j.specszk_id as "Specjalna?",
j.zwiazanie_id as "Zwiazanie",
 (case 
	when (j.jedn_id != j.jednnadrz_id and j.jedn_id != j.jednmacierz_id ) then 'Filia'
	when (j.jedn_id != j.jednnadrz_id and j.jedn_id = j.jednmacierz_id ) then 'Zespół'
	else '' end ) as "Złożoność",
j.publiczn_id as "Publiczna (001)",
j.OrganProw_Id::text as "Kod organu prowądzacego",
j.organprow_nazwa as "Nazwa organu prowadzącego",
--u.jedn_www as "www",

lu."LUczniow - Klasa I",
lu."LUczniow - Klasa II",
lu."LUczniow - Klasa III",
lu."LUczniow - Klasa IV",
lu."LUczniow - Klasa V", 
lu."LUczniow - Klasa VI"
lo."L Oddzialow Klasa I", 
lo."L Oddzialow Klasa II",
lo."L Oddzialow Klasa III",
lo."L Oddzialow Klasa IV",
lo."L Oddzialow Klasa V",
lo."L Oddzialow Klasa VI", 
tablicowi.liczba,
tablicowi.liczba_godzin,
nietablicowi.liczba,
nietablicowi.liczba_godzin,

wn.JednNiepAdmLba as "Lba pracownikow ekono-admin",
wn.JednNiepAdmWymiarPracyPelnoz as "Lba pelnozatrudnionych pracownikow ekono-admin",

wn.JednNiepStoLba as "Lba pracownikow kuchni/stołówki",
wn.JednNiepStoLbaPelnoz as "Lba pelnozatrudnionych pracownikow kuchni/stołówki",

wn.JednNiepObsLba as "Lba pracownikow obsługi",
wn.JednNiepObsLbaPelnoz as "Lba pelnozatrudnionych pracownikow obsługi",
swietlica.suma as "Świetlica - lba uczniów",
pozalek.suma as "Pozalekcyjne - lba uczniów",
posilki.suma as "Posiłki - lba uczniów średnio dziennie",

dowoz.Upraw35kmKl14 +  dowoz.Upraw45kmKl56 as "Dowóz: uprawnieni 3-5 km"
dowoz.Dowoz35kmKl14 +  dowoz.Dowoz45kmKl56 as "Dowóz: dowożeni 3-5 km"
dowoz.Upraw510kmSp  as "Dowóz: uprawnieni 5-10 km"
dowoz.Dowoz510kmSp as "Dowóz: dowożeni 5-10 km"
dowoz.Upraw10kmSp as "Dowóz: uprawnieni > 10 km"
dowoz.Dowoz10kmSp as "Dowóz: dowożeni > 10 km"



--, j.kategucz_id as "Kategoria uczniow:dzieci/dorosli"


	from jedn j
		left outer join jedn_uzup u on (j.jedn_id=u.jedn_id)
	    left outer join Sorgan so on (j.organprow_id = so.organprow_id)
		LEFT OUTER JOIN (
		SELECT
			okl.jedn_id,
			sum(jednnaboddzkl_brokucz)
			 AS l_uczniow_1_3
			
			--count(*) AS l_rekordow,
			--sum(jednnaboddzkl_brokucz) AS sr_l_uczniow_w_oddziale 
			-- ma wartość ujemną, gdy sum(okl_x.jednnaboddzkl_brokoddz) równa 0
		FROM
			jednnaboddzkl_uczbrok okl
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
		

     left outer join (
                  select * FROM crosstab(
                    'select jedn_id::text, (''klasa_''||k.klasa_nazwa) as "klasa",
                    sum(jednnaboddzkl_brokucz)::integer AS l_uczniow
                   FROM 
                   jednnaboddzkl_uczbrok okl
                   left outer join sKlasa k on okl.klasa_id=k.klasa_id
                  where k.klasa_id in 
                  (''004'',''005'',''006'',''007'',''008'',''009'')
                 group by 1,2 order by 1,2'
             ) as ct (row_name text, "LUczniow - Klasa I" int, "LUczniow - Klasa II" int
		, "LUczniow - Klasa III" int,"LUczniow - Klasa IV" int,
		"LUczniow - Klasa V" int, "LUczniow - Klasa VI" int)
                                ) as lu on lu.jedn_id=j.jedn_id

    left outer join ( select * FROM crosstab(
                    'select jedn_id::text, (''klasa_''||k.klasa_nazwa) as "klasa",
                    sum(JednNabOddzKl_BRokOddz)::integer AS l_oddz
                   FROM 
                    jednnaboddzkl_uczbrok okl
                   left outer join sKlasa k on okl.klasa_id=k.klasa_id
                  where k.klasa_id in 
                  (''004'',''005'',''006'',''007'',''008'',''009'')
                 group by 1,2 order by 1,2'
             ) as ct (row_name text, "L Oddzialow Klasa I" int, "L Oddzialow Klasa II" int
		, "L Oddzialow Klasa III" int,"L Oddzialow Klasa IV" int,
		"L Oddzialow Klasa V" int, "L Oddzialow Klasa VI" int)
        ) as lo on lo.jedn_id=j.jedn_id


    left outer join (
        select ped.jedn_id,
	        count(distinct pedag_pesel) as liczba,
	        sum(JednPedZatrObow_LbaGodzLicz /JednPedZatrObow_LbaGodzMian) as liczba_godzin
	        from JednPedZatrObow zo

	        left outer join Jedn_Ped ped on (zo.pedag_id=ped.pedag_id)
	        left outer join sObowiazk ob on (ob.obowiazk_id=zo.obowiazk_id)
	
	        where ob.obowiazk_czynauczanie = -1
        	group by 1
        ) as tablicowi 

    left outer join (
         select ped.jedn_id,
	        count(distinct pedag_pesel) as liczba,
	        sum(JednPedZatrObow_LbaGodzLicz /JednPedZatrObow_LbaGodzMian) as liczba_godzin
	        from JednPedZatrObow zo

	        left outer join Jedn_Ped ped on (zo.pedag_id=ped.pedag_id)
	        left outer join sObowiazk ob on (ob.obowiazk_id=zo.obowiazk_id)
	
	        where ob.obowiazk_czynauczanie = 0
	        group by 1
        ) as nietablicowi 



    left outer join Jedn_WynNiep wn on (j.jedn_id=wn.jedn_id)
    left outer join ( select jedn_id, sum(JednNab_UczBRokDoSwietlicy) as suma FROM JednNab_Ucz group by 1  ) 
        as swietlica on (j.jedn_id=swietlica.jedn_id)
   
    left outer join (select jedn_id, sum(JednNabZajPozal_LbaUcz) as suma from JednNabZajPozal  group by 1)
         as pozalek  on (j.jedn_id=pozalek.jedn_id)
    left outer join ( select jedn_id, sum(JednPosilek_liczba) as suma from JednPosilek) as posilki on (j.jedn_id=posilki.jedn_id)

    left outer join Jedn_Dowoz dowoz on (dowoz.jedn_id = j.jedn_id)

	where typjedn_id='00003'
	limit 100
	