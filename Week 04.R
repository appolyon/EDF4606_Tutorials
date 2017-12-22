# Week 04 Multiple Regression along with testing of assumptions
# Hypothesis?

# Q1. How well do the two measures of control (mastery, PCOISS) predict
# perceived stress? How much variance in perceived stress scores can be
# explained by scores on these two scales?

# Q2. Which is the best predictor of perceived stress: control of external events
# (Mastery Scale) or perceived control of internal states (PCOISS) [e.g. their
# emotions]?

# Useful websites used along the way
# http://rfaqs.com/tag/mctest-package # good outline of mctest package
# https://www.r-bloggers.com/multicollinearity-in-r/ # testing multicolinearity
# https://www.statmethods.net/stats/rdiagnostics.html # good overview of regression diagnostics

  

# Installation of packages that will be used through the tutorial
install.packages("psych", dependencies = TRUE)
install.packages("mvoutlier", dependencies = TRUE)
install.packages("HH", dependencies = TRUE)
install.packages("foreign", dependencies = TRUE)
install.packages("Rcmdr", dependencies = TRUE)
install.packages("ggplot2", dependencies = TRUE)
install.packages("car", dependencies = TRUE) # package used for regression diagnostics
install.packages("mctest", dependencies = TRUE) # package used for regression diagnostics

# Load packages for use in analysis
library(foreign)
library(psych)
library(car)
library(mctest)

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

# Assumption 01 - Sample size and ratio of cases to IVs
# standard regression minimum n > 50 +8m
# For testing individual predictors, 104 + m
summary(surveyData$tpstress)
summary(surveyData$tmast)
summary(surveyData$tpcoiss)
sum(complete.cases(surveyData$tpstress))
sum(complete.cases(surveyData$tmast))
sum(complete.cases(surveyData$tpcoiss))

# Assumption 02 - Multicolinearity and singularity
# Run correlations for our 3 variables
# First, create subset of the data
# Correlations between IVs should not be too high e.g. > .7

predVariables <- subset(surveyData, select = c(tpstress, tmast, tpcoiss))
cor(predVariables, use = "complete.obs", method = "pearson")

# The linear model
# How well do the two measures of control (mastery, PCOISS) predict
# perceived stress?
fit <- lm(formula = tpstress ~ tmast + tpcoiss, data = surveyData)
summary(fit)

# Assumption 02 - Multicolinearity and singularity (cntd)
# We needed to run our model to be able to get Variance Inflation Factors
vif(fit)
sqrt(vif(fit)) > 2

# More detailed colinearity analysis using mctest package (omcdiag and imcdiag functions)

omcdiag(x = predVariables[,-1], y = predVariables$tpstress) # overall multicolinearity statistics
imcdiag(x = predVariables[,-1], y = predVariables$tpstress) # individual multicolinearity statistics
