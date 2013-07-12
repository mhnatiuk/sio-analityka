select * from (
select j.jedn_identyfikator,
ju.jedn_nazwa as "nazwa2008",j.OrganProwNazwa,j.OrganProw_Id ,opr.organ_nazwa as "Organ 2008",j07.jedn_identyfikator,
opr07.organ_nazwa as "Organ 2007",
szkoly07.jedn_nazwa, szkoly07.jedn_identyfikator, szkoly07.organ_nazwa as "Organ 2007 - inny identyfikator"
 from sio2008.jedn j 
	left outer join sio2008.jedn_uzup ju on j.jedn_id=ju.jedn_id
		LEFT OUTER JOIN sio2008.sorgan opr ON j.organprow_id=opr.organ_id
		left outer join sio2007.jedn j07 on j07.jedn_identyfikator = j.jedn_identyfikator
			LEFT OUTER JOIN sio2007.sorgan opr07 ON j07.organprow_id=opr07.organ_id

			----
			left outer join (
			select  j07_uzup.jedn_kodpoczt,  j07_uzup.jedn_telefon,
			j07_uzup.jedn_id, j07_app.jedn_identyfikator, opr07_app.organ_nazwa, j07_uzup.jedn_nazwa
			 from sio2007.jedn_uzup j07_uzup 

				left outer join sio2007.jedn j07_app on j07_app.jedn_id = j07_uzup.jedn_id
					LEFT OUTER JOIN sio2007.sorgan opr07_app ON j07_app.organprow_id=opr07_app.organ_id
			where j07_app.typjedn_id = '00003'
					) as szkoly07 on (szkoly07.jedn_kodpoczt=ju.jedn_kodpoczt and szkoly07.jedn_telefon=ju.jedn_telefon)
			----
 where j.typjedn_id = '00003' 
and j.organProw_id='0022'
) as szkoly_stow