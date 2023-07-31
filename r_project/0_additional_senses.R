# tagging of 4 additional target ambiguous nouns present in English CHILDES database
# to add to ChiSense-12
 
# load libraries and user-defined functions
sapply(
  c("requirements.R", "my_funs.R"),
  source
)

# path to folders -----------------------------------------------------------
chisense12_path <- paste0(getwd(), "/ChiSense-12") 


# child-directed words ----------------------------------------------------
# download English Childes
corpora <- get_utterances(
  collection = c("Eng-UK", "Eng-NA"),
  # select version 2020.1 for compatibility with ChiSense-12
  db_version = "2020.1") %>%
  # filter for target child stage <= 59 months
  filter(target_child_age < 60)

# select child-directed utterances only
child_directed <- corpora %>%
  filter(speaker_role != "Target_Child")

columns <- c("id",	"gloss",	"speaker_code",	"speaker_role",	"ambiguous_word",	
             "ambiguous_meaning",	"ambiguous_verb_final_noun")

# take a sample of 40 utterances for each sense of 4 additional target words
# FISH
set.seed(1)
filtered_child_directed <- 
  child_directed %>% 
  select(id, gloss, speaker_code, speaker_role) %>%
  filter(str_detect(gloss, "^fish | fish | fish$")) %>% 
  sample_n(n())

look_up_senses <- tibble(
  id = c(600961, 8709587, 8232147, 
         751164, 8305707, 9492567,
         17037233, 601989, 9649651,
         2117985, 362531, 8251499,
         1096381, 9034395, 742659,
         1192527, 8307471, 1750358,
         10047010, 8078303, 8536234,
         8798882, 1368164, 2453071,
         9649839, 8535549, 2131242, 
         819577, 2303224, 16855735,
         8504366, 571486, 9814572,
         10085572, 729812, 9957181,
         9642461, 2099516, 8184548,
         10014146, 9692810, 10030263,
         8501029, 2131087, 1750358,
         759799, 9031272, 9952293,
         8670370, 16982409, 976871, 
         753760, 841762, 16968728,
         16981975, 8041024, 8798882,
         8184611, 592568, 1765465,
         2816331, 1178721, 16910038, 
         752276, 17059627, 9003383, 
         974770, 8344479, 9295160,
         2522438, 8380841, 1066111, 
         974895, 8849871, 9651329, 
         1078563, 8719912, 8118757, 
         8804764, 8498457, 690509, 
         7938439
  ),
  ambiguous_word = "fish",
  ambiguous_meaning = c("food", "animal", "food", 
                        "animal", "animal", "food",
                        "animal", "food", "food",
                        "animal", "animal", "animal",
                        "animal", "food", "food", 
                        "food", "animal", "animal",
                        "animal", "food", "animal",
                        "food", "animal", "animal",
                        "animal", "food", "animal",
                        "animal", "animal", "animal",
                        "animal", "food", "animal",
                        "animal", "animal", "animal",
                        "animal", "animal", "food",
                        "food", "animal", "animal",
                        "animal", "animal", "animal",
                        "animal", "animal", "animal",
                        "animal", "animal", "food",
                        "food", "animal", "animal",
                        "food", "animal", "food",
                        "food", "animal", "animal",
                        "food", "food", "food", 
                        "food", "food", "food",
                        "food", "food", "food",
                        "food", "food", "food",
                        "food", "food", "food", 
                        "food", "food", "food",
                        "food", "food", "food",
                        "food"
                        
  ), 
  ambiguous_verb_final_noun = NA
)

filtered_child_directed %>%
  left_join(look_up_senses, by = "id") %>% View
  filter(!is.na(ambiguous_word)) %>% 
  distinct(id, .keep_all = TRUE) %>%
  write_csv(file = paste0(chisense12_path, "/fish.csv"))
  
# LAMB
set.seed(1)
filtered_child_directed <- 
child_directed %>% 
  select(id, gloss, speaker_code, speaker_role) %>%
  filter(str_detect(gloss, "^lamb(?:s)? | lamb(?:s)? | lamb(?:s)?$")) %>% 
  sample_n(n())

