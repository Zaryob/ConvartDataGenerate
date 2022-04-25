if(!require('readr')) {
  install.packages('readr')
  library('readr')
}


if(!require('tcltk')) {
  install.packages('tcltk')
  library('tcltk')
}


if(!require('foreach')) {
  install.packages('foreach')
  library('foreach')
}

Filters <- matrix(c("CSV File", "*.csv", 
                    "All files", "*"),
                  4, 2, byrow = TRUE)

csv_files <- tk_choose.files( default = "", caption = "Select CSV Files to Merge",
                             multi = TRUE, filter = Filters)
merged_data <- data.frame()

foreach (csv_file=csv_files, .combine='c') %do% {
  m_csv_file <- read_csv(csv_file)
  
  if(ncol(merged_data)==0){
    merged_data <- data.frame(matrix(ncol = ncol(m_csv_file), nrow = 0))
    colnames(merged_data) <- names(m_csv_file)
  }
  merged_data <- rbind(merged_data, m_csv_file)
}

write.csv(merged_data, "allmerged.csv")
