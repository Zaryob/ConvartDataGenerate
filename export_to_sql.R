


if (!require('tcltk')) {
  install.packages('tcltk')
  library('tcltk')
}

if (!require('foreach')) {
  install.packages('foreach')
  library('foreach')
}

if (!require('readr')) {
  install.packages('readr')
  library('readr')
}

if (!require('tidyverse')) {
  install.packages('tidyverse')
  library('tidyverse')
}


print("Select the NCBI CSV file that you process !!!")

Filters <- matrix(c("CSV File", "*NCBI*.csv",
                    "All files", "*"),
                  4, 2, byrow = TRUE)

csv_file <-
  tk_choose.files(
    default = "",
    caption = "Select NCBI CSV File",
    multi = FALSE,
    filter = Filters
  )

ncbi_csv_file <- read_csv(
  csv_file,
  col_types = cols(
    name = col_character(),
    specie = col_character(),
    annotation = col_character(),
    sequence = col_character(),
    creation_date = col_character()
  )
)

print("Select the Ensembl CSV file that you process !!!")

Filters <- matrix(c("CSV File", "*Ensembl*.csv",
                    "All files", "*"),
                  4, 2, byrow = TRUE)

csv_file <-
  tk_choose.files(
    default = "",
    caption = "Select Ensembl CSV File",
    multi = FALSE,
    filter = Filters
  )

ensembl_csv_file <- read_csv(
  csv_file,
  col_types = cols(
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
merged_data <- ""

# Initializes the progress bar
pb <-
  tkProgressBar(
    title = "Convart SQL Export",
    # Title of bar
    label = "Combining CSV files to export for Ensembl and NCBI",
    # Information label
    min = 0,
    # Minimum value of the progress bar
    max = nrow(ensembl_csv_file),
    # Maximum value of the progress bar
    width = 300
  )

foreach(i = 1:nrow(ensembl_csv_file)) %do% {
  merged_data <-  rbind(merged_data, paste0(
    "INSERT INTO ensembl_meta_data ",
    "( id, ",
    paste0(names(ensembl_csv_file)[2:length(ensembl_csv_file)], collapse = ", "),
    ") ",
    sprintf(
      "VALUES ( %d, %s, %s, %s, %s, %s, %s, %s, %s",
      i,
      ensembl_csv_file[i,]$name,
      ensembl_csv_file[i,]$transcript,
      ensembl_csv_file[i,]$gene,
      ensembl_csv_file[i,]$chromosome,
      ensembl_csv_file[i,]$`gene symbol`,
      ensembl_csv_file[i,]$specie,
      ensembl_csv_file[i,]$annotation,
      ensembl_csv_file[i,]$sequence,
      ensembl_csv_file[i,]$creation_date
    ),
    ")"
  ))
  
  setTkProgressBar(pb, i)
  
}



# Initializes the progress bar
pb <-
  tkProgressBar(
    title = "Convart SQL Export",
    # Title of bar
    label = "Combining CSV files to export for Ensembl and NCBI",
    # Information label
    min = 0,
    # Minimum value of the progress bar
    max = nrow(ncbi_csv_file),
    # Maximum value of the progress bar
    width = 300
  )

foreach(i = 1:nrow(ncbi_csv_file)) %do% {
  
  merged_data <-  rbind(merged_data, paste0(
    "INSERT INTO ncbi_meta_data ",
    "( id, ",
    paste0(names(ncbi_csv_file)[2:length(ncbi_csv_file)], collapse = ", "),
    ") ",
    sprintf(
      "VALUES ( %d, %s, %s, %s, %s, %s ",
      i,
      ensembl_csv_file[i,]$name,
      ensembl_csv_file[i,]$specie,
      ensembl_csv_file[i,]$annotation,
      ensembl_csv_file[i,]$sequence,
      ensembl_csv_file[i,]$creation_date
    ),
    ")"
  ))
  setTkProgressBar(pb, i)
  
  
}

fileConn<-file("output.sql")

writeLines(merged_data, fileConn)
close(fileConn)
writeLines()


close(pb)
