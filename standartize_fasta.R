
if(!require('tcltk')) {
  install.packages('tcltk')
  library('tcltk')
}

if(!require('foreach')) {
  install.packages('foreach')
  library('foreach')
}

if(!require('readr')) {
  install.packages('readr')
  library('readr')
}

if(!require('tidyverse')) {
  install.packages('tidyverse')
  library('tidyverse')
}

print("Select the NCBI CSV file that you process !!!")

Filters <- matrix(c("CSV File", "*NCBI*.csv", 
                    "All files", "*"),
                  4, 2, byrow = TRUE)

csv_file <- tk_choose.files( default = "", caption = "Select NCBI CSV File",
                               multi = FALSE, filter = Filters)

ncbi_csv_file <- read_csv(csv_file, col_types=cols(
  name = col_character(),
  specie = col_character(),
  annotation = col_character(),
  sequence = col_character(),
  creation_date = col_character()
)) 

print("Select the Ensembl CSV file that you process !!!")

Filters <- matrix(c("CSV File", "*Ensembl*.csv", 
                    "All files", "*"),
                  4, 2, byrow = TRUE)

csv_file <- tk_choose.files( default = "", caption = "Select Ensembl CSV File",
                             multi = FALSE, filter = Filters)

ensembl_csv_file <- read_csv(csv_file, col_types=cols(
  name = col_character(),
  transcript = col_character(),
  gene = col_character(),
  chromosome = col_character(),
  `gene symbol` = col_character(),
  specie = col_character(),
  annotation = col_character(),
  sequence = col_character(),
  creation_date = col_character()
)
) 

# Initializes the progress bar
pb <- tkProgressBar( title = "Convart Standartize Fasta CSV",     # Title of bar
                     label = "Combining CSV files of Ensembl and NCBI",    # Information label
                     min = 0,                      # Minimum value of the progress bar
                     max = nrow(ensembl_csv_file),    # Maximum value of the progress bar
                     width = 300)                  


foreach(i = 1:nrow(ensembl_csv_file)) %do% {
  ncbi_csv_file <- ncbi_csv_file %>% add_row(
    name=ensembl_csv_file[i,]$transcript,
    specie=ensembl_csv_file[i,]$specie,
    annotation=ensembl_csv_file[i,]$annotation,
    sequence=ensembl_csv_file[i,]$sequence,
    creation_date=ensembl_csv_file[i,]$creation_date
  )
  setTkProgressBar(pb, i)
  
}

fa_specie <- sub(" ", "_", ensembl_csv_file[1,]$specie)

write.csv(ncbi_csv_file, sprintf("%s_Standartized.csv", fa_specie))
close(pb)
