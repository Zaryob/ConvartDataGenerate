
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

if (!require('stringr')) {
  install.packages('stringr')
  library('stringr')
}


print("Select the standartized CSV file that you process !!!")

Filters <- matrix(c("CSV File", "*.csv",
                    "All files", "*"),
                  4, 2, byrow = TRUE)

csv_files <-
  tk_choose.files(
    default = "",
    caption = "Select Ensembl CSV File",
    multi = TRUE,
    filter = Filters
  )

foreach (csv_file = csv_files, .combine = 'c') %do% {
  standartized_csv_file <- read_csv(
    csv_file,
    col_types = cols(
      name = col_character(),
      specie = col_character(),
      annotation = col_character(),
      sequence = col_character(),
      creation_date = col_character()
    )
  )
  
  # Initializes the progress bar
  pb <-
    tkProgressBar(
      title = "Convart Standartize Fasta CSV",
      # Title of bar
      label = "Combining CSV files of Ensembl and NCBI",
      # Information label
      min = 0,
      # Minimum value of the progress bar
      max = nrow(standartized_csv_file),
      # Maximum value of the progress bar
      width = 300
    )
  
  
  foreach(i = 1:nrow(standartized_csv_file)) %do% {
    line <-
      c(
        sprintf(
          ">%s %s [%s]",
          name = standartized_csv_file[i, ]$name,
          annotation = str_remove(standartized_csv_file[i, ]$annotation, "\\[(.*?)\\]"),
          specie = standartized_csv_file[i, ]$specie
        ),
        standartized_csv_file[i, ]$sequence
      )
    
    write(line,
          # Write new line to file
          file = sprintf("%s.fasta", basename(csv_file)),
          append = TRUE)
    setTkProgressBar(pb, i)
  }
  
  close(pb)
}