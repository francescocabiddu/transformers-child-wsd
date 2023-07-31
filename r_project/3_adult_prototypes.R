# preparation of models' prototypes based Spoken BNC adult utterances


# load libraries and user-defined functions
sapply(
  c("requirements.R", "my_funs.R"),
  source
)


# import SpokenBNC --------------------------------------------------------
# import SpokenBNC file

# NOTE. to import the BNC, first use the ImportBNC Jupiter Notebook script on the Python project
spoken_bnc <- read_delim("SpokenBNC.txt", delim = "\t") %>%
  # filter out one row with NA value
  filter(!is.na(hw)) 

# collapse words into sentences for better readability
spoken_bnc_collapsed <- spoken_bnc %>%
  group_by(filename, stext_id, sentence_id) %>%
  summarise(sentence = paste(word, collapse=" ")) %>% 
  ungroup() %>%
  mutate(sentence_id_across = 1:n())

# add sentence_id_across to spoken_bnc
spoken_bnc %<>%
  left_join(spoken_bnc_collapsed %>%
              select(-sentence), by = c("filename", "stext_id", "sentence_id"))


# bat ---------------------------------------------------------------------
bat_sentences_ids <- spoken_bnc %>%
  group_by(filename, stext_id, sentence_id) %>%
  filter(any(word %in% c("bat", "bats"))) %>%
  ungroup() %>% 
  pull(sentence_id_across) %>%
  unique

# list good ids 
bat_ids <- bat_sentences_ids[c(3, 9, 12, 17, 18, 21, 22, 23, 24, 27, 34,
                               35, 36, 37, 39, 40, 41, 42, 43, 44, 46, 48,
                               49, 50, 51, 52, 53, 54, 55, 56, 59, 60, 61,
                               62, 63, 64, 65, 66, 68, 69, 71, 72, 73, 74)]

model_input <- 
  tibble(
  id = bat_ids,
  id_word = c(23, 16, 41, 5, 18, 6, 12, 15, 9, 6, 3, 6, 4, 7, 14, 22, 42, 9, 60, 61,
              6, 9, 24, 23, 10, 14, 41, 21, 15, 6, 19, 5, 5, 5, 3, 6, 7, 27, 4, 21,
              26, 21, 23, 7), 
  gloss = spoken_bnc_collapsed %>%
    filter(sentence_id_across %in% bat_ids) %>%
    arrange(match(sentence_id_across, bat_ids)) %>%
    pull(sentence),
  speaker_code = NA,
  speaker_role = NA,
  ambiguous_word = "bat",
  ambiguous_meaning = c("object", "animal", "object", "animal", "object", "animal",
                        "animal", "animal", "animal", "animal", "object", "object",
                        "object", "object", "object", "object", "object", "object",
                        "object", "object", "object", "object", "object", "object", 
                        "object", "object", "object", "object", "object", "object",
                        "object", "object", "object", "object", "object", "object", 
                        "object", "object", "animal", "animal", "object", "object",
                        "object", "object"
                        ),
  ambiguous_verb_final_noun = NA
)

rm(bat_ids, bat_sentences_ids)

# band --------------------------------------------------------------------
band_sentences_ids <- spoken_bnc %>%
  group_by(filename, stext_id, sentence_id) %>%
  filter(any(word %in% c("band", "bands", "Band", "Bands"))) %>%
  ungroup() %>%
  pull(sentence_id_across) %>%
  unique

band_ids <- band_sentences_ids[c(1, 2, 3, 4, 5, 6, 11, 14, 25, 26, 28, 31,
                                 32, 33, 34, 36, 37, 38, 40, 42, 45, 46, 47,
                                 48, 54, 55, 56, 57, 58, 59, 60, 61, 67, 68,
                                 69, 71, 73, 74, 75, 76, 77, 79, 88, 89, 91,
                                 92, 103, 104, 113, 114, 115, 116, 117, 120,
                                 123, 124, 125, 126, 152, 153, 177, 178, 179,
                                 180, 181, 182, 186, 190, 193, 208, 215, 220,
                                 221, 222, 227, 228, 230, 231, 233, 234)]

