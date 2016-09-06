library(magrittr)

cell_counts <- 
  readxl::read_excel("../data/Contagem células brometo 27.06.16.xlsx") 

col_names <-
  zoo::na.locf(ifelse(names(cell_counts) == "", NA, names(cell_counts))) %>%
  paste(cell_counts[1,-1]) %>%
  c("treatment", .)

treatment_levels <- c("NI", "PRO", "AMA", "LPS", "LPS PRO", "LPS AMA")

cell_counts_tidy <-
  cell_counts %>%
  .[-1, ] %>%
  setNames(col_names) %>%
  dplyr::select(-dplyr::matches("%MORTAS|TOTAL")) %>% 
  tidyr::fill(treatment) %>%
  tibble::rownames_to_column("observation") %>%
  tidyr::gather(time, value, -observation, -treatment) %>%
  tidyr::separate(time, c("hours", "status"), sep = " ") %>%
  tidyr::spread(status, value) %>%
  dplyr::rename(live = VIVAS, dead = MORTAS) %>%
  dplyr::mutate(observation = as.integer(observation),
                treatment = factor(treatment, levels = treatment_levels),
                hours = factor(hours), 
                dead = as.integer(dead),
                live = as.integer(live),
                total = dead + live,
                ratio = dead/total) %>%
  dplyr::arrange(observation, treatment, hours)

readr::write_csv(cell_counts_tidy, "../data/cell_counts_tidy.csv")
