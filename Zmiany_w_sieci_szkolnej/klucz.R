library(RPostgreSQL)
#
setwd("~/Dokumenty/ibemisc/Zapytania do SIO/Szkoly stowarzyszenia/")
#
klucz <- read.csv("klucz_gimnazja.csv",colClasses = c("character"))
years <- paste( "20",substr(names(klucz),8,9),sep="") # wyciagnij rok SIO
klucz$order <- 1:nrow(klucz)
template_query10_12 <- paste(scan(file="template_query10_12.sql",what="character",sep="\n"),collapse="\n")
template_query07_09 <- paste(scan(file="template_query07_09.sql",what="character",sep="\n"),collapse="\n")


#for( i in 1:ncol(klucz)){ # petla po zmiennych klucza
#klucz[,i] <- paste("00",klucz[,i],sep="")
#klucz[klucz[,i]=="00",i] <- ""
#klucz[,i] <- paste("'",klucz[,i],"'",sep="")
#}


# kreator połączeń:
connect_bazek_sio <-
    function() {
        return( dbConnect(dbDriver('PostgreSQL'),
                          user ="###",
                          password = "###",
                          host = 'bazek.ibe.edu.pl',
                          dbname = 'sio') )
    }

# get_query:
gq <-
    function(...) {
        connSio <<- connect_bazek_sio()
        result = dbGetQuery(connSio, paste(...))
        dbDisconnect(connSio)
        return(result)
    }


#dbConnect("PostgreSQL",user="mhnatiuk",password="pUshP1N$", host="bazek.ibe.edu.pl")
#dbGetQuery(con,query)

data <- list()
#years = c("2008")
#for(i in 1:length(years)){
for(i in 1:length(years)){
    
    set_schema <- paste("set search_path to 'sio" ,  years[i] ,"';", sep="")
    if (i <= 3) template_query <- template_query07_09 else
                template_query <- template_query10_12
    
    id_filter <- paste("jedn_id::bigint IN ( ",paste(klucz[klucz[,i]!="",i],
                             collapse=","), ")")
    query <- paste(set_schema, gsub('<<TYP_JEDN>>','00004',gsub("<<JEDN_ID>>", id_filter ,template_query )) )
    
    f =file("query_ex.sql","w")
    cat(query, file = f)
    close(f)
   # print(query)
    data[[i]] <- gq(query)
    data[[i]][,1] <- as.numeric(data[[i]][,1])
    data[[i]] <- merge(data.frame(jedn_id=as.numeric(klucz[,i]),order=klucz$order), data[[i]],all.x=TRUE, by=c("jedn_id") )
    data[[i]] <- data[[i]][order(data[[i]]$order),]
    #out <- file("query.txt","w")
    #cat(query,file=out)
   # close(out)
    }


library(xlsx)
wb<- createWorkbook()
cs3 <- CellStyle(wb) + Font(wb, isBold=TRUE) + Border()  # header


for(i in 1:length(data)){
    write.csv2(data[[i]],paste("dane_gimnazja_",years[i],".csv",sep=""),fileEncoding="cp1250")
    #sheet <- createSheet(wb,sheetName=paste("Rok",years[i]))
    #addDataFrame(data[[i]],sheet,startRow=1,startColumn=1,colnamesStyle=cs3)
    }
#saveWorkbook(wb,"Dane do klucza - podstawowki.xlsx")