model_input %<>%
  rbind(
    tibble(
      id = band_ids,
      id_word = c(34, 61, 127, 237, 9, 55, 11, 80, 9, 45, 15, 3,
                  20, 3, 23, 8, 8, 20, 7, 13, 16, 43, 50, 84, 25, 
                  18, 10, 17, 4, 5, 6, 7, 2, 9, 10, 23, 81, 10, 9,
                  15, 4, 3, 3, 7, 30, 3, 19, 22, 14, 13, 9, 5, 12,
                  18, 10, 15, 35, 5, 6, 3, 12, 32, 24, 6, 6, 9, 10,
                  18, 20, 13, 10, 5, 3, 3, 11, 21, 58, 3, 6, 8), 
      gloss = spoken_bnc_collapsed %>%
        filter(sentence_id_across %in% band_ids) %>%
        arrange(match(sentence_id_across, band_ids)) %>%
        pull(sentence),
      speaker_code = NA,
      speaker_role = NA,
      ambiguous_word = "band",
      ambiguous_meaning = c("music_group", "music_group", "music_group", "music_group", 
                            "music_group", "music_group", "music_group", "object", 
                            "object", "music_group", "music_group", "object", "object",
                            "music_group", "music_group", "music_group", "music_group", 
                            "object", "music_group", "music_group", "music_group", "object",
                            "music_group", "object", "object", "object", "object", "object",
                            "object", "object", "object", "object", "object", "music_group",
                            "music_group", "music_group", "music_group", "music_group",
                            "music_group", "music_group", "music_group", "object",
                            "music_group", "music_group", "music_group", "music_group", 
                            "music_group", "music_group", "music_group", "music_group",
                            "music_group", "music_group", "music_group", "music_group",
                            "music_group", "object", "music_group", "music_group", "object",
                            "object", "object", "object",  "object",  "object",  "object",
                            "object", "object", "object", "object", "object", "object", 
                            "object", "object", "object", "object", "object", "object",
                            "object", "object", "object"
      ),
      ambiguous_verb_final_noun = NA
    )
  )

rm(band_sentences_ids, band_ids)
  

# bow ---------------------------------------------------------------------
bow_sentences_ids <- spoken_bnc %>%
  group_by(filename, stext_id, sentence_id) %>%
  filter(any(word %in% c("bow", "bows", "Bow", "Bows"))) %>%
  ungroup() %>%
  pull(sentence_id_across) %>%
  unique

bow_ids <- bow_sentences_ids[c(4, 6, 7, 8, 9, 16, 21, 24, 26, 27, 33, 37, 39,
                               40, 41, 42, 46, 47, 48, 49, 53, 58, 62, 63, 64,
                               65, 66, 67, 68, 69, 76, 77, 78, 79, 83, 87, 89)]

model_input %<>%
  rbind(
    tibble(
      id = bow_ids,
      id_word = c(22, 68, 17, 25, 39, 9, 12, 10, 22, 10, 1, 14, 13, 13, 12, 7,
                  11, 1, 8, 10, 17, 17, 18, 2, 1, 1, 4, 28, 7, 18, 3, 6, 2, 3,
                  9, 74, 5), 
      gloss = spoken_bnc_collapsed %>%
        filter(sentence_id_across %in% bow_ids) %>%
        arrange(match(sentence_id_across, bow_ids)) %>%
        pull(sentence),
      speaker_code = NA,
      speaker_role = NA,
      ambiguous_word = "bow",
      ambiguous_meaning = c("knot", "knot", "knot", "weapon", "knot", "knot", "knot",
                            "knot", "knot","knot","knot","knot", "knot", "knot", "knot",
                            "knot", "knot", "knot", "knot", "knot", "knot", "knot", "knot",
                            "knot", "knot", "knot", "weapon", "knot", "knot", "knot", "knot",
                            "knot", "knot", "knot",  "knot", "weapon", "knot"
                      
      ),
      ambiguous_verb_final_noun = NA
    )
  ) 

rm(bow_ids, bow_sentences_ids)

# button ------------------------------------------------------------------
button_sentences_ids <- spoken_bnc %>%
  group_by(filename, stext_id, sentence_id) %>%
  filter(any(word %in% c("button", "buttons", "Button", "Buttons"))) %>%
  ungroup() %>%
  pull(sentence_id_across) %>%
  unique

button_ids <- button_sentences_ids[c(1, 2, 3, 4, 6, 7, 8, 9, 19, 20, 21, 22, 23, 24, 25, 26,
                                     27, 28, 29, 44, 75, 76, 77, 80, 81, 82, 83, 84, 85, 86,
                                     87, 88, 89, 90, 91, 93, 94, 96, 98, 99, 100, 102, 113,
                                     116, 117, 118,119, 120, 143, 154, 173, 175, 176, 177,180,
                                     181, 187, 198, 202, 204, 205, 206, 207, 208, 240, 241, 242,
                                     244, 249, 250, 260, 274, 275, 278, 295, 296, 301, 306, 310, 
                                     335)]

