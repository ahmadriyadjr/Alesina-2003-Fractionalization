###############################################################################
# 03_visuals.R
#
# This is the THIRD file you will run re: the replication of Alesina et al. (2003)
#
# This script produces visualizations that complement the regression results
# in 02_analysis.R:
#
#   (1) Scatter plot: ethnic fractionalization vs corruption
#   (2) Scatter plot: ethnic fractionalization vs log infant mortality
#   (3) Coefficient plot: regression results from reg2 and reg3
#
#     ## All figures are saved to the output/ folder as .png files ##
#
###############################################################################
                              ## Packages ##
library(tidyverse)
library(sandwich)
library(lmtest)
                           ## Load Cleaned Data ##
df <- read.csv("data/df_clean.csv")

###############################################################################
#
#       #### Plot 1: Ethnic Fractionalization vs Corruption ####
#
# Visualizes the core relationship from reg3.
#
# Each point is a country. The regression line shows the positive association 
#     between ethnic fractionalization and corruption. Countries are colored 
#     by region to show regional patterns.
#
###############################################################################
                            ## Create Plot 1 ##
#                  Ethnic Fractionalization vs Corruption 
# Visualizes the core relationship from reg3.
# Each point is a country. The regression line shows the positive association 
#      between ethnic fractionalization and corruption. Countries are colored 
#      by region to show regional patterns.
#
###############################################################################

df <- df |> 
  mutate(region_label = case_when(
    ht_region == 4 ~ "Sub Saharan Africa",
    ht_region == 2 ~ "Latin America",
    TRUE ~ "Other"
  ))

plot1 <- ggplot(df, aes(x = al_ethnic2000, y = vdem_corr)) +
  geom_point(aes(color = region_label), alpha = 0.7, size =2) + 
  geom_smooth(method = "lm", se = TRUE, color = "black", linewidth = 0.8) +
  geom_text(aes(label = cname), size = 1.5, vjust = -0.8, check_overlap = TRUE) + 
  scale_color_manual(values = c(
    "Sub Saharan Africa" = "#E63946",
    "Latin America"      = "#2A9D8F",
    "Other"              = "#aaaaaa"
  )) +
  labs(
    title    = "Ethnic Fractionalization and Corruption",
    subtitle = "Replication of Alesina et al. (2003), Table 12b",
    x        = "Ethnic Fractionalization Index",
    y        = "Corruption Index (V-Dem, 0-1)",
    color    = "Region",
    caption  = "Note: Regression line from OLS with robust standard errors. 
    Data: QoG (2026)."
  ) +
  
theme_minimal()
                               ## To Output Folder ##
ggsave("output/plot1_corruption.png", plot1, width = 9, height = 6, dpi = 300)

###############################################################################
                            ## Create  Plot 2 ##
#               Ethnic Fractionalization vs Log Infant Mortality
#
# Visualizes the core relationship from reg2.
#
###############################################################################

plot2 <- ggplot(df, aes( x= al_ethnic2000, y = log_mortinf)) + 
  geom_point(aes(color = region_label), alpha = 0.7, size = 1.8) + 
  geom_smooth(method = "lm", se = TRUE, color = "black", linewidth = 0.8) + 
  geom_text(aes(label = cname), size = 1.5, vjust = -0.8, check_overlap = TRUE) + 
  scale_color_manual(values = c(
    "Sub Saharan Africa" = "#E63946",
    "Latin America"      = "#2A9D8F",
    "Other"              = "#aaaaaa"
  )) +
  labs(
    title    = "Ethnic Fractionalization and Infant Mortality",
    subtitle = "Replication of Alesina et al. (2003), Table 12f",
    x        = "Ethnic Fractionalization Index",
    y        = "Log Infant Mortality Rate",
    color    = "Region",
    caption  = "Note: Regression line from OLS with robust standard errors. 
    Data: QoG (2026)."
  ) +
  
  theme_minimal()
                             ## To Output Folder ##
ggsave("output/plot2_mortality.png", plot2, width = 9, height = 6, dpi = 300)

###############################################################################
                     ## Plot 3: Coefficient Plot ##
#
# Visualizes regression coefficients from reg2 and reg3 as dots with 95% 
#    confidence intervals. If the interval does not cross zero, the result is 
#    statistically significant at the 5% level.
#
###############################################################################
                     ## Reload our Regressions ##
                     # Saved in 02_analysis.R #
reg2 <- readRDS("data/reg2.rds")
reg3 <- readRDS("data/reg3.rds")
          ## Extract Coefficients & Robust Confidence Intervals ##
extract_coefs <- function(model, model_name)
{
  robust_se <- sqrt(diag(vcovHC(model, type = "HC1")))
  coefs <- coef(model)
  data.frame(
    term      = names(coefs),
    estimate  = coefs,
    conf_low  = coefs - 1.96 * robust_se,
    conf_high = coefs + 1.96 * robust_se,
    model     = model_name
  )
}

coef_df <- rbind(
  extract_coefs(reg2, "Log Infant Mortality"),
  extract_coefs(reg3, "Corruption (V-Dem)")
)
            ## Removing Intercept & Increasing Readability ##
coef_df <- coef_df |> 
  filter(term != "(Intercept)") |> 
  mutate(term = recode(term,
    "al_ethnic2000" = "Ethnic Fractionalization",
    "log_pop"       = "Log Population",
    "ssafrica"      = "Sub-Saharan Africa",
    "latam"         = "Latin America"
  ))
                      ## Make Plot 3 ##
plot3 <- ggplot(coef_df, aes(x = estimate, y = term, color = model)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "grey") + 
  geom_pointrange(aes(xmin = conf_low, xmax = conf_high),
                  position = position_dodge(width = 0.4), size = 0.6) + 
  scale_x_continuous(breaks = seq(-0.2, 1.8, by = 0.2)) +
  labs(
    title    = "Regression Coefficients with 95% Confidence Intervals",
    subtitle = "Replication of Alesina et al. (2003), Tables 12b and 12f",
    x        = "Coefficient Estimate",
    y        = NULL,
    color    = "Outcome",
    caption  = "Note: Robust standard errors (HC1). Dashed line at zero."
  ) +
  theme_minimal()

ggsave("output/plot3_coefplot.png", plot3, width = 9, height = 5, dpi = 300)
