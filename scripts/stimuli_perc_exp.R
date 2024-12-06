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
  rename(participant = cycle) %>%
  rename(exp_part = exp) %>%
  mutate(dyad = str_extract(sessionID, "^[^_]+")) %>%
  select(-`...1`) %>%  # Remove the first column
  rename(stimulus = word)

# Reorder the columns in the specified order
df <- df %>%
  select(dyad, participant, exp_part, modality, expressibility_dutch, 
         English, guess_binary, cosine_similarity, stimulus, answer, 
         SemanticSubcat, sessionID)
  
# Only keep rows that match English in concepts
df <- df %>%
  semi_join(concepts, by = "English")

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
  group_by(dyad, participant) %>%
  mutate(
    perf_participant = (sum(guess_binary == 1) / n()) * 100
  ) %>%
  ungroup()

# Sort by optimal and suboptimal
df_best <- df %>%
  filter(guess_binary == 1)
df_worst <- df %>%
  filter(guess_binary == 0)

# Frequencies ----
# Generate a frequency table for the 'English' column
df_best %>%
  group_by(English) %>%
  summarise(frequency = n()) %>%
  arrange(desc(frequency)) %>% 
  print(n = 100)
## 70 out of 84
df_worst %>%
  group_by(English) %>%
  summarise(frequency = n()) %>%
  arrange(desc(frequency)) %>% 
  print(n = 100)
## 81 out of 84

# Best of best ----
# Identify the best-performing dyad and participant for each unique concept
best_of_best <- df_best %>%
  group_by(English) %>%  # Group by unique concepts
  filter(
    perf_dyad == max(perf_dyad)  # Retain rows with the best-performing dyad
  ) %>%
  filter(
    perf_participant == max(perf_participant)  # Within dyad, retain rows with the best-performing participant
  ) %>%
  ungroup()
  
# Worst of worst ----
# Identify the worst-performing dyad and participant for each unique concept
worst_of_worst <- df_worst %>%
  group_by(English) %>%  # Group by unique concepts
  filter(
    cosine_similarity == min(cosine_similarity, na.rm = TRUE)  # Retain rows with the lowest cosine similarity
  ) %>%
  filter(
    perf_dyad == min(perf_dyad)  # Among those, retain rows with the worst-performing dyad
  ) %>%
  filter(
    perf_participant == min(perf_participant)  # Within the dyad, retain rows with the worst-performing participant
  ) %>%
  ungroup()

# Check repetitions
best_of_best %>%
  group_by(English) %>%
  summarise(row_count = n()) %>%
  mutate(type = ifelse(row_count > 1, "repeated", "single")) %>%
  summarise(
    total_repeated = sum(type == "repeated"),
    total_single = sum(type == "single")
  )
setdiff(unique(trimws(tolower(df$English))), unique(trimws(tolower(df_best$English))))

worst_of_worst %>%
  group_by(English) %>%
  summarise(row_count = n()) %>%
  mutate(type = ifelse(row_count > 1, "repeated", "single")) %>%
  summarise(
    total_repeated = sum(type == "repeated"),
    total_single = sum(type == "single") )
setdiff(unique(trimws(tolower(df$English))), unique(trimws(tolower(df_worst$English))))