model_input %<>%
  rbind(
    tibble(
      id = button_ids,
      id_word = c(10, 2, 22, 9, 5, 2, 1, 1, 81, 9, 105, 39, 51, 29, 60, 9, 20, 73, 150, 37, 30,
                  28, 5, 58, 21, 44, 5, 5, 25, 11, 18, 24, 20, 7, 84, 49, 22, 19, 8, 73, 26, 7,9,
                  11, 21, 8, 5, 16, 6, 11,7, 19, 22, 14, 7, 5,7, 9, 14, 18, 14, 4,13,6,14, 14, 8,
                  7, 12, 11, 4, 2,6, 3, 12, 2, 8, 3, 6, 7), 
      gloss = spoken_bnc_collapsed %>%
        filter(sentence_id_across %in% button_ids) %>%
        arrange(match(sentence_id_across, button_ids)) %>%
        pull(sentence),
      speaker_code = NA,
      speaker_role = NA,
      ambiguous_word = "button",
      ambiguous_meaning = c("clothing", "clothing", "clothing", "tech", "tech", "tech", "tech",
                            "tech", "tech", "tech", "tech", "tech", "tech", "tech", "tech", "tech",
                            "tech", "tech", "tech", "tech", "tech", "tech", "tech", "tech", "tech",
                            "tech","tech","tech","tech", "clothing", "clothing", "clothing", "tech", 
                            "tech","tech","tech","tech","tech","tech","tech", "clothing", "clothing",
                            "tech", "tech", "tech", "tech", "tech", "tech", "clothing", "clothing", 
                            "clothing", "clothing", "clothing", "clothing", "clothing", "clothing",
                            "clothing", "clothing", "clothing", "clothing", "clothing", "clothing",
                            "clothing", "clothing", "clothing", "clothing", "clothing", "clothing", 
                            "clothing", "clothing", "clothing", "clothing", "clothing", "clothing", 
                            "clothing", "clothing", "clothing", "clothing", "clothing", "clothing"
      ),
      ambiguous_verb_final_noun = NA
    )
  )

rm(button_ids, button_sentences_ids)

# card ------------------------------------------------------------------
card_sentences_ids <- spoken_bnc %>% 
  group_by(filename, stext_id, sentence_id) %>%
  filter(any(word %in% c("card", "cards", "Card", "Cards"))) %>%
  ungroup() %>%
  pull(sentence_id_across) %>%
  unique

card_ids <- card_sentences_ids[c(8, 9, 11, 48, 49, 50, 51,63, 64, 89, 90, 99, 100, 101,
                                 102, 124, 125, 126, 134, 135, 136, 139, 155, 156, 210,
                                 231, 236, 283, 290, 293, 295, 305, 306, 307, 308, 309,
                                 319, 320, 324, 345, 346, 348, 350, 351, 373, 374, 388,
                                 389, 390, 403, 404, 406, 409, 413, 417, 422, 426, 430,
                                 431, 432, 438, 460, 467, 468, 469, 548, 597, 598, 599,
                                 600, 601, 603, 604, 605, 606, 616, 617, 628, 646, 647)]

model_input %<>%
  rbind(
    tibble(
      id = card_ids,
      id_word = c(68, 7, 10, 4, 4, 16, 3, 8, 12, 14, 7, 9, 25, 10, 17, 9, 16, 53, 36, 14,
                  9, 5, 28, 27, 12, 22, 6, 15, 19, 23, 19, 21, 6, 16, 14, 13, 11, 5, 6,
                  35, 17, 9, 18, 40, 10, 16, 18, 5, 12, 12, 4, 10, 7, 13, 5, 14, 6, 5, 21,
                  8, 16, 6, 16,28, 11, 3, 4, 5, 9, 4, 3, 4, 10, 6, 4, 7, 16, 3, 11, 11), 
      gloss = spoken_bnc_collapsed %>%
        filter(sentence_id_across %in% card_ids) %>%
        arrange(match(sentence_id_across, card_ids)) %>%
        pull(sentence),
      speaker_code = NA,
      speaker_role = NA,
      ambiguous_word = "card",
      ambiguous_meaning = c("note","note", "playing", "playing", "playing", "playing", 
                            "playing","note","note","note", "playing", "playing", "playing", 
                            "playing", "playing","note","note","note","note","note","note",
                            "note", "note", "note", "playing", "note", "playing", "note", 
                            "note","note","note", "playing", "playing", "playing", "playing", 
                            "playing","note", "playing","note","note","note","note","note",
                            "note", "playing", "playing","note","note","note","note", "playing",
                            "playing", "playing","note", "playing", "playing","note","note",
                            "note", "note", "note", "note", "note", "note", "note", "playing", 
                            "playing", "playing", "playing", "playing", "playing", "playing", 
                            "playing", "playing", "playing", "playing", "playing", "playing", 
                            "playing", "playing"
      ),
      ambiguous_verb_final_noun = NA
    )
  ) 

