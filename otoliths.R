

library(tidyverse)
plot_sex_ratio <- function(data, x_var, facet_var, min_n = 5, y_limits = c(0.3, 0.7), show_labels = FALSE) {

  x_enquo <- enquo(x_var)
  facet_enquo <- enquo(facet_var)

  # 1. Process Data
  plot_df <- data %>%
    filter(SEX %in% c("F", "M")) %>%
    mutate(is_female = if_else(SEX == "F", 1, 0)) %>%
    group_by(!!facet_enquo, !!x_enquo) %>%
    summarize(
      total_n = n(),
      sex_ratio = mean(is_female),
      .groups = "drop"
    ) %>%
    filter(total_n >= min_n)

  # 2. Build Plot
  p <- ggplot(plot_df, aes(x = !!x_enquo, y = sex_ratio))

  # Toggle between Text Labels and Points
  if (show_labels) {
    p <- p + geom_text(aes(label = round(total_n / 100, 1)),
                       size = 3, alpha = 0.8, check_overlap = TRUE)
  } else {
    p <- p + geom_point(aes(size = total_n), alpha = 0.4)
  }

  # Add layers common to both styles
  p + geom_smooth(method = "loess", color = "darkred", formula = 'y ~ x') +
    geom_hline(yintercept = 0.5, linetype = "dashed", color = "gray50") +
    scale_y_continuous(labels = scales::percent, limits = y_limits) +
    facet_wrap(vars(!!facet_enquo)) +
    labs(
      title = paste("Sex Ratio (Proportion Female) by", as_label(x_enquo)),
      subtitle = if(show_labels) "Labels show Sample Size / 100" else "Points sized by Sample Size",
      x = as_label(x_enquo),
      y = "Sex Ratio",
      size = "Sample Size"
    ) +
    theme_minimal()
}

# --- Examples ---

df_age<-read.csv("df_age.csv")
# To see the text labels (n/100):
df_age %>% plot_sex_ratio(AGE, YEAR, show_labels = TRUE)

# To see the points:
df_age %>% plot_sex_ratio(AGE, YEAR, show_labels = FALSE)

df_age %>% plot_sex_ratio(LENGTH, YEAR, show_labels = FALSE)

# --- Usage Examples ---

# 1. Sex ratio by AGE, faceted by YEAR (Post-2000)
df_age %>%
  filter(YEAR > 2000) %>%
  plot_sex_ratio(x_var = AGE, facet_var = YEAR)

# 2. Sex ratio by LENGTH, faceted by YEAR (Post-2000, higher min_n)
df_age %>%
  filter(YEAR > 2000) %>%
  plot_sex_ratio(x_var = LENGTH, facet_var = YEAR, min_n = 500)

# 3. Sex ratio by LENGTH, faceted by AGE (Younger fish)
df_age %>%
  filter(AGE < 11) %>%
  plot_sex_ratio(x_var = LENGTH, facet_var = AGE)

plot_sex_ratio <- function(data, x_var, facet_var, min_n = 5, y_limits = c(0.3, 0.7)) {

  x_enquo <- enquo(x_var)
  facet_enquo <- enquo(facet_var)

  plot_df <- data %>%
    filter(SEX %in% c("F", "M")) %>%
    mutate(is_female = if_else(SEX == "F", 1, 0)) %>%
    group_by(!!facet_enquo, !!x_enquo) %>%
    summarize(
      total_n = n(),
      sex_ratio = mean(is_female),
      .groups = "drop"
    ) %>%
    filter(total_n >= min_n) %>%
    # Calculate label: Sample size divided by 100, rounded to 1 decimal
    mutate(n_label = round(total_n , 1))

  ggplot(plot_df, aes(x = !!x_enquo, y = sex_ratio)) +
    # Swapped geom_point for geom_text
    geom_text(aes(label = n_label), size = 3, alpha = 0.7, check_overlap = TRUE) +
    geom_smooth(method = "loess", color = "darkred", formula = 'y ~ x') +
    geom_hline(yintercept = 0.5, linetype = "dashed", color = "gray50") +
    scale_y_continuous(labels = scales::percent, limits = y_limits) +
    facet_wrap(vars(!!facet_enquo)) +
    labs(
      title = paste("Sex Ratio (Proportion Female) by", as_label(x_enquo)),
      subtitle = paste("Labels show Sample Size / 100 | Faceted by", as_label(facet_enquo)),
      x = as_label(x_enquo),
      y = "Sex Ratio"
    ) +
    theme_minimal()
}
