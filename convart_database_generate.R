
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

if(!require('readr')) {
  install.packages('readr')
  library('readr')
}

db_names <- c("ENSMUST","ENST","NP","OTHER","UNIPROT","XP","YP") # I wouldnt use uniprot yet.

convart_gene_uniq_id <- 1

convart_gene_table <- data.frame(matrix(ncol = 4, nrow = 0))
convart_gene_to_db_table <- data.frame(matrix(ncol = 3, nrow = 0))

colnames(convart_gene_table) <- c('id', 'sequence', 'specie', 'hash')
colnames(convart_gene_to_db_table) <- c('convart_gene_id', 'db', 'db_id')



print("Select the Standartized CSV file that you process !!!")

Filters <- matrix(c("CSV File", ".csv", 
                    "All files", "*"),
                  4, 2, byrow = TRUE)

csv_files <- tk_choose.files( default = "", caption = "Select the Standartized CSV File",
                             multi = TRUE, filter = Filters)

foreach (csv_file=csv_files, .combine='c') %do% {
  st_csv_file <- read_csv(csv_file, col_types=cols(
    name = col_character(),
    specie = col_character(),
    annotation = col_character(),
    sequence = col_character(),
    creation_date = col_character()
  )) 
  
  
  
  # Initializes the progress bar
  pb <- tkProgressBar( title = "Convart Database generate From Standartized CSV",     # Title of bar
                       label = sprintf("analyzing file: %s",csv_file),    # Information label
                       min = 0,                      # Minimum value of the progress bar
                       max = nrow(st_csv_file),    # Maximum value of the progress bar
                       width = 500)                  
  
  
  
  foreach(i = 1:nrow(st_csv_file)) %do% {
    
    db_name <- "OTHER"
    for(el in db_names) {
      if(startsWith(st_csv_file[i,]$name, el) ){
        db_name <- el
        break
      }
    }
    
    checkStat <- match(TRUE, convart_gene_table$sequence %in% st_csv_file[i,]$sequence)
    
    if(! is.na(checkStat)){
      if(st_csv_file[i,]$specie==convart_gene_table[checkStat,]$specie){
        convart_gene_to_db_table[nrow(convart_gene_to_db_table) + 1, ] <- c(checkStat, db_name, st_csv_file[i,]$name)
        }
    }
    else {
      convart_gene_table[nrow(convart_gene_table) + 1, ] <- c(convart_gene_uniq_id,
                                                            st_csv_file[i,]$sequence,
                                                            st_csv_file[i,]$specie,
                                                            digest(toString(st_csv_file[i,]), algo="md5", serialize=F))
      convart_gene_to_db_table[nrow(convart_gene_to_db_table) + 1, ] <- c(convart_gene_uniq_id, db_name, st_csv_file[i,]$name)
      convart_gene_uniq_id <- convart_gene_uniq_id + 1
    }
    
    setTkProgressBar(pb, i)
    
  }
  
  close(pb)
}