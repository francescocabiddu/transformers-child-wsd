# preparation of models' sense prototypes, from ChiSense-12 + 4 additional target words

# load libraries and user-defined functions
sapply(
  c("requirements.R", "my_funs.R"),
  source
)

# path to folders -----------------------------------------------------------
chisense12_path <- paste0(getwd(), "/ChiSense-12") 

# Prepare ChiSense-12 train/test datasets ---------------------------------
# utterance id position to use when target appears multiple times in an utterance
resolve_duplicates <- read_tsv("resolve_duplicate_targets.txt")

is_file = file.exists(paste0(getwd(), "/ChiSense-12_for_nlm/", 
                             "/senses.tsv"))

if (is_file == TRUE) {
  print("ERROR: before proceeding, please delete sense.tsv file")
} else {
  for (target_word in c("band", "bat", "bow", "button", "card",
                        "chicken", "fish", "glasses", "lamb", "letter", "line",
                        "nail", "turkey")) {
    
    target <- import_target(target_word) 
    
    # classes_map
    classes_map <- map_classes(target)
    
    classes_map %>%
      mutate(target_word = ambiguous_word, .before = ambiguous_word) %>%
      unite(class, c("ambiguous_word", "ambiguous_meaning")) %>%
      select(-value) %>%
      write_tsv(file = paste0(getwd(), "/ChiSense-12_for_nlm/", 
                              "/senses.tsv"), 
                append = TRUE)
    
    # train.gold
    train_gold <- create_training(target, target_word) %>%
      resolve_duplicate_targets(resolve_duplicates,
                                target_word)
    
    save_training(target_word)
  }
}