look_up_senses <- tibble(
  id = c(9945809, 8391856, 2246295,
         1619766, 2603146, 9172584,
         17104116, 1194540, 2761803, 
         10016517, 2673307, 7970018,
         2687744, 2327766, 2642551,
         2188010, 2600005, 8840151,
         2383307, 2619158, 8277614,
         1150131, 2609258, 2392851,
         2377117, 2377728, 9991188,
         1862877, 2630393, 2643804, 
         450040, 9019464, 2664052, 
         9247464, 2187806, 7986687, 
         2187928, 2035872, 2673227,
         2651275, 17009130, 885113, 
         563557, 7874602, 9148776, 
         10074356, 615945, 16892961, 
         9148734, 10096680, 8670555,
         9773596, 2723309, 594853, 
         611702, 2723173, 2723184,
         9149041, 9157517, 1095772, 
         1096084, 1098427, 621042, 
         1175298, 2736173, 1097331, 
         1105095, 1102473, 8792455, 
         621105, 621071, 1099511,
         1172509, 1811732, 2798721,
         1609555, 1175400, 621056, 
         2808159, 621017
  ),
  ambiguous_word = "lamb",
  ambiguous_meaning = c("animal", "animal", "animal",
                        "animal", "animal", "food",
                        "animal", "animal", "food",
                        "animal", "animal", "animal",
                        "animal", "animal", "animal",
                        "animal", "animal", "food",
                        "animal", "animal", "animal",
                        "animal", "animal", "animal",
                        "animal", "animal", "food",
                        "animal", "animal", "animal", 
                        "animal", "animal", "animal", 
                        "animal", "animal", "animal",
                        "animal", "animal", "animal", 
                        "animal", "animal", "animal",
                        "animal", "animal", "food",
                        "food", "food", "food", 
                        "food","food", "food", 
                        "food", "food", "food", 
                        "food", "food", "food", 
                        "food", "food", "food", 
                        "food", "food", "food", 
                        "food", "food", "food", 
                        "food", "food", "food", 
                        "food", "food", "food",
                        "food", "food", "food", 
                        "food", "food", "food", 
                        "food", "food"
                        
                        
  ), 
  ambiguous_verb_final_noun = NA
)


filtered_child_directed %>%
  left_join(look_up_senses, by = "id") %>%
  filter(!is.na(ambiguous_word)) %>% 
  distinct(id, .keep_all = TRUE) %>%
  write_csv(file = paste0(chisense12_path, "/lamb.csv"))
  
# TURKEY
set.seed(1)
filtered_child_directed <- 
  child_directed %>% 
  select(id, gloss, speaker_code, speaker_role) %>%
  filter(str_detect(gloss, "^turkey(?:s)? | turkey(?:s)? | turkey(?:s)?$")) %>% 
  sample_n(n())

look_up_senses <- tibble(
  id = c(9970228, 2515799, 2458722, 
         1689945, 2661299, 2739480, 
         17156824, 16931801, 1099512, 
         17041262, 2723555, 2244817, 
         1700366, 2730139, 9052824,
         2745927, 2798895, 483209, 
         16846029, 905732, 16997660, 
         971809, 1371505, 1056222, 
         16964402, 922375, 715876, 
         2091368, 1371347, 2484048, 
         483272, 2091396, 649791, 
         748684, 1055759, 2719091, 
         9531428, 758401, 2616394, 
         16981401, 17156884, 2515807, 
         16895339, 2162485, 9208869, 
         1370179, 16786352, 2793105,
         2710493, 715888, 17151772,
         1171497, 1698203, 8444420, 
         592946, 8455479, 9603756,
         1596670, 2107281, 17044276, 
         9499136, 1374436, 16819884, 
         1719312, 2096627, 
         9051894, 8946696, 
         600946, 2776763, 2713100,
         2298131, 8760535, 2298141, 
         16786393, 2718819, 9053954, 
         305045, 2089128, 919793,
         1385755
         
         
  ),
  ambiguous_word = "turkey",
  ambiguous_meaning = c("food", "food", "food", 
                        "animal", "food", "animal", 
                        "animal", "food", "food", 
                        "animal", "animal", "animal",
                        "animal", "animal", "food",
                        "animal", "animal", "food", 
                        "animal", "animal", "animal",
                        "food", "food", "animal", 
                        "animal", "food", "animal", 
                        "animal", "animal", "food", 
                        "animal", "animal", "food",
                        "animal", "animal", "animal",
                        "animal", "animal", "food",
                        "food", "animal", "food",
                        "animal", "animal", "animal",
                        "animal", "food", "animal", 
                        "food", "animal", "food",
                        "food", "animal", "animal",
                        "food", "food", "animal", 
                        "animal", "food", "animal",
                        "food", "animal", "food",
                        "animal", "animal", 
                        "food", "food", 
                        "food", "food", "food", 
                        "food", "food", "food", 
                        "food", "food", "food",
                        "food", "food", "food", 
                        "food"
  ), 
  ambiguous_verb_final_noun = NA
)


