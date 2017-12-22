# Tutorial Week 02

# Helpful links used along the way
# http://127.0.0.1:25868/library/foreign/html/read.spss.html
# https://www.r-bloggers.com/how-to-open-an-spss-file-into-r/
# http://www.statmethods.net/stats/ttest.html
# http://127.0.0.1:22669/library/car/html/leveneTest.html
# http://www.cookbook-r.com/Statistical_analysis/Homogeneity_of_variance/
# http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/
# http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/


# Install packages that will be used throughout the rest of the tutorial analysis
install.packages("psych", dependencies=TRUE)
install.packages("mvoutlier", dependencies=TRUE)
install.packages("HH", dependencies=TRUE)

# Load packages to use in analysis
library(foreign)
library(Rcmdr)
library(ggplot2)

# How to start Rcmdr if it has been accidentaly closed
Commander()

# Read in the SPSS .sav file
surveyData <- read.spss("survey.sav", use.value.labels = TRUE, to.data.frame = TRUE, max.value.labels = Inf, trim.factor.names = FALSE, trim_values = FALSE, reencode = NA, use.missings = to.data.frame)

# Check dimensions of object (correct number of rows and colums?)
dim(surveyData)

# Save dataset
save("surveyData", file="D:/Monash/EDF4604 Research project/Tutorials/Week 02/surveyData.Rda")

# Get a list of the variable names
names(surveyData)

# Running independent samples t-test including testing assumptions
# Conduct Levene's test for homogeneity of variance
leveneTest(surveyData$tslfest, surveyData$sex, center=mean) # note use center=median for more conservative test

# Running the independent samples t-test
t.test(surveyData$tslfest~surveyData$sex) # equal variances not assumed
t.test(surveyData$tslfest~surveyData$sex, var.equal = TRUE) # equal variances assumed

# Recode sex variable for use in charts
surveyData$gender[surveyData$sex=="FEMALES"] <- 1
surveyData$gender[surveyData$sex=="MALES"] <- 2

# Use describeBy function from psych package to get summary stats including mean/median/skew/kurtosis
describeBy(surveyData$tslfest, surveyData$gender)

# Producing box plots for our data
# Configure object and determine colour of boxes by sex
esteemBoxplot <- ggplot(surveyData, aes(sex, tslfest, fill=sex))

# Add layers
esteemBoxplot + geom_boxplot(show.legend = TRUE) + labs(x = "Gender", y = "Total Self Esteem") # With x label
esteemBoxplot + geom_boxplot(show.legend = TRUE) + labs(x = "", y = "Total Self Esteem") # Without x label

# Conducting an ANOVA
# Summary of variables used in analysis
summary(surveyData$toptim)
summary(surveyData$agegp3)

# Testing assumptions and checking data
# Checking for outliers
ageBoxplot <- ggplot(surveyData, aes(agegp3, toptim, fill=agegp3))
ageBoxplot + geom_boxplot(show.legend = TRUE) + labs(x = "", y = "Total Optimism")

# Our visual analysis of boxplots shows there are some outliers
# Produce qq plot to check for normality
attach(surveyData)
qqnorm(toptim)
qqline(toptim)

# Homogeneity of variance (The bartlett.test(y~G, data=mydata) function provides a parametric K-sample test of the equality of variances. The fligner.test(y~G, data=mydata) function 
# provides a non-parametric test of the same. In the following examples y is a numeric variable and G is the grouping variable.)
bartlett.test(toptim ~ agegp3, data=surveyData)

# Visual test of homogeneity of variance using HH package (The hovPlot() function in the HH package provides a graphic test of homogeneity of variances based on Brown-Forsyth.)
hov(toptim ~ agegp3, data=surveyData) # though this command didn't work for me
hovPlot(toptim ~ agegp3, data=surveyData) # this produced a graph though I'm not sure what it shows

# Fitting the model
anova <- aov(toptim ~ agegp3, data=surveyData)
anova

# Producing diagnostic plots
layout(matrix(c(1,2,3,4),2,2))
plot(anova)

# Evaluate model effects (read warnings from this site http://www.statmethods.net/stats/anova.html)
summary(anova)
drop1(anova,~.,test="F") # this produces similar results to SPSS
anova(anova) # use this for nested models

# Multiple comparisons
TukeyHSD(anova)

# Obtain equality of means test using Welch formula
oneway.test(toptim ~ agegp3)

# Plot the means
meanPlot <- ggplot(surveyData, aes(agegp3, toptim, colour = agegp3))
meanPlot + stat_summary(fun.y = mean, geom = "point") + stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width = 0.2) + labs(x = "Age Group", y = "Total Optimism")
meanPlot + stat_summary(fun.y = mean, geom = "point") + stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width = 0.2) + labs(x = "Age Group", y = "Total Optimism") + scale_colour_discrete(name="Age\nGroup")