rm(card_ids, card_sentences_ids)

# chicken ------------------------------------------------------------------
chicken_sentences_ids <- spoken_bnc %>% 
  group_by(filename, stext_id, sentence_id) %>%
  filter(any(word %in% c("chicken", "chickens", "Chicken", "Chickens"))) %>%
  ungroup() %>%
  pull(sentence_id_across) %>%
  unique

chicken_ids <- chicken_sentences_ids[c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,14,15,
                                       16, 17, 18, 19, 20, 21, 22, 23, 33, 35, 37, 50, 51,
                                       64, 65, 67, 68, 69,72, 75, 76,77,80,81,82,83,84,85,
                                       87,88,89,91,92,93,95,96,101,102,103,105,106,107,
                                       108,157,158,159,160,163,187,366,367,368,371,376,
                                       377,435,440,483,484)]

model_input %<>%
  rbind(
    tibble(
      id = chicken_ids,
      id_word = c(20, 4, 5, 4, 7, 5, 11, 9, 20, 7, 10, 5, 21, 1, 17,18, 10, 31, 16, 16,
                  7, 4, 4, 7, 7, 29, 9, 14, 9, 6,11, 10, 3, 4, 14, 1, 16,5, 17,6,1,7,5,
                  11,5,2,7,7,7,7,8,20,87,25,8,1,5,11,3,2,4,8,2,9,12,11,38,7,7,24,9,8,40,
                  16), 
      gloss = spoken_bnc_collapsed %>%
        filter(sentence_id_across %in% chicken_ids) %>%
        arrange(match(sentence_id_across, chicken_ids)) %>%
        pull(sentence),
      speaker_code = NA,
      speaker_role = NA,
      ambiguous_word = "chicken",
      ambiguous_meaning = c("animal", "animal", "animal", "animal", "animal", "food", 
                            "food", "animal", "animal", "animal", "animal", "animal", 
                            "animal","food","food","food","food", "animal", "animal",
                            "food","food","food","food", "animal","food", "animal", 
                            "animal", "animal","food","food","food", "food", "food", 
                            "food","food","food", "animal","food","food","food","food",
                            "food","food","food","food","food","food", "food", "food", 
                            "food","food","food","food","food","food","food","food",
                            "food", "animal", "animal", "animal", "animal", "animal", 
                            "animal","animal","animal","animal","animal","animal","animal",
                            "animal","animal","animal","animal"
      ),
      ambiguous_verb_final_noun = NA
    )
  ) 
  
rm(chicken_ids, chicken_sentences_ids)

# fish ------------------------------------------------------------------
fish_sentences_ids <- spoken_bnc %>% 
  group_by(filename, stext_id, sentence_id) %>%
  filter(any(word %in% c("fish", "fishes", "Fish", "Fishes"))) %>%
  ungroup() %>%
  pull(sentence_id_across) %>%
  unique

fish_ids <- fish_sentences_ids[c(1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 15, 16, 17, 18, 21,22,
                                 34, 35, 36, 39,40, 41, 43, 44, 45, 47, 48,49, 50,52, 53,
                                 59, 60, 63, 67, 68, 71, 75, 76, 77, 85, 95,96, 97, 98, 99,
                                 100, 101, 102, 122, 123, 132, 133, 134, 135, 143, 145, 148,
                                 161, 163, 164, 165, 170, 171, 172, 173, 174, 176, 177, 178,
                                 181, 183, 187, 188, 191, 192, 197, 198, 199, 293)]

model_input %<>%
  rbind(
    tibble(
      id = fish_ids,
      id_word = c(5, 9, 18, 39, 4, 334, 1, 4, 26, 14, 17, 21, 7, 5, 30, 46, 18, 5, 2, 9,
                  8, 6, 1, 9, 13, 5, 18, 23, 8, 19, 17,14, 24, 17, 31, 3, 10, 8,32, 17,
                  94, 2, 14,16, 9, 5, 6, 3, 3, 10, 9, 6, 38, 18, 8, 10, 57, 23, 12, 23,
                  34, 3, 3, 3, 9, 3, 7, 8, 20, 2, 39, 45, 21, 5, 17,5, 6, 6, 6, 3), 
      gloss = spoken_bnc_collapsed %>%
        filter(sentence_id_across %in% fish_ids) %>%
        arrange(match(sentence_id_across, fish_ids)) %>%
        pull(sentence),
      speaker_code = NA,
      speaker_role = NA,
      ambiguous_word = "fish",
      ambiguous_meaning = c("animal", "food", "food", "animal", "animal", "food", "food", 
                            "animal", "animal","animal","animal","animal","animal","animal",
                            "food","food","food","animal","food","food","food","food","food",
                            "food", "food", "food","food","food","food","food","food","food",
                            "food","food","animal","animal","animal","animal","animal","animal",
                            "animal","animal","animal","animal","animal","food","food","food",
                            "animal","animal","animal","animal","food","animal","animal","animal",
                            "animal", "animal", "animal", "animal","food","food","food","food", 
                            "animal","food", "animal", "animal","food","food","food", "animal",
                            "food","animal","animal","food","food","food","food","animal"
      ),
      ambiguous_verb_final_noun = NA
    )
  ) 

