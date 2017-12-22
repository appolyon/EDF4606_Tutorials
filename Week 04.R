# Week 04 Multiple Regression along with testing of assumptions
# Hypothesis?

# Q1. How well do the two measures of control (mastery, PCOISS) predict
# perceived stress? How much variance in perceived stress scores can be
# explained by scores on these two scales?

# Q2. Which is the best predictor of perceived stress: control of external events
# (Mastery Scale) or perceived control of internal states (PCOISS) [e.g. their
# emotions]?
  

# Installation of packages that will be used through the tutorial
install.packages("psych", dependencies = TRUE)
install.packages("mvoutlier", dependencies = TRUE)
install.packages("HH", dependencies = TRUE)
install.packages("foreign", dependencies = TRUE)
install.packages("Rcmdr", dependencies = TRUE)
install.packages("ggplot2", dependencies = TRUE)

# Load packages for use in analysis
library(foreign)
library(psych)

# If Rcmdr is closed you can restart it using 'Commander()'

# Set working directory and make sure it is correct
setwd("/media/george/Data/Monash/EDF4604 Research project/Tutorials/Week 04")
getwd()

# Read in SPSS .sav file
surveyData <- read.spss("survey.sav", use.value.labels = TRUE, to.data.frame = TRUE, max.value.labels = Inf, trim.factor.names = FALSE, trim_values = FALSE, reencode = NA, use.missings = to.data.frame)

# Check dimension of object
dim(surveyData)

# Save dataset
save("surveyData", file = "/media/george/Data/Monash/EDF4604 Research project/Tutorials/Week 04/surveyData.Rda")

# List all the variable names
names(surveyData)

