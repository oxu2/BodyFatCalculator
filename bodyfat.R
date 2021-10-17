rm(list=ls())

data <- read.csv('BodyFat.csv')
# typeof(data)
# summary(data)
# names(data)

# # plot
# for (i in 3:length(names(data))) {
#   plot(data[, i], data$BODYFAT, main = names(data)[i])
# }


# variable selection
bf <- cbind(data$IDNO, data$BODYFAT, data$ADIPOSITY, data$CHEST, data$ABDOMEN, data$HIP)
colnames(bf) <- c('IDNO', 'BODYFAT', 'ADIPOSITY', 'CHEST', 'ABDOMEN', 'HIP')
bf <- data.frame(bf)
bf$ABD_OVER_HIP <- bf$ABDOMEN/bf$HIP
# head(bf)
# names(bf)
# summary(bf)

len = length(bf$BODYFAT)

plot(x = 1:len, y = bf$ABD_OVER_HIP)
# box plots
par(mfrow=c(2,3))
for (i in 1:length(names(bf))) {
  boxplot(bf[, i], main = names(bf)[i])
}
# ad 3, chest 3, ab 3, hip 4, ratio 2


# histograms
par(mfrow = c(2, 3))
for (i in 1:length(bf[1, ])) {
  hist(bf[, i], main = names(bf)[i])
}

# bodyfat, ad, chest, ab, hip -> outliers


# checking missing values
for (i in 1:length(bf[1, ])) {
  for (j in 1:length(bf[, 1])) {
    if (is.na(bf[j,i]) == TRUE) print(c(j, i))
  }
}


# remove invalid bodyfats
for (i in 1:length(bf[, 1])) {
  if (bf[i, 'BODYFAT'] <= 3 | bf[i, 'BODYFAT'] >= 40) {
    print(paste(bf[i, 'BODYFAT'], i)) 
    bf[i, ] <- NA
  }
}
bf <- na.omit(bf)


# remove outliers
ad_outlier <- sort(bf$ADIPOSITY, decreasing = T)[1:3]
ch_outlier <- sort(bf$CHEST, decreasing = T)[1:3]
ab_outlier <- sort(bf$ABDOMEN, decreasing = T)[1:2]
hi_outlier <- sort(bf$HIP, decreasing = T)[1:4]

#sort(bf$CHEST)[1] %in% sort(bf$CHEST)[1:3]

for (i in 1:length(bf$BODYFAT)) {
  if (bf$ADIPOSITY[i] %in% ad_outlier) {bf[i, ] <- NA; print(i)}
  if (bf$CHEST[i] %in% ch_outlier) {bf[i, ] <- NA; print(i)}
  if (bf$ABDOMEN[i] %in% ab_outlier) {bf[i, ] <- NA; print(i)}
  if (bf$HIP[i] %in% hi_outlier) {bf[i, ] <- NA; print(i)}
}

bf <- na.omit(bf)
length(bf$BODYFAT)


# histograms after deleting outliers
par(mfrow = c(2, 3))
for (i in 1:length(bf[1, ])) {
  hist(bf[, i], main = names(bf)[i])
}



reg <- lm(bf$BODYFAT ~ bf$ADIPOSITY + bf$CHEST + bf$ABD_OVER_HIP )
summary(reg)

# check multilineariry 
library('car')
vif(reg) # <10 acceptable

reg2 <- lm(bf$BODYFAT ~ bf$ADIPOSITY + bf$ABD_OVER_HIP)

summary(reg2)

vif(reg2)

reg3 <- lm(bf$BODYFAT ~  bf$ABD_OVER_HIP)

summary(reg3)

vif(reg3)

# install.packages("MVA")  
# install.packages("biwt") 
# install.packages("robustbase")  

require("MVA")
require("biwt")

# Here, we detect outliers for explanatory variables. Intuitively, if some record is far from the majority, it may be wrong. Even it is a correct record, it may not come from the same population we are interested in. It is difficult to plot high dimension scatter plot so here we look at pairwise scatter plots. 

options(repr.plot.width=10, repr.plot.height=10, res=500)
pairs(bf[-1], 
      panel = function(x,y, ...) {
        text(x, y, bf$IDNO,cex = 1, pos = 2)
        bvbox(cbind(x,y), add = TRUE,method = "robust")
      })

# The 39, 41 and 212 always lay out of the dashed line. We adapt star plots to check if there is any mistake.

set.seed(1)
t <- sample(1:dim(bf)[1], 9)
# t <- t[!t %in% c(39,41,216)]
subdata <- bf[unique(c(39,41,t)), ]
stars(subdata[,c('BODYFAT', 'ADIPOSITY', 'CHEST', 'ABDOMEN', 'HIP', 'ABD_OVER_HIP')],
      labels=subdata$IDNO)

stars(subdata[,c('BODYFAT', 'CHEST', 'ABDOMEN', 'HIP')],labels=subdata$IDNO)


# We can see 39 and 41 are two big guys with large measurements in almost every aspect and are statistically different from others, i.e. they may be outliners, so we will delete them.
