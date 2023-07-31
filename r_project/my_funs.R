# miscellaneous of user-defined functions


import_target <- function(target_label) {
  read_csv(
    paste0(chisense12_path, paste0("/", target_label, ".csv"))
  ) %>%
    filter(!is.na(ambiguous_meaning)) %>%
    mutate(ambiguous_meaning = str_replace_all(ambiguous_meaning, " ", "_")) %>%
    # change compound symbol from _ to -
    mutate(gloss = str_replace_all(gloss, "_|\\+", "-")) %>%
    # gloss to lowercase
    mutate(gloss = tolower(gloss))
}

map_classes <- function(target_df) {
  amb_word <- target_df$ambiguous_word[1]
  
  if (amb_word == "card") {
    tibble(ambiguous_word = "card",
           ambiguous_meaning = c("playing", "note"),
           value = c(1, 0))
  } else if (amb_word == "fish") {
    tibble(ambiguous_word = "fish",
           ambiguous_meaning = c("animal", "food"),
           value = c(1, 0))
  } else if (amb_word == "lamb") {
    tibble(ambiguous_word = "lamb",
           ambiguous_meaning = c("animal", "food"),
           value = c(1, 0))
  } else if (amb_word == "turkey") {
    tibble(ambiguous_word = "turkey",
           ambiguous_meaning = c("animal", "food"),
           value = c(1, 0))
  } else {
    target_df %>%
      group_by(ambiguous_word, ambiguous_meaning) %>%
      summarise(n = n()) %>%
      ungroup %>%
      arrange(desc(n)) %>%
      filter(row_number() %in% 1:2) %>%
      mutate(n = c(1, 0)) %>%
      rename(value = n)
  }
}

create_training <- function(target_df, target_label) {
  target_df %>%
    left_join(., classes_map, by = c("ambiguous_word", "ambiguous_meaning")) %>%
    filter(!is.na(value)) %>%
    mutate(id_target = gloss %>%
             tokenize_words %>%
             sapply(function(x) {
               if (target_label == "glasses") {
                 which(str_detect(x, "glass")) - 1 ##
               } else {
                 which(str_detect(x, target_label)) - 1 ##
               }
             }))
}

resolve_duplicate_targets <- function(train_gold_df, resolve_df, target_label) {
  correct_pos <- train_gold_df %>%
    mutate(len_id_target = sapply(id_target, function(x) {
      length(x) > 1
    })) %>% 
    filter(len_id_target == TRUE)  %>% #View
    #select(gloss, id_target) %>% View
    select(id) %>%
    mutate(id_target = resolve_df %>%
             filter(target == target_label) %>% ##
             pull(position) %>%
             {. - 1})
  
  for (i in seq_along(correct_pos$id)) {
    train_gold_df$id_target[which(train_gold_df$id == correct_pos$id[i])] <- 
      correct_pos$id_target[i]
  }
  
  train_gold_df %>%
    mutate(id_target = unlist(id_target)) 
}

save_training <- function(target_label) {
  # save mappins
  write_lines(
    paste0('{"0": "', 
           classes_map %>%
             unite(class, c("ambiguous_word", "ambiguous_meaning")) %>%
             filter(value == 0) %>%
             pull(class),
           '", "1": "', 
           classes_map %>%
             unite(class, c("ambiguous_word", "ambiguous_meaning")) %>%
             filter(value == 1) %>%
             pull(class),
           '"}'),
    file = paste0(getwd(), paste0("/ChiSense-12_for_nlm/", target_label, "/classes_map.txt")) ##
  )
  
  # save training data
  train_gold %>%
    mutate(gloss = gloss %>%
             # tokenize to be sure position of target march id_target
             tokenize_words %>%
             sapply(paste, collapse = " ")) %>%
    select(id_target, gloss) %>%
    write_delim(file = paste0(getwd(), "/ChiSense-12_for_nlm/", 
                              target_label, "/train.data.txt"), ##
                delim = "\t", col_names = FALSE)
  
  # save gold data
  train_gold %>%
    pull(value) %>%
    write_lines(file = paste0(getwd(), "/ChiSense-12_for_nlm/", 
                              target_label, "/train.gold.txt")) ##
  
}