rm(fish_ids, fish_sentences_ids)

# glass ------------------------------------------------------------------
glass_sentences_ids <- spoken_bnc %>% 
  group_by(filename, stext_id, sentence_id) %>%
  filter(any(word %in% c("glass", "glasses", "Glass", "Glasses"))) %>%
  ungroup() %>%
  pull(sentence_id_across) %>%
  unique

glass_ids <- glass_sentences_ids[c(6, 7, 8, 14, 25, 26, 27, 28, 44, 45, 46, 48, 49, 51,
                                   57, 59, 60, 61, 63, 82, 85, 102, 103, 106, 110, 117, 
                                   133, 140, 143, 146, 147, 155, 174, 181, 182, 191, 196,
                                   200, 213, 225, 238, 252, 254, 265, 271, 272, 273, 274,
                                   275, 276, 281,285, 292, 294, 300, 304, 305, 308, 309,
                                   311, 312, 317, 318, 329, 330, 333, 335, 336, 337, 339,
                                   343, 346, 347, 349, 353, 356, 361, 362, 372, 373)]

model_input %<>%
  rbind(
    tibble(
      id = glass_ids,
      id_word = c(7, 5, 2, 8, 2,2, 1, 10, 11, 5, 4, 1, 12, 9, 36, 15, 32, 24, 5, 28,22,
                  21, 61, 18, 55, 31, 9, 14, 7, 6, 15, 5, 51, 12, 23, 13, 5, 4, 6, 7, 
                  11, 10, 16, 8, 5, 10, 9, 8, 5, 9, 9, 20, 6, 12, 3, 8, 8, 14, 3, 12, 3,
                  6, 5, 8, 21, 10, 3, 5, 5, 5, 8, 5, 11, 5, 5,7, 15, 4, 6, 13), 
      gloss = spoken_bnc_collapsed %>%
        filter(sentence_id_across %in% glass_ids) %>%
        arrange(match(sentence_id_across, glass_ids)) %>%
        pull(sentence),
      speaker_code = NA,
      speaker_role = NA,
      ambiguous_word = "glasses",
      ambiguous_meaning = c("drinking","drinking","drinking","drinking", "eye", "eye", 
                            "eye","eye","eye","eye","eye","drinking","eye","eye","eye",
                            "eye","drinking","drinking","eye","drinking","eye","eye",
                            "drinking","drinking","drinking","drinking","drinking","eye",
                            "eye","eye","eye","eye","eye","eye","drinking","drinking",
                            "eye", "eye", "eye", "eye", "eye", "eye", "eye", "eye",
                            "drinking", "drinking", "drinking", "drinking", "eye", 
                            "drinking", "eye", "drinking", "eye", "drinking", "eye", 
                            "drinking", "drinking", "eye", "eye", "eye", "eye", "eye", 
                            "eye", "drinking", "drinking", "drinking", "eye", "drinking", 
                            "drinking","drinking","drinking","drinking","drinking",
                            "drinking","drinking","drinking","drinking","drinking",
                            "drinking","drinking"
      ),
      ambiguous_verb_final_noun = NA
    )
  )  

rm(glass_ids, glass_sentences_ids)

# lamb ------------------------------------------------------------------
lamb_sentences_ids <- spoken_bnc %>% 
  group_by(filename, stext_id, sentence_id) %>%
  filter(any(word %in% c("lamb", "lambs", "Lamb", "Lambs"))) %>%
  ungroup() %>%
  pull(sentence_id_across) %>%
  unique

lamb_ids <- lamb_sentences_ids[c(2, 6, 7, 8,9,10,11,13,16,24,25,26,27,28,29,32,36,39,40,41,
                                 42,43,44,45,46,48,49,50,55,58,59,63,64,65,68,69,70,71,72,
                                 73,74,75,76,77,79,80,84,86,88,90,91,92,93,94,95,96,98,99,
                                 100,101,103,126,134,140)]

