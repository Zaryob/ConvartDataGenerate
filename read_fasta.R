if(!require('seqinr')) {
  install.packages('seqinr')
  library('seqinr')
}

if(!require('foreach')) {
  install.packages('foreach')
  library('foreach')
}

if(!require('tcltk')) {
  install.packages('tcltk')
  library('tcltk')
}

if(!require('stringr')) {
  install.packages('stringr')
  library('stringr')
}

if(!require('readr')) {
  install.packages('readr')
  library('readr')
}


### FUNCTIONS

#
#=> selectDatabase
#     Used to set which source used as fasta
#       NCBI    -> 0
#       Ensembl -> 1
#

selectDatabase <- function(){
  
  ## Main Frame
  base <- tktoplevel()
  tkwm.title(base, "Convart Read Fasta")
  
  
  ## Create a variable to keep track of the state of the dialog window:
  ##  done = 0; If the window is active
  ##  done = 1; If the window has been closed using the OK button
  ##  done = 2; If the window has been closed using the Cancel button or destroyed 
  done <- tclVar(0)
  tkbind(base,"<Destroy>",function() tclvalue(done)<-2)
  
  
  ## First Frame: Monthly or quarterly data?
  quart  <- tclVar(0)
  frame1 <- tkframe(base, relief="groove", borderwidth=2)
  buton1 <- tkradiobutton(frame1, text="NCBI",   value=0, vari=quart)
  buton2 <- tkradiobutton(frame1, text="Ensembl", value=1, vari=quart)
  tkpack(tklabel(frame1, text="Select the FASTA source that you process!!!"), anchor="w")
  tkpack(buton1, anchor="w")
  tkpack(buton2, anchor="w")
  
  ## OK button
  OnOK   <- function() {
    results <<- c(tclvalue(quart))
    tclvalue(done) <- 1
  }
  
  q.but <- tkbutton(base, text="OK", command=OnOK)
  
  ## Do it!
  tkpack(frame1, q.but, fill="x")
  
  ## Focus window
  tkfocus(base)
  
  ## Do not proceed with the following code until the variable done is non-zero.
  ##   (But other processes can still run, i.e. the system is not frozen.)
  tkwait.variable(done)
  
  ## If window is closed return value will be -1
  if(tclvalue(done) != 1) {
    results <- -1
  }
  
  ## Before go, remove window
  tkdestroy(base)
  
  return(results)
}

#====

#
#=> selectSpecie
#     Used to set which source used as fasta
#       Homo sapiens 
#       Mus musculus
#       Caenorhabditis elegans
#       
#

selectSpecie <- function(){
  
  ## Main Frame
  base <- tktoplevel()
  tkwm.title(base, "Convart Read Fasta")
  
  
  ## Create a variable to keep track of the state of the dialog window:
  ##  done = 0; If the window is active
  ##  done = 1; If the window has been closed using the OK button
  ##  done = 2; If the window has been closed using the Cancel button or destroyed 
  done <- tclVar(0)
  tkbind(base,"<Destroy>",function() tclvalue(done)<-2)
  
  
  ## First Frame: Monthly or quarterly data?
  quart  <- tclVar("Homo sapiens")
  frame1 <- tkframe(base, relief="groove", borderwidth=2)
  buton1 <- tkradiobutton(frame1, text="Homo sapiens",   value="Homo sapiens", vari=quart)
  buton2 <- tkradiobutton(frame1, text="Mus musculus", value="Mus musculus", vari=quart)
  buton3 <- tkradiobutton(frame1, text="Caenorhabditis elegans", value="Caenorhabditis elegans", vari=quart)
  tkpack(tklabel(frame1, text="Select the specie!!!"), anchor="w")
  tkpack(buton1, anchor="w")
  tkpack(buton2, anchor="w")
  tkpack(buton3, anchor="w")
  
  ## OK button
  OnOK   <- function() {
    results <<- c(tclvalue(quart))
    tclvalue(done) <- 1
  }
  
  q.but <- tkbutton(base, text="OK", command=OnOK)
  
  ## Do it!
  tkpack(frame1, q.but, fill="x")
  
  ## Focus window
  tkfocus(base)
  
  ## Do not proceed with the following code until the variable done is non-zero.
  ##   (But other processes can still run, i.e. the system is not frozen.)
  tkwait.variable(done)
  
  ## If window is closed return value will be -1
  if(tclvalue(done) != 1) {
    results <- -1
  }
  
  ## Before go, remove window
  tkdestroy(base)
  
  return(results)
}

#====

print("Select the FASTA source file that you process !!!")

dataSource<-selectDatabase()

if(dataSource==-1){
  stop("Not database selected!")
} 



print("Select the NCBI FASTA file that you process !!!")