reduce_string_tokens <- function(string_vector, min_length_vector, 
                                 target_index, n_elements_to_add, 
                                 return_vector = TRUE) {
  #' This function reduces the number of words in a string vector around a target index.
  #'
  #' @param string_vector A vector of strings to be reduced.
  #' @param min_length_vector The minimum length for the vector. If the length of string_vector is less/equal than this, the function will return the original vector collapsed into a string.
  #' @param target_index The index in the string vector around which to reduce the number of words.
  #' @param n_elements_to_add The number of elements to add on each side of the target index after reducing.
  #' @param return_vector A boolean that indicates whether to return the (collapsed) string vector (TRUE) or the target index (FALSE).
  #' 
  #' @return If return_vector = TRUE, a string vector that has been reduced to string, around the target index.
  #'         If return_vector = FALSE, the updated target index.
  
  # If the vector is already shorter/equal than the minimum length, 
  # return the original vector or the target index.
  if (length(string_vector) <= min_length_vector) {
    if (return_vector == TRUE) {
      string_vector %>% paste0(collapse = " ")
    } else {
      target_index
    }
  } else {
    # Calculate how many elements are before and after the target index.
    elements_before_target <- target_index - 1
    elements_after_target <- length(string_vector) - target_index
    
    # Determine how many elements to add on each side of the target index.
    elements_to_add_right <- min(n_elements_to_add, elements_after_target)
    elements_to_add_left <- min(n_elements_to_add, elements_before_target)
    
    # If there are not enough elements to add on one side, 
    # try to add the deficit to the other side.
    if ((n_elements_to_add-elements_to_add_right) > 0) {
      elements_to_add_left <- elements_to_add_left + 
        (n_elements_to_add-elements_to_add_right)
    } else if ((n_elements_to_add-elements_to_add_left) > 0) {
      elements_to_add_right <- elements_to_add_right + 
        (n_elements_to_add-elements_to_add_left)
    }
    
    # Determine the start and end indices of the reduced vector.
    start_index <- target_index - elements_to_add_left
    end_index <- target_index + elements_to_add_right
    
    # Subset the vector to get the reduced vector.
    subset_vector <- string_vector[start_index:end_index]
    
    # Recalculate the target index relative to the reduced vector.
    target_index <- target_index - start_index + 1
    
    # Return either the reduced vector or the updated target index.
    if (return_vector == TRUE) {
      subset_vector %>% paste0(collapse = " ")
    } else {
      target_index
    }
  }
}

adjust_apostrophe <- function(my_gloss, my_word_id, print_sentence = TRUE) {
  
  # Split the given string (my_gloss) into words, count up to the word at the position of my_word_id,
  # and calculate the number of occurrences of apostrophes in this subset.
  number_of_apostrophes <- my_gloss %>%
    str_split(" ") %>%                  # Split the string into words
    {.[[1]][1:(my_word_id-1)]} %>%          # Select words up to the position my_word_id
    {if(str_detect(.[1], "^'")) .[-1] else .} %>% # If first word starts with an apostrophe, exclude it
    {str_detect(., "^'|n't") %>% sum}        # Detect and count the number of apostrophes
  
  # If print_sentence is TRUE, return the adjusted sentence where all the misplaced spaces before apostrophes are removed
  # If print_sentence is FALSE, return the adjusted position of the specific word, subtracting the count of apostrophes from the original position
  if (print_sentence) {
    my_gloss %>%
      str_replace_all(" '", "'")  %>%   # Remove all spaces before apostrophes in the string
      str_replace_all(" n't", "n't")
  } else {
    my_word_id - number_of_apostrophes  # Return the adjusted position of the word by subtracting the number of apostrophes
  }
}

