
if(!require('tcltk')) {
  install.packages('tcltk')
  library('tcltk')
}

if(!require('foreach')) {
  install.packages('foreach')
  library('foreach')
}

if(!require('digest')) {
  install.packages('digest')
  library('digest')
}


print("Select the Standartized CSV file that you process !!!")

Filters <- matrix(c("CSV File", ".csv", 
                    "All files", "*"),
                  4, 2, byrow = TRUE)

csv_file <- tk_choose.files( default = "", caption = "Select the Standartized CSV File",
                             multi = FALSE, filter = Filters)

st_csv_file <- read_csv(csv_file, col_types=cols(
  name = col_character(),
  specie = col_character(),
  annotation = col_character(),
  sequence = col_character(),
  creation_date = col_character()
)) 


db_names <- c("ENSMUST","ENST","NP","OTHER","UNIPROT","XP","YP") # I wouldnt use uniprot yet.

# Initializes the progress bar
pb <- tkProgressBar( title = "Convart Database generate From Standartized CSV",     # Title of bar
                     label = "Convart Database generate From Standartized CSV",    # Information label
                     min = 0,                      # Minimum value of the progress bar
                     max = length(st_csv_file),    # Maximum value of the progress bar
                     width = 300)                  


convart_gene_uniq_id <- 1

convart_gene_table <- data.frame(matrix(ncol = 4, nrow = 0))
convart_gene_to_db_table <- data.frame(matrix(ncol = 3, nrow = 0))

colnames(convart_gene_table) <- c('id', 'sequence', 'specie', 'hash')
colnames(convart_gene_to_db_table) <- c('convart_gene_id', 'db', 'db_id')


foreach(i = 1:nrow(st_csv_file)) %do% {
  
  db_name <- "OTHER"
  for(el in db_names) {
    if(startsWith(st_csv_file[i,]$name, el) ){
      db_name <- el
      break
    }
  }
  
  breakUp <- FALSE
  foreach(j = 1:nrow(convart_gene_table)) %do% {
    checkSt<-(st_csv_file[i,]$sequence == convart_gene_table[j,]$sequence) && 
      (st_csv_file[i,]$specie == convart_gene_table[j,]$specie)
    if(! is.na(checkSt)){
      if(checkSt) {
        convart_gene_to_db_table[nrow(convart_gene_to_db_table) + 1, ] <- c(j,db_name, st_csv_file[i,]$name)
        breakUp <- TRUE
        break
      }
    }
   
  }

  
  if(isFALSE(breakUp)){
    convart_gene_table[nrow(convart_gene_table) + 1, ] <- c(convart_gene_uniq_id,
                                                          st_csv_file[i,]$sequence,
                                                          st_csv_file[i,]$specie,
                                                          digest(toString(st_csv_file[i,]), algo="md5", serialize=F))
    convart_gene_to_db_table[nrow(convart_gene_to_db_table) + 1, ] <- c(convart_gene_uniq_id, db_name, st_csv_file[i,]$name)
  }
  
  breakUp <- FALSE
  convart_gene_uniq_id <- convart_gene_uniq_id + 1
  setTkProgressBar(pb, i)
  
}

close(pb)