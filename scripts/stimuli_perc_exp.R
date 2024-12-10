library(here)

parentfolder <- dirname(getwd())

dataset       <- paste0(parentfolder, '/dataset/')
scripts       <- paste0(parentfolder, '/scripts/')

library(tidyverse) # includes readr, tidyr, dplyr, ggplot2
library(stringr)
library(readxl)

# Load data ----
df <- read_csv(paste0(dataset, "similarity_df_final.csv"))
# Load concept list
concepts <- read_excel(paste0(dataset, "conceptlist_info.xlsx"))

# Filter ----
# Modify the modality column, filter only multimodal and where sessionID ends with '1'
df <- df %>%
  mutate(
    modality = case_when(
      modality == "combinatie" ~ "combined",
      modality == "gebaren" ~ "gesture",
      modality == "geluiden" ~ "vocal",
      TRUE ~ modality
    )
  ) %>%
  filter(modality == "combined") %>%
  filter(str_ends(sessionID, "1")) %>%
  rename(participant_dyad = participant) %>%
  rename(participant_ID = pcnID) %>%
  rename(concept = English) %>%
  select(-`...1`) %>%  # Remove the first column
  rename(stimulus = word)

# Reorder the columns in the specified order
df <- df %>%
  select(trial_order, trial_type, 
         dyad, participant_dyad, participant_ID, exp_part, modality, 
         expressibility_dutch, concept, correction,
         guess_binary, cosine_similarity, stimulus, answer, 
         SemanticSubcat, sessionID)

# Only keep target trials
df <- df %>%
  filter(trial_type == "target")%>%
  select(-`trial_type`) # Remove trial_type columns

# Add guessing performance
## Calculate performance by dyad and add it as a new column
df <- df %>%
  group_by(dyad) %>%
  mutate(
    perf_dyad = (sum(guess_binary == 1) / n()) * 100
  ) %>%
  ungroup()

## Calculate performance by participant within dyad and add it as a new column
df <- df %>%
  group_by(dyad, participant_dyad) %>%
  mutate(
    perf_participant_dyad = (sum(guess_binary == 1) / n()) * 100
  ) %>%
  ungroup()

## Calculate performance by participant
df <- df %>%
  group_by(participant_ID) %>%
  mutate(
    perf_participant_ID = (sum(guess_binary == 1) / n()) * 100
  ) %>%
  ungroup()

# Calculate mean/median cosine similarity for each participant
df <- df %>%
  group_by(participant_ID) %>%
  mutate(
    mean_cosine_similarity = mean(cosine_similarity, na.rm = TRUE),  # Replace with median() if needed
    median_cosine_similarity = median(cosine_similarity, na.rm = TRUE)  # Optional: include both metrics
  ) %>%
  ungroup()

# Sort by optimal and suboptimal
df_best <- df %>%
  filter(guess_binary == 1)
df_worst <- df %>%
  filter(guess_binary == 0)

# Frequencies ----
# Generate a frequency table for the 'concept' column
df_best %>%
  group_by(concept) %>%
  summarise(frequency = n()) %>%
  arrange(desc(frequency)) %>% 
  print(n = 100)
## 72 out of 84
df_worst %>%
  group_by(concept) %>%
  summarise(frequency = n()) %>%
  arrange(desc(frequency)) %>% 
  print(n = 100)
## 81 out of 84

# Best of best ----
# Identify the best-performing dyad and participant for each unique concept
best_of_best <- df_best %>%
  group_by(concept) %>%  # Group by unique concepts
  filter(
    perf_dyad == max(perf_dyad)  # Retain rows with the best-performing dyad
  ) %>%
  filter(
    perf_participant_ID == max(perf_participant_ID) 
  ) %>%
  filter(
    mean_cosine_similarity == max(mean_cosine_similarity, na.rm = TRUE) 
  ) %>%
  ungroup()
  
# Worst of worst ----
# Identify the worst-performing dyad and participant for each unique concept
worst_of_worst <- df_worst %>%
  group_by(concept) %>%  # Group by unique concepts
  filter(
    cosine_similarity == min(cosine_similarity, na.rm = TRUE)  # Retain rows with the lowest cosine similarity
  ) %>%
  filter(
    perf_dyad == min(perf_dyad)  # Among those, retain rows with the worst-performing dyad
  ) %>%
  filter(
    perf_participant_ID == min(perf_participant_ID)
  ) %>%
  ungroup()

# Check repetitions and missing concepts ----
best_of_best %>%
  group_by(concept) %>%
  summarise(row_count = n()) %>%
  mutate(type = ifelse(row_count > 1, "repeated", "single")) %>%
  summarise(
    total_repeated = sum(type == "repeated"),
    total_single = sum(type == "single")
  )
setdiff(unique(trimws(tolower(df$concept))), unique(trimws(tolower(df_best$concept))))

worst_of_worst %>%
  group_by(concept) %>%
  summarise(row_count = n()) %>%
  mutate(type = ifelse(row_count > 1, "repeated", "single")) %>%
  summarise(
    total_repeated = sum(type == "repeated"),
    total_single = sum(type == "single") )
setdiff(unique(trimws(tolower(df$concept))), unique(trimws(tolower(df_worst$concept))))

# Find missing ----
# List of concepts missing from best_of_best
missing_from_best <- setdiff(unique(trimws(tolower(df$concept))), unique(trimws(tolower(df_best$concept))))

# Filter df for the missing concepts and extract rows with the highest cosine_similarity
missing_best_concepts <- df %>%
  filter(trimws(tolower(concept)) %in% missing_from_best) %>%
  group_by(concept) %>%
  filter(cosine_similarity == max(cosine_similarity, na.rm = TRUE)) %>%
  filter(
    perf_dyad == max(perf_dyad)  # Retain rows with the best-performing dyad
  ) %>%
  filter(
    perf_participant_ID == max(perf_participant_ID) 
  ) %>%
  filter(
    mean_cosine_similarity == max(mean_cosine_similarity, na.rm = TRUE) 
  ) %>%
  ungroup()


# List of concepts missing from worst_of_worst
missing_from_worst <- setdiff(unique(trimws(tolower(df$concept))), unique(trimws(tolower(df_worst$concept))))

# Filter df for the missing concepts and extract rows with the highest cosine_similarity
missing_worst_concepts <- df %>%
  filter(trimws(tolower(concept)) %in% missing_from_worst) %>%
  group_by(concept) %>%
  filter(cosine_similarity == min(cosine_similarity, na.rm = TRUE)) %>%
  filter(
    perf_dyad == min(perf_dyad)  # Retain rows with the best-performing dyad
  ) %>%
  filter(
    perf_participant_ID == min(perf_participant_ID) 
  ) %>%
  filter(
    mean_cosine_similarity == min(mean_cosine_similarity, na.rm = TRUE) 
  ) %>%
  ungroup()

# Combine data frames ----

# Combine best_of_best with missing_best_concepts
the_best <- bind_rows(best_of_best, missing_best_concepts)
write.csv(the_best, paste0(dataset, "the_best.csv"), row.names = FALSE)

# Combine worst_of_worst with missing_worst_concepts
the_worst <- bind_rows(worst_of_worst, missing_worst_concepts)
write.csv(the_worst, paste0(dataset, "the_worst.csv"), row.names = FALSE)

