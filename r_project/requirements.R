#  loading necessary R libraries


lib <- c(
  "beepr", 
  "magrittr", 
  "tidyverse",
  "tokenizers",
  "jsonlite",
  "childesr" 
  #"stringr", 
  
  #"fastmatch",
  #"stringdist", 
  #"estimatr", 
  #"audio"
)

lapply(lib, require, character.only = TRUE)
rm(lib)

message("Requirements: finished")