model_input %<>%
  rbind(
    tibble(
      id = lamb_ids,
      id_word = c(114, 9, 10,12, 10,6,5,35,49,19,52,9,33,21,13,32,20,9,14,12,17,10,3,9,5,2,
                  5,7,5,3,8,9,18,36,8,6,5,5,15,5,8,3,5,6,20,13,25,6,9,5,7,9,33,16,5,5,9,6,
                  3,5,9,7,3,12), 
      gloss = spoken_bnc_collapsed %>%
        filter(sentence_id_across %in% lamb_ids) %>%
        arrange(match(sentence_id_across, lamb_ids)) %>%
        pull(sentence),
      speaker_code = NA,
      speaker_role = NA,
      ambiguous_word = "lamb",
      ambiguous_meaning = c("animal","animal","animal","food","food","food","food",
                            "animal","animal","animal","food","food","animal","food",
                            "animal","food","food","animal","animal","food","food",
                            "food","food","food","food","animal","animal","animal","food",
                            "food","food","food","food","food","animal","animal","animal",
                            "animal","animal","animal","animal","animal","food","food",
                            "food","food","food","food","food","food","food","food","food",
                            "food","food","food","food","food","food","food","food",
                            "animal","animal","animal"
      ),
      ambiguous_verb_final_noun = NA
    )
  )

rm(lamb_ids, lamb_sentences_ids)

# letter ------------------------------------------------------------------
letter_sentences_ids <- spoken_bnc %>% 
  group_by(filename, stext_id, sentence_id) %>%
  filter(any(word %in% c("letter", "letters", "Letter", "Letters"))) %>%
  ungroup() %>%
  pull(sentence_id_across) %>%
  unique

letter_ids <- letter_sentences_ids[c(1,2,3,4,5,6,8,9,10,12,13,14,15,16,18,19,20,22,23,24,
                                     26,27,31,34,35,38,39,40,41,42,51,52,54,55,56,57,58,59,
                                     61,64,66,67,71,72,73,78,117,121,122,123,131,132,133,134,
                                     135,136,137,138,139,140,141,142,143,145,146,147,148,
                                     150,151,152,153,154,155,156,200,213,301,302,303,312)]

model_input %<>%
  rbind(
    tibble(
      id = letter_ids,
      id_word = c(17,9,6,5,4,4,12,10,16,13,6,7,12,39,80,5,6,2,15,6,14,3,2,6,3,9,5,38,42,76,
                  4,7,146,33,19,6,36,8,5,48,17,37,42,72,16,11,3,5,12,3,7,6,2,2,7,7,3,15,16,
                  6,2,2,8,7,11,18,26,4,56,16,6,10,7,15,34,7,22,23,38,4), 
      gloss = spoken_bnc_collapsed %>%
        filter(sentence_id_across %in% letter_ids) %>%
        arrange(match(sentence_id_across, letter_ids)) %>%
        pull(sentence),
      speaker_code = NA,
      speaker_role = NA,
      ambiguous_word = "letter",
      ambiguous_meaning = c("alphabet","alphabet","mail","mail","mail","mail","mail","mail",
                            "mail","mail","mail","mail","mail","mail","mail","mail","mail",
                            "mail","mail","mail","mail","mail","mail","mail","mail","mail",
                            "mail","mail","mail","mail","mail","mail","mail","mail","mail",
                            "mail","alphabet","mail","mail","mail","alphabet","alphabet",
                            "mail","mail","mail","alphabet","alphabet","alphabet","alphabet",
                            "alphabet","alphabet","alphabet","alphabet","alphabet","alphabet",
                            "alphabet","alphabet","alphabet","alphabet","alphabet","alphabet",
                            "alphabet","alphabet","alphabet","alphabet","alphabet","alphabet",
                            "alphabet", "alphabet", "alphabet","alphabet","alphabet",
                            "alphabet","alphabet","alphabet","alphabet","alphabet","alphabet",
                            "alphabet","alphabet"
      ),
      ambiguous_verb_final_noun = NA
    )
  )

rm(letter_ids, letter_sentences_ids)

# line ------------------------------------------------------------------
line_sentences_ids <- spoken_bnc %>% 
  group_by(filename, stext_id, sentence_id) %>%
  filter(any(word %in% c("line", "lines", "Line", "Lines"))) %>%
  ungroup() %>%
  pull(sentence_id_across) %>%
  unique

line_ids <- line_sentences_ids[c(1,16,17,18,19,20,21,22,23,27,40,51,55,57,58,59,63,67,
                                 72,73,74,75,76,77,78,79,87,117,118,119,120,121,122,123,
                                 125,126,127,128,129,133,134,135,136,137,138,139,141,142,
                                 143,159,161,162,163,164,165,168,172,181,183,185,198,200,
                                 201,254,255,1342,1343,292,294,353,430,471,697,843,1255,
                                 1537,1585,1652,1653,1773)]

