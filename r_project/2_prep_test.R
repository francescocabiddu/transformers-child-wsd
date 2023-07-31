# prepare models' test sentences across 3 behavioral experiments

# load libraries and user-defined functions
sapply(
  c("requirements.R", "my_funs.R"),
  source
)

test_data <- read_csv("test_utterances.csv")

test_data %<>%
  mutate(utterance = utterance %>%
           tolower,
         id_target = id_target - 1)

for (target_label in c("band", "bat", "bow", "button", "card",
                       "chicken", "fish", "glasses", "lamb", "letter", "line",
                       "nail", "turkey")) {
  test_data %>%
    filter(target == target_label) %>%
    select(id_target, utterance) %>%
    write_delim(file = paste0(getwd(), "/ChiSense-12_for_nlm/", 
                              target_label, "/test.data.txt"), ##
                delim = "\t", col_names = FALSE)
  
  test_data %>%
    filter(target == target_label) %>%
    pull(value) %>%
    write_lines(file = paste0(getwd(), "/ChiSense-12_for_nlm/", 
                              target_label, "/test.gold.txt")) ##
}