Filters <- matrix(c("Fasta File", ".fasta", 
                    "Fasta File", ".faa",
                    "Fasta File", ".fa",
                    "Compressed Fasta File", ".fa.*", 
                    "Compressed Fasta File", ".faa.*", 
                    "Compressed Fasta File", ".fasta.*", 
                    "All files", "*"),
                    4, 2, byrow = TRUE)

fasta_file <- tk_choose.files( default = "", caption = "Select NCBI Fasta File",
                 multi = FALSE, filter = Filters)

fastas <- read.fasta(fasta_file, as.string = TRUE, seqtype = "AA" ) 


print("Importing data!!")

# Initializes the progress bar
i = 0
pb <- tkProgressBar( title = "Convart Read Fasta",     # Title of bar
                     label = "Importing fasta",    # Information label
                     min = 0,                      # Minimum value of the progress bar
                     max = length(fastas),    # Maximum value of the progress bar
                     width = 300)                  

if(dataSource == 0) {
  fasta_data <- data.frame(matrix(ncol = 5, nrow = 0))
  colnames(fasta_data) <- c("name", "specie", "annotation", "sequence", "creation_date")
  
  foreach(fasta = fastas, .combine='c') %do% {
    # Regex patterns
    fa_speciePattern = "\\[(.*?)\\]"
    fa_namePattern = "\\>([A-Z]{2}_[0-9]+\\.[0-9]+)"
    
    # Annotation
    fa_annot=attr(fasta, 'Annot')
    
    # Name of genome
    fa_name=str_extract(fa_annot, fa_namePattern)
    fa_name=substring(fa_name, 2, nchar(fa_name))
    fa_annot = str_remove(fa_annot, fa_namePattern)
    
    # Specie
    fa_specie = str_extract(fa_annot, fa_speciePattern)
    fa_specie = substring(fa_specie, 2, nchar(fa_specie)-1)
    fa_annot = str_remove(fa_annot, fa_speciePattern)
    
    fasta_data[nrow(fasta_data) + 1, ] <- c( 
      fa_name,
      fa_specie,
      fa_annot, 
      fasta[1], 
      format(Sys.time(), "%a %b %d %X %Y")
    )   # Append new row
    
    setTkProgressBar(pb, i)
    i <- i+1
  }
} else if (dataSource == 1){
  
  fasta_data <- data.frame(matrix(ncol = 9, nrow = 0))
  colnames(fasta_data) <- c("name", "transcript", "gene", "chromosome", "gene symbol", "specie", "annotation", "sequence", "creation_date")

  fa_specie=selectSpecie()
  foreach(fasta = fastas, .combine='c') %do% {
    # Regex patterns
    fa_namePattern = "\\>([A-Z]{4}[0-9]+\\.[0-9]+)"
    fa_transcriptPattern = "transcript:([A-Z]{4}[0-9]+\\.[0-9]+)"
    fa_chromosomePattern = "chromosome:((.*?):(.*?):(.*?):(.*?):(.*?) )"
    fa_genePattern = "gene:([A-Z]{4}[0-9]+\\.[0-9]+) "
    fa_geneSymbolPattern="gene_symbol:(.*?) "
    
    # Annotation
    fa_annot=attr(fasta, 'Annot')
    
    # Name of genome
    fa_name=str_extract(fa_annot, fa_namePattern)
    fa_name=substring(fa_name, 2, nchar(fa_name))
    
    # Cromosome
    fa_chromosome= str_extract(fa_annot, fa_chromosomePattern)
    fa_chromosome= substring(fa_chromosome, 12, nchar(fa_chromosome)-1)
    
    # Gene
    fa_gene = str_extract(fa_annot, fa_genePattern)
    fa_gene = substring(fa_gene, 6, nchar(fa_gene)-1)
    
    # Transcript ENSTxxxxxxx.xx
    fa_transcript=str_extract(fa_annot, fa_transcriptPattern)
    fa_transcript=substring(fa_transcript, 12, nchar(fa_transcript))
    
    # Gene Symbol
    fa_geneSymbol = str_extract(fa_annot, fa_geneSymbolPattern)
    fa_geneSymbol = substring(fa_geneSymbol, 13, nchar(fa_geneSymbol))

    # Description
    fa_annot = str_extract(fa_annot, "description:.*")
    fa_annot = substring(fa_annot, 13, nchar(fa_annot))
    fa_annot = str_remove(fa_annot,  "description:.*")

    
    fasta_data[nrow(fasta_data) + 1, ] <- c( 
      fa_name,
      fa_transcript, # Name is equal to transcript
      fa_gene,
      fa_chromosome,
      fa_geneSymbol,
      fa_specie,
      fa_annot, 
      fasta[1], 
      format(Sys.time(), "%a %b %d %X %Y")
    )   # Append new row
    
    
    setTkProgressBar(pb, i)
    i <- i+1
  }
}

## Write data as csv
options(readr.show_progress = TRUE)
write_csv(fasta_data, "fasta_output_data.csv", col_names = TRUE)

close(pb)



