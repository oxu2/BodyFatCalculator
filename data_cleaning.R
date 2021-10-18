bf <- read.csv('BodyFat.csv')

# remove invalid bodyfatsw
for (i in 1:length(bf[, 1])) {
  if (bf[i, 'BODYFAT'] <= 3 | bf[i, 'BODYFAT'] >= 40) {
    print(paste(bf[i, 'BODYFAT'], i)) 
    bf[i, ] <- NA
  }
}
bf <- na.omit(bf)

bf$ABD_OVER_HIP <- bf$ABDOMEN/bf$HIP

# find points that bodyfat and density do not match
plot(1/bf$DENSITY, bf$BODYFAT)
den_inverse <- 1/bf$DENSITY
bf_den_check <- lm(bf$BODYFAT ~ den_inverse)
residuals(bf_den_check)
plot(residuals(bf_den_check))
sort(residuals(bf_den_check))[1]
sort(residuals(bf_den_check), decreasing = T)[1:3]
# residuals greater than 1
# get the index
bf_index <- c(order(residuals(bf_den_check))[1], order(residuals(bf_den_check), decreasing = T)[1:3])
#bf[bf_index, ]


# BMI, height and weight check
plot(bf$ADIPOSITY, bf$WEIGHT/bf$HEIGHT^2)
BMI <- bf$WEIGHT / bf$HEIGHT^2
bmi_check <- lm(bf$ADIPOSITY ~ BMI)
residuals(bmi_check)
plot(residuals(bmi_check))

sort(residuals(bmi_check))[1]
sort(residuals(bmi_check), decreasing = T)[1:2]

bmi_index <- c(order(residuals(bmi_check))[1], order(residuals(bmi_check), decreasing = T)[1:2])
bf[bmi_index, c('BODYFAT', 'WEIGHT', 'HEIGHT', 'ADIPOSITY')]
# 39 overweight, 41 42 too short

# delete outliers
bf[bmi_index, ] <- NA
bf[bf_index, ] <- NA
bf <- na.omit(bf)


# dot plots
for (i in 4:length(names(bf))) {
  plot( bf[, i], bf$BODYFAT, main = names(bf)[i])
}

for (i in 4:length(names(bf))) {
  print(c(names(bf)[i], cor(bf[, i], bf$BODYFAT)))
}

# select variables based on correlation (cor >= 0.6)
bf_valid <- c()
name <- list()
for (i in 4:length(names(bf))) {
  if (cor(bf[, i], bf$BODYFAT) >= 0.6){
    bf_valid <- cbind(bf_valid, bf[, i])
    name <- c(name, names(bf)[i])
  }
}

colnames(bf_valid) <- name
bf_valid <- data.frame(bf_valid)
head(bf_valid)

library(MVA)
library(biwt)

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

# fit model
model1 <- lm(bf$BODYFAT ~ bf_valid$ADIPOSITY + bf_valid$CHEST + bf_valid$ABDOMEN + bf_valid$HIP)
model2 <- lm(bf$BODYFAT ~ bf_valid$ADIPOSITY + bf_valid$CHEST + bf_valid$ABD_OVER_HIP)

summary(model1)
summary(model2)

mod1 <- step(model1, direction = 'backward')
mod2 <- step(model2, direction = 'backward')

vif(model1)
vif(model2)

