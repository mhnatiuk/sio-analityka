﻿explain analyze select j07.jedn_nazwa as "nazwa07",j11.jedn_nazwa as "nazwa11", j07.jedn_regon as "regon07", j08.jedn_regon as "regon08", j09.jedn_regon as "regon09", 
j10.jedn_regon as "regon10", j11.jedn_regon as "regon11",

(case when j07.OrganProw_Id='0001' and j08.OrganProw_Id='0022' then 1 else 0 end) as "Przejeta07-08",
(case when j08.OrganProw_Id='0001' and j09.OrganProw_Id='0022' then 1 else 0 end) as "Przejeta08-09",
(case when j09.OrganProw_Id='0001' and j10.OrganProw_Id='0022' then 1 else 0 end) as "Przejeta09-10",
(case when j10.OrganProw_Id='0001' and j11.OrganProw_Id='0022' then 1 else 0 end) as "Przejeta10-11"

from (select j.*,u.jedn_kodpoczt,u.jedn_telefon, u.jedn_nazwa from sio2007.jedn j left outer join sio2007.jedn_uzup u on (j.jedn_id=u.jedn_id) ) as j07


left outer join 
		(select j.*,u.jedn_kodpoczt,u.jedn_telefon, u.jedn_nazwa from sio2008.jedn j left outer join sio2008.jedn_uzup u on (j.jedn_id=u.jedn_id) )
		 as j08 on (j07.jedn_identyfikator=j08.jedn_identyfikator or ( (j07.jedn_kodpoczt=j08.jedn_kodpoczt) and (j07.jedn_telefon=j08.jedn_telefon) ) )
	
left outer join 
		(select j.*,u.jedn_kodpoczt,u.jedn_telefon, u.jedn_nazwa from sio2009.jedn j left outer join sio2009.jedn_uzup u on (j.jedn_id=u.jedn_id) )
		as j09 on (j08.jedn_identyfikator=j09.jedn_identyfikator or ( (j08.jedn_kodpoczt=j09.jedn_kodpoczt) and (j08.jedn_telefon=j09.jedn_telefon) ) )
left outer join 
		(select j.*,u.jedn_kodpoczt,u.jedn_telefon, u.jedn_nazwa from sio2010.jedn j left outer join sio2010.jedn_uzup u on (j.jedn_id=u.jedn_id) ) 
		as j10 on (j09.jedn_identyfikator=j10.jedn_identyfikator or ( (j09.jedn_kodpoczt=j10.jedn_kodpoczt) and (j09.jedn_telefon=j10.jedn_telefon) ) )
left outer join 
		(select j.*,u.jedn_kodpoczt,u.jedn_telefon, u.jedn_nazwa from sio2011.jedn j left outer join sio2011.jedn_uzup u on (j.jedn_id=u.jedn_id) ) 
		as j11 on (j10.jedn_identyfikator=j11.jedn_identyfikator or ( (j10.jedn_kodpoczt=j11.jedn_kodpoczt) and (j10.jedn_telefon=j11.jedn_telefon) ) )
where 
(j11.typjedn_id = '00003' or j10.typjedn_id = '00003' or j09.typjedn_id = '00003' or j08.typjedn_id = '00003' or j07.typjedn_id = '00003')

