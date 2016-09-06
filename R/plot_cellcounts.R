library(ggplot2)
library(ggthemr)

cell_counts_tidy <- readr::read_csv("../data/cell_counts_tidy.csv")

# plot theme and color scheme:
ggthemr("fresh")

# mean; 95% confidence limits calculated through bootstrap:
ggplot(cell_counts_tidy, 
       aes(x = hours, y = ratio, group = treatment, color = treatment)) +
  stat_summary(fun.y = mean, geom = "line", size = 1) +
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar", 
               width = 0.1, size = 1) +
  labs(x = NULL, y = expression(frac(dead, total)), 
       title = "Proportion of dead cells by treatment")

# median hi-low; 95% confidence interval:
ggplot(cell_counts_tidy, 
       aes(x = hours, y = ratio, group = treatment, color = treatment)) +
  stat_summary(fun.y = median, geom = "line", size = 1) +
  stat_summary(fun.data = median_hilow, geom = "errorbar", 
               width = 0.1, size = 1) +
  labs(x = NULL, y = expression(frac(dead, total)), 
       title = "Proportion of dead cells by treatment")