model_input %<>%
  rbind(
    tibble(
      id = line_ids,
      id_word = c(14,3,6,4,14,15,8,9,8,21,17,10,24,17,5,6,21,23,17,7,9,16,9,14,17,9,6,10,
                  38,11,8,12,16,16,8,8,7,15,5,4,11,10,5,15,7,5,6,10,18,7,15,17,26,10,4,15,
                  10,3,14,31,17,26,18,7,14,7,3,20,9,8,13,15,21,8,5,5,8,7,41,8), 
      gloss = spoken_bnc_collapsed %>%
        filter(sentence_id_across %in% line_ids) %>%
        arrange(match(sentence_id_across, line_ids)) %>%
        pull(sentence),
      speaker_code = NA,
      speaker_role = NA,
      ambiguous_word = "line",
      ambiguous_meaning = c("geometry","geometry","geometry","geometry","geometry",
                            "geometry","geometry","geometry","geometry","geometry",
                            "geometry","order","order","order","order","order","geometry",
                            "geometry","geometry","order","order","order","order","order",
                            "geometry","order","order","geometry","order","geometry",
                            "geometry","geometry","geometry","geometry","geometry",
                            "geometry","geometry","order","order","order","geometry",
                            "geometry","geometry","geometry","geometry","geometry",
                            "geometry","geometry","geometry","geometry","geometry",
                            "geometry","geometry","geometry","geometry","order","order",
                            "order","order","geometry","order","order","order","order",
                            "order","order","order","order","order","order","order","order",
                            "order","order","order","order","order","order","order","order"
                            
      ),
      ambiguous_verb_final_noun = NA
    )
  )

rm(line_ids, line_sentences_ids)

# nail ------------------------------------------------------------------
nail_sentences_ids <- spoken_bnc %>%
  group_by(filename, stext_id, sentence_id) %>%
  filter(any(word %in% c("nail", "nails", "Nail", "Nails"))) %>%
  ungroup() %>%
  pull(sentence_id_across) %>%
  unique

nail_ids <- nail_sentences_ids[c(2,3,5,6,7,11,12,13,14,31,32,33,36,37,39,40,41,43,46,48,
                                 61,62,64,65,68,69,70,71,72,74,80,81,82,83,84,85,86,87,88,
                                 90,91,92,93,94,95,96,97,98,108,109,110,111,113,115,116,
                                 119,120,121,129,131,135,136,137,138,140,142,147,149,153,
                                 154,155,156,157,158,159,160,161,162,163,164)]

model_input %<>%
  rbind(
    tibble(
      id = nail_ids,
      id_word = c(61,7,46,8,19,9,15,5,7,37,15,32,28,69,52,12,3,5,4,10,11,47,3,5,19,16,23,
                  12,5,24,4,5,5,7,6,7,5,5,6,4,10,4,3,4,8,14,5,9,12,4,12,7,13,30,3,14,16,
                  7,14,10,9,5,2,6,3,15,6,6,12,2,8,55,12,19,10,32,4,9,28,56), 
      gloss = spoken_bnc_collapsed %>%
        filter(sentence_id_across %in% nail_ids) %>%
        arrange(match(sentence_id_across, nail_ids)) %>%
        pull(sentence),
      speaker_code = NA,
      speaker_role = NA,
      ambiguous_word = "nail",
      ambiguous_meaning = c("object","object","body_part","body_part","body_part",
                            "body_part","body_part","body_part","body_part","object",
                            "object","object","body_part","object","object","object",
                            "object","body_part","object","object","object","object",
                            "body_part","object","body_part","object","object","object",
                            "body_part","object","body_part","body_part","body_part",
                            "body_part","body_part","body_part","body_part","body_part",
                            "body_part","body_part","body_part","body_part","object",
                            "body_part","body_part","object","object","object","object",
                            "object","object","object","body_part","body_part","body_part",
                            "body_part","body_part","body_part","body_part","body_part",
                            "body_part","body_part","body_part","body_part","body_part",
                            "body_part","object","object","object","object","object",
                            "object","object","object","object","object","object","object",
                            "object","object"
                            
      ),
      ambiguous_verb_final_noun = NA
    )
  )

rm(nail_ids, nail_sentences_ids)

# save input for LLMs ------------------------------------------------------------------
# transform glosses to lowercase
model_input %<>%
  mutate(gloss = tolower(gloss)) 

