###############################################################################
# 01_load_and_clean.R 
#
# This is the FIRST file you will run re: the replication of Alesina et al. (2003)
#
# This specific script (1) loads the QoG dataset (.dta); (2) extracts the variables
# needed for replication; (3) and verifies the fractionalization
# indices against "Table 1" of the paper.
#
###############################################################################
#
#                       #### Load These Packages ####
#                      (Script will NOT RUN w/o these)
#
library(tidyverse) #Standard Package
library(haven)   # Allows .dta (STATA) files to run in R
#
#
#                      #### Load The Data ####
#
# Quality of Governance (QoG) Standard Cross-Section dataset (Jan 2026 version)
# Sourced from: https://www.gu.se/en/quality-government/qog-data 
#
qog <- read_dta("data/qog_std_cs_jan26.dta") # File name may vary!
#
#                     #### Inspect The Data ####
#                   Asks Important Pre-Analysis Qs (see below)
#               How many rows (countries) and columns (variables)?
#
dim(qog)
#
#
#          ## This Allows You to Take a Peek at the First Few Rows ##
#
head(qog)
#
###############################################################################
#
#                 #### Selecting the Relevant Variables ####
#                  There are 1,487 Variables, we only need:
#
# Note: "wdi_gdpcapgr" & "pwt_hci" were adapted from: "wdi_gdppcgr" & "bl_asymf"
#
#   cname           = country name
#   al_ethnic2000   = ethnic fractionalization index (Alesina et al.)
#   al_language2000 = linguistic fractionalization index
#   al_religion2000 = religious fractionalization index
#   wdi_gdpcapgr     = GDP per capita growth (World Development Indicators)
#   pwt_hci        = average years of schooling (Barro-Lee)
#   wdi_pop         = total population (for log population control)
#
#                              #######
#
df <- qog |> 
  select(
    cname,
    al_ethnic2000,
    al_language2000,
    al_religion2000,
    wdi_gdpcapgr,
    pwt_hci,
    wdi_pop
  )
#
#                    ## Taking a Look at Our Cleaned Data ##
#
dim(df)
head(df)
#
###############################################################################
#
#              #### Let's Check This Against Alesina et al. (2003) ####
#      #### "Table 1 – Sample Means of the Fractionalization Measures" ####
#
#  Paper reports (Table 1):
#          Ethnic:   mean = 0.435, N = 180
#          Language: mean = 0.385, N = 185
#          Religion: mean = 0.439, N = 198
#
#  For Our Sanity, We Check Whether Our Data Matches & Reproduces These Stats
#
# Note: Alesina et al. (2003) uses data from the '90s; 
#       we use the QoG from the 2000s. Minor differences are expected. 
#
#                                  #######
#
df |> 
  summarise(
    ethnic_mean = mean(al_ethnic2000, na.rm = TRUE),
    ethnic_n    = sum(!is.na(al_ethnic2000)),
    lang_mean   = mean(al_language2000, na.rm = TRUE),
    lang_n      = sum(!is.na(al_language2000)),
    relg_mean   = mean(al_religion2000, na.rm = TRUE),
    relg_n      = sum(!is.na(al_religion2000))
  )
#
###############################################################################
#
#         #### Comparing Our Results Against Alesina et al. (2003) ####
#
# Our means closely replicates Table 1:      # Thumbs Up
#   Ethnic:   0.437 vs 0.435 in paper
#   Language: 0.392 vs 0.385 in paper  
#   Religion: 0.438 vs 0.439 in paper
#
# The Differences in the mean and N values reflect our QoG's dating against
#   Alesina et al.(2003)'s indices. Our data covers slightly more countries 
#   than the original 2003 publication.
#
# The close correspondence, no less, confirms we are using the correct data.
#
###############################################################################
