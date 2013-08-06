
kish.grid <- function(id,levels,units, number=1){
    
    if(!length(id) | !length(levels) | !length(units) | !length(number)){
        stop("One of the arguments has length of 0")
    }
    # id  - a  vector containing ID of selected units
    # levels  - char vector of length equal to number of levels - containg levels e.i selecting separatly grade 3 and grade 1 results in having 2 levels) 
    # units - integer vector of columns in Kish's grid - an assumption of a maximum number of units in each sampled cluster (e.i. max. number of students in 5th grade, max number of household members, etc.)
    # number -  of elements to choose. Without replacement, so the function won't try to select elements for <units> less than <number> 
    frame <- list()
    
    frame.id<-vector()
    frame.level <-vector() 
    
    for(u in number:length(units)){
       
        #print("\n")
        a=0
        vec <- vector()
        for(i in 1:length(id)){
            
            for(l in 1:length(levels)){
                
                vec[a+l] <- paste(sample(1:u,number), collapse=", ")
                #print(paste("el:",i+l-1,"u:",u," sample:",sample((1:u),1)))
            }
            a=a+length(levels)
        }
        frame[[u-number +1]] <- vec
    }
    
    a=0
    for(i in 1:length(id)){
        
        for(l in 1:length(levels)){
            frame.id[a+l] <- id[i]
            frame.level[a+l] <- levels[l]
            
        }
        a=a+length(levels)
    }
    
    
    frame <- as.data.frame(frame)
    for(i in number:length(units)){
        names(frame)[i - number + 1] <- paste("Liczba_",i,sep="")
        
    }
    data.frame(frame.id,frame.level,frame)
}

#zwraca ramki danych: probe podstawowa + rezerwy

simple.random <- function(data, n, reserve=2) {
    # data - ramka danych z operatu
    # n - docelowa liczebnosc proby podstawowej
    # reserve - liczba prob rezerwowych
    # zwraca: listę z ramkami danych ([[1]] -podstawowa) z proba+ dodatkowa zmienna wskazujaca probe (A- podstawowa (B... N - rezerwowe))
    
    if(!length(id) | !length(levels) | !length(units)){
        stop("One of the arguments has length of 0")
    }
    if(reserve < 0){
        stop("Reserve must be >= 0")
    }
    sample.size = n*(reserve+1)
    main.sample <- data[sample(nrow(data), sample.size), ]
    lett <- LETTERS[1:(reserve+1) ]
    
    main.sample$sample.marker <- rep.int(LETTERS[1:(reserve+1)], n)
    samps <- list()
    
    for(i in 1:(reserve+1)){
        samps[[i]] <- subset(main.sample, sample.marker==LETTERS[i] )
        
    }
    
    for(i in 1:(reserve+1)){
        samps[[i]]$SAMPLE_ID <- 1
        for(j in 1:nrow(samps[[i]])){
            if(samps[[i]]$sample.marker[j]=="A"){
                samps[[i]]$sample.marker[j] <- "P"
            }
            else{
                samps[[i]]$sample.marker[j] <- paste("R",match(samps[[i]]$sample.marker[j],LETTERS)-1,sep="")
            }
            samps[[i]]$SAMPLE_ID[j] <- paste(samps[[i]]$typ[j],"_",j,"_",samps[[i]]$sample.marker[j],sep="") 
        }
    }
    
    
    samps
}

