wyniki.10.11 <- wyniki.test[wyniki.test$Przejeta10.11==1,]
wyniki.test$suma <- wyniki.test$Przejeta07.08 + wyniki.test$Przejeta08.09 + wyniki.test$Przejeta09.10+
                      wyniki.test$Przejeta10.11
wyniki.przejete.ogolem <- wyniki.test[wyniki.test$suma>0,]

compute_outliers <- function(x,y){
  if(!is.na(x) & x > 0 & !is.na(y)){
    return((y-x)/x)
    }
  else{
    return(NA)
    }
  }
wyniki.test$roznica07_08 <-0
for(i in 1:nrow(wyniki.test)){
  wyniki.test$roznica07_08[i] <- compute_outliers(wyniki.test$lba_uczniow_07[i],wyniki.test$lba_uczniow_08[i])
  }
  
wyniki.test$roznica08_09 <-0
for(i in 1:nrow(wyniki.test)){
  wyniki.test$roznica08_09[i] <- compute_outliers(wyniki.test$lba_uczniow_08[i],wyniki.test$lba_uczniow_09[i])
}

wyniki.test$roznica09_10 <-0
for(i in 1:nrow(wyniki.test)){
  wyniki.test$roznica09_10[i] <- compute_outliers(wyniki.test$lba_uczniow_09[i],wyniki.test$lba_uczniow_10[i])
}

wyniki.test$roznica10_11 <-0
for(i in 1:nrow(wyniki.test)){
  wyniki.test$roznica10_11[i] <- compute_outliers(wyniki.test$lba_uczniow_10[i],wyniki.test$lba_uczniow_11[i])
}

dziwne_zmiany <- wyniki.test
write.csv2(wyniki.test,"wyniki-test.csv")
plot(density(roznica[!is.na(roznica)]))
summary(roznica)


gmina chęcin
publiczna szkoła podstawowa w korzecku


        