# reduce words in very long utterances to avoid max token length in some LLMs
# make utterances max 81 words long
# the reduction only affects 52/859=6% of utterances
model_input %<>%
  rowwise %>%
  mutate(id_word_updated = gloss %>%
           str_split(" ") %>%
           sapply(reduce_string_tokens, min_length_vector = 81, target_index = id_word,
                  n_elements_to_add = 40, return_vector = FALSE),
         gloss_updated = gloss %>%
           str_split(" ") %>%
           sapply(reduce_string_tokens, min_length_vector = 81, target_index = id_word,
                  n_elements_to_add = 40, return_vector = TRUE)) %>% 
  ungroup %>%
  mutate(compare_gloss = gloss == gloss_updated) %>%
  select(-c(id_word, gloss)) %>%
  rename(gloss = gloss_updated,
         id_word = id_word_updated)

# remove leading spaces before apostrophes and adjust target word id position
model_input %<>%
  rowwise %>%
  mutate(gloss_apostrophe = gloss %>%
           adjust_apostrophe(id_word),
         id_word_apostrophe = gloss %>%
           adjust_apostrophe(id_word, print_sentence = FALSE)) %>%
  ungroup %>%
  select(-c(id_word, gloss)) %>%
  rename(gloss = gloss_apostrophe,
         id_word = id_word_apostrophe) %>%
  # also correct orthographic mistakes that trigger transfo-xl-wt103 model
  mutate(gloss = gloss %>%
           str_replace_all("elses'", "else's")) %>%
  mutate(gloss = gloss %>%
           str_remove_all("\\."))
  
# final check that id_word positions are correct
# it should only return target words in singular or plural form
model_input %>%
  mutate(gloss_split = strsplit(gloss, " ")) %>%
  rowwise() %>% 
  mutate(word_at_id = gloss_split[id_word]) %>%
  ungroup() %>%
  pull(word_at_id) %>%
  unique

# change word position to be compatible with Python indexing
model_input %<>%
  mutate(id_word_python = id_word - 1)

model_input %>%
  group_split(ambiguous_word) %>% 
  lapply(function(sub_df) {
    ambiguous_word <- sub_df$ambiguous_word[1]
    
    write.table(sub_df %>%
                  select(id_word_python, gloss), file = getwd() %>%
                  paste0("/SpokenBNC_for_nlm/", ambiguous_word, "/", "train.data.txt"), 
                sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)
  })

# add classes_map to model_input
model_input %<>%
  mutate(classes_map = case_when(
    ambiguous_word == "band" & ambiguous_meaning == "music_group" ~ 0,
    ambiguous_word == "band" ~ 1,
    ambiguous_word == "bat" & ambiguous_meaning == "object" ~ 0,
    ambiguous_word == "bat" ~ 1,
    ambiguous_word == "bow" & ambiguous_meaning == "weapon" ~ 0, 
    ambiguous_word == "bow" ~ 1,
    ambiguous_word == "button" & ambiguous_meaning == "clothing" ~ 0,
    ambiguous_word == "button" ~ 1, 
    ambiguous_word == "card" & ambiguous_meaning == "note" ~ 0,
    ambiguous_word == "card" ~ 1,
    ambiguous_word == "chicken" & ambiguous_meaning == "food" ~ 0,
    ambiguous_word == "chicken" ~ 1,
    ambiguous_word == "fish" & ambiguous_meaning == "food" ~ 0,
    ambiguous_word == "fish" ~ 1,
    ambiguous_word == "glasses" & ambiguous_meaning == "drinking" ~ 0,
    ambiguous_word == "glasses" ~ 1,
    ambiguous_word == "lamb" & ambiguous_meaning == "food" ~ 0,
    ambiguous_word == "lamb" ~ 1,
    ambiguous_word == "letter" & ambiguous_meaning == "mail" ~ 0,
    ambiguous_word == "letter" ~ 1,
    ambiguous_word == "line" & ambiguous_meaning == "order" ~ 0,
    ambiguous_word == "line" ~ 1,
    ambiguous_word == "nail" & ambiguous_meaning == "object" ~ 0,
    ambiguous_word == "nail" ~ 1
  ))

# save classes_map to input files
model_input %>%
  group_split(ambiguous_word) %>% 
  lapply(function(sub_df) {
    ambiguous_word <- sub_df$ambiguous_word[1]
    
    write.table(sub_df %>%
                  select(classes_map), file = getwd() %>%
                  paste0("/SpokenBNC_for_nlm/", ambiguous_word, "/", "train.gold.txt"), 
                sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)
  })

# look at the distribution of sense frequencies
model_input %>%
  group_by(ambiguous_word, ambiguous_meaning) %>%
  summarise(n = n()) %>%
  ungroup %>% 
  write_csv("sense_frequencies_adults.csv")