filtered_child_directed %>%
  left_join(look_up_senses, by = "id") %>%
  filter(!is.na(ambiguous_word)) %>% 
  distinct(id, .keep_all = TRUE) %>%
  write_csv(file = paste0(chisense12_path, "/turkey.csv"))


# CARD 
set.seed(1)
filtered_child_directed <- 
child_directed %>% 
  select(id, gloss, speaker_code, speaker_role) %>%
  filter(str_detect(gloss, "^card(?:s)? | card(?:s)? | card(?:s)?$")) %>% 
  sample_n(n())

look_up_senses <- tibble(
  id = c( 740191, 8779370, 519559, 
          1873365, 8520338, 2208113, 
          732902, 8726612, 8785406, 
          10128587, 8951820, 8930895, 
          8176986, 17031461, 729809, 
          723994, 655583, 2549173, 
          1897502, 652028, 17022663, 
          8871484, 8340919, 10024918, 
          1828063, 946037, 9938356, 
          17051573, 10181785, 17017926,
          1887074, 7936202, 2829674, 
          8514552, 1887093, 652032,
          734127, 8861116, 10128450, 
          2023781, 652562, 636365,
          17025505, 8903848, 733015, 
          17029770, 16788213, 8543179, 
          846156, 8726612, 8659763, 
          8522305, 1795901, 8713958, 
          599501, 8686033, 17166340, 
          8817105, 2237731, 9073011, 
          804084, 9224399, 823490, 
          8686956, 503736, 858105,
          604420, 8894239, 855910, 
          8824500, 9220434, 856695, 
          9967534, 8667572, 8742150, 
          8726069, 8961362, 9013539, 
          8529534, 16961488, 8676142
  ),
  ambiguous_word = "card",
  ambiguous_meaning = c("playing", "note", "note",
                        "note", "note", "note", 
                        "playing", "note", "note", 
                        "playing", "playing", "playing",
                        "playing", "playing", "playing",
                        "playing", "playing", "playing",
                        "playing", "playing", "playing",
                        "playing", "playing", "playing", 
                        "playing", "playing", "playing", 
                        "playing", "playing", "playing",
                        "playing", "playing", "playing", 
                        "playing", "playing", "playing",
                        "playing", "playing", "playing", 
                        "playing", "playing", "playing",
                        "playing", "playing", "playing", 
                        "playing", "playing", "note",
                        "note", "note", "note",
                        "note", "note", "note", 
                        "note", "note", "note", 
                        "note", "note", "note", 
                        "note", "note", "note",
                        "note", "note", "note", 
                        "note", "note", "note", 
                        "note", "note", "note", 
                        "note", "note", "note", 
                        "note", "note", "note", 
                        "note", "note", "note"
                        
  ), 
  ambiguous_verb_final_noun = NA
)


filtered_child_directed %>%
  left_join(look_up_senses, by = "id") %>% 
  filter(!is.na(ambiguous_word)) %>% 
  distinct(id, .keep_all = TRUE) %>% 
  write_csv(file = paste0(chisense12_path, "/card.csv"))


