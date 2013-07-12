rm(list=ls())
setwd("/home/mikolaj/Dokumenty/ibemisc/Zapytania do SIO/Szkoly stowarzyszenia/")

library(RODBC)
con<-odbcConnect("sio")

dane <- list()
for (i in 1:5){
rok = 2006 + i
zapytanie <- paste("select 
j.*,
u.jedn_kodpoczt,
substring(u.jedn_telefon from '[0-9]{7}$')::numeric as jedn_telefon, u.jedn_nazwa,
u.jedn_ulica,u.jedn_domlokal,
m.miejscow_nazwa as miejscowosc, jedn_www , l_uczniow_1_3,l_uczniow_4_6,
g.gmina_nazwa, 
(g.wojew_idgus || g.powiat_idgus || g.gmina_idgus || g.gminatyp_id  ) as teryt7cyfr
, case when j.jednnadrz_id!=j.jedn_id then 'Tak' else 'Nie' end as w_zespole
, (case 
   when (j.jedn_id != j.jednnadrz_id and j.jedn_id != j.jednmacierz_id ) then 'Filia'
   when (j.jedn_id != j.jednnadrz_id and j.jedn_id = j.jednmacierz_id ) then 'Zespół'
   else '' end ) as \"Złożoność\"

from sio",rok,".jedn j
left join sio",rok,".jedn_uzup u on (j.jedn_id=u.jedn_id)

LEFT OUTER JOIN (
  SELECT
  okl.jedn_id,
  sum(jednnaboddzkl_brokucz)
  AS l_uczniow_1_3
  
  --count(*) AS l_rekordow,
  --sum(jednnaboddzkl_brokucz) AS sr_l_uczniow_w_oddziale 
  -- ma wartość ujemną, gdy sum(okl_x.jednnaboddzkl_brokoddz) równa 0
  FROM
  sio",rok,".jednnaboddzkl_uczbrok okl
  JOIN sio",rok,".jednnaboddz o ON okl.jednnaboddz_id=o.jednnaboddz_id
  JOIN sio",rok,".sklasa k ON okl.klasa_id=k.klasa_id
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
  sio",rok,".jednnaboddzkl_uczbrok okl
  JOIN sio",rok,".jednnaboddz o ON okl.jednnaboddz_id=o.jednnaboddz_id
  JOIN sio",rok,".sklasa k ON okl.klasa_id=k.klasa_id
  WHERE
  okl.klasa_id in ('007','008','009')
  AND o.specoddzpodst_id IN ('001')
  GROUP BY
  1
  
) AS klasy4_6 ON j.jedn_id=klasy4_6.jedn_id

left join sio",rok,".sMiejscow m on (m.miejscow_id=j.miejscow_id)
left join sio",rok,".sGmina g on (m.gmina_id=g.gmina_id)

where typjedn_id='00003'
--AND j.jednnadrz_id[=/<>]j.jedn_id -- PYTANIE 3.2
--AND j.organprow_id IN ('0001')

AND j.kategucz_id IN ('001')
AND j.specszk_id IN ('100')
AND j.zwiazanie_id IN ('0100');",sep="")
wynik<-sqlQuery(con, zapytanie)

#for(name in 1:length(names(wynik))){
 # names(wynik)[name] <- paste( names(wynik)[name], "_",rok, sep="")
  #}

dane[[i]] <- wynik

}




#i<- 1
#thisyear_nr = 2006 + i
# nextyear_nr =thisyear_nr+1 
#this_year <- dane[[i]]
#temp <- dane[[i+1]]
#next_year <- temp[order(temp$jedn_identyfikator),]
#library(sqldf)

#thisyear_nr <- paste("_",thisyear_nr,sep="")
#nextyear_nr <- paste("_",nextyear_nr,sep="")
#

#y0708 <- sqldf(paste("select this_year.*, next_year.* FROM this_year 
 #              LEFT OUTER JOIN next_year 
  #             ON 
   #            (this_year.jedn_identyfikator",thisyear_nr,"=next_year.jedn_identyfikator",
    #                 nextyear_nr," or
     #             ( (this_year.teryt7cyfr",thisyear_nr,"=next_year.teryt7cyfr",nextyear_nr,") 
      #                  and (this_year.jedn_kodpoczt",thisyear_nr,"=next_year.jedn_kodpoczt",nextyear_nr,") 
       #                 and (this_year.jedn_telefon",thisyear_nr,"=next_year.jedn_telefon",nextyear_nr,") ) )",sep=""),drv="SQLite")

#int <- findInterval(this.year$jedn_identyfikator, next.year$jedn_identyfikator)
#y0708 <- merge(this.year,next.year, 
#               by.x=("jedn_identyfikator_2007"), 
#               by.y=("jedn_identyfikator_2008"),
#               all.x=TRUE)

i<-1

trim_factors <- function(df){
  for(i in 1:ncol(df)){
      if(is.factor(df[,i])){
         df[,i] <- as.character(df[,i])
        }
    }
  df
  }

polaczone <- list()

#polacz(dane[[1]],dane[[2]],2007)
deb <- function(){
for(i in 1:4){ ## 4 złaczenia # 07-08 08-09 09-10 10-11

  whatyear <- 2006 + i
  this.year <- dane[[i]]
  temp <- dane[[i+1]]
  next.year <- temp[order(temp$jedn_identyfikator),]
  #filter <- (this.year$jedn_identyfikator==next.year$jedn_identyfikator)
  #int <- findInterval(this.year$jedn_identyfikator, next.year$jedn_identyfikator)
  #this.year$next_id <- next.year[(int),1]
  
  matching <- merge(this.year,next.year, 
                 by.x=("jedn_identyfikator"), 
                 by.y=("jedn_identyfikator"),
                 all.x=TRUE)
  
  jedn_ids <- names(matching)[grep("^(jedn_id|jedn_id\\..*)$",names(matching))]
  matched <- subset(matching, !is.na(matching[[jedn_ids[length(jedn_ids)]]]))
  matched$zrodlo <- "jedn_identyfikator"
  names(matched)[ncol(matched)] <- paste(names(matched)[ncol(matched)], whatyear,sep="_")
  nonmatched <- subset(matching,is.na(matching[[jedn_ids[length(jedn_ids)]]]),
                                       select=names(matching)[c(1,grep(".(x|y)$",names(matching)))])
  nonmatched <- trim_factors(nonmatched)
  next.year  <- trim_factors(next.year)
  this.year  <- trim_factors(this.year)
  
  dict <- data.frame()
  for(x in 7:nrow(nonmatched))
      {      
      x
          filter <- (nonmatched$teryt7cyfr.x[x] == next.year$teryt7cyfr &
            nonmatched$jedn_telefon.x[x]== next.year$jedn_telefon &
            nonmatched$jedn_kodpoczt.x[x]== next.year$jedn_kodpoczt)
          pp <- next.year[which(filter),1:ncol(next.year)]
          for(name in 1:ncol(pp)){
              names(pp)[name] <- paste(names(pp)[name],".y",sep="")
              }
          if(nrow(pp) == 1 ){
              
          pp$zrodlo <- "jedn_telefon_i_jedn_kodpoczt"
          names(pp)[ncol(pp)] <- paste(names(pp)[ncol(pp)], whatyear,sep="_")
          
          dict <- rbind(dict,cbind(nonmatched[x,], pp))
           
          }
          else{
              
              ids = which(toupper(nonmatched$miejscowosc.x[x]) == toupper(next.year$miejscowosc))
                            
            if(length(ids)==1) {
              pp <- next.year[ids[1],1:ncol(next.year)]
              for(name in 1:ncol(pp)){
                  names(pp)[name] <- paste(names(pp)[name],".y",sep="")
              }
              pp$zrodlo <- "miejscowosc"
              names(pp)[ncol(pp)] <- paste(names(pp)[ncol(pp)], whatyear,sep="_")
              dict <- rbind(dict,cbind(nonmatched[x,], pp))
            }
            else{
                
            }
              
            
          }
      }
  
  jedn_identyfikator_2 <- names(matching)[grep("^jedn_identyfikator\\.",names(matching))]
  column_to_remove <- jedn_identyfikator_2[length(jedn_identyfikator_2)]
  polaczone <- rbind(matched,subset(dict, select=-jedn_identyfikator.y))
  polaczone <- rbind(matched,dict)
  dane[[i+1]] <- polaczone
  }

#for(z in 1:nrow(test1)){
 # filter <- (pedag.ag$jedn_id==test1$jedn_id_SIO[z] & pedag.ag$plec==test1$plec[z] & 
  #  pedag.ag$pedag_dataur==test1$m4[z] & pedag.ag$awans == test1$m8[z])
  
  #if(nrow(pedag.ag[which(filter),]) > 0 ){
   # pp <- pedag.ag[which(filter),]
  #  if(nrow(pp)  > 1) { # potrzebne dopasowanie
} 

debug(deb)
deb()



