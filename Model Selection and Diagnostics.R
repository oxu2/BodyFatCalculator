#setwd("C:/Users/80498/Desktop/STAT 628/Module2")
bf <- read.csv('BodyFat.csv')
bf[42,6]<-sqrt(0.454*205/29.9)/0.0254

bf <- bf[-c(39,41,48,76,96,163,172,182,216,221),][,-c(1,3)]

library(car)
library(tidyverse)
library(caret)
library(broom)

# 1. aic
model <- lm(BODYFAT ~ ., data = bf)
step(model_aic)
model_aic <- lm(BODYFAT ~ AGE + WEIGHT + NECK + ABDOMEN + THIGH + FOREARM + WRIST, data = bf)
summary(model_aic)
vif(model_aic)

model_aic <- lm(BODYFAT ~ AGE + NECK + ABDOMEN + THIGH + FOREARM + WRIST, data = bf)
summary(model_aic)
vif(model_aic)

predictions_aic <- model_aic %>% predict(bf)
RMSE(predictions_aic, bf$BODYFAT)
MAE(predictions_aic, bf$BODYFAT)


# 2. cor top 3
corr <- c()
for (i in 2:length(names(bf))) {
  corr <- c(corr, cor(bf[, i], bf$BODYFAT))
}
names(corr) <- names(bf)[2:length(bf)]
sort(corr[corr > 0.7], decreasing = T)

model_cor <- lm(BODYFAT ~  ABDOMEN + ADIPOSITY + CHEST , data = bf)
summary(model_cor)
vif(model_cor)

predictions_cor <- model_cor %>% predict(bf)
RMSE(predictions_cor, bf$BODYFAT)
MAE(predictions_cor, bf$BODYFAT)

# 3. cor + aic
sort(corr[corr > 0.5], decreasing = T)
model_aiccor <- lm(BODYFAT~+ABDOMEN+ADIPOSITY+CHEST+HIP+WEIGHT+THIGH+ KNEE, data=bf )
step(model_aiccor)
model_aiccor <- lm(formula = BODYFAT ~  ABDOMEN + WEIGHT + THIGH, data = bf)
summary(model_aiccor)
vif(model_aiccor)

predictions_aiccor <- model_aiccor %>% predict(bf)
RMSE(predictions_aiccor, bf$BODYFAT)
MAE(predictions_aiccor, bf$BODYFAT)



# 4. calculator on website
# height, waist, neck
model_cal <- lm(BODYFAT ~ HEIGHT + ABDOMEN + NECK, data = bf)
summary(model_cal)
vif(model_cal)

predictions_cal <- model_cal %>% predict(bf)
R2(predictions_cal, bf$BODYFAT)
RMSE(predictions_cal, bf$BODYFAT)
MAE(predictions_cal, bf$BODYFAT)



# residual plot to check linearity
ac <- augment(model_aiccor)
ggplot(ac, aes(x = .fitted, y = .resid)) + geom_point() + labs( title = 'residual plot', x = 'fitted value', y = 'residuals')

# qq-plot to check normality
ggplot(ac, aes(sample = .resid)) + stat_qq() + stat_qq_line() + labs(title = 'QQ Plot', x = NULL, y = NULL)

# scale-location plot to test homogeneity  
std_res <- rstandard(model_aiccor)
ggplot(NULL, aes(x = ac$.fitted, y = sqrt(abs(std_res)))) + geom_point() + labs(title = 'Scale - Location Plot', x = 'fitted value', y ='sqrt(standardized residual)')

# residual vs. leverage plot to check 
p5<-ggplot(model_aiccor, aes(.hat, .stdresid))+geom_point()#aes(size=.cooksd), na.rm=TRUE)
#p5<-p5+stat_smooth(method="loess", na.rm=TRUE)
p5<-p5+xlab("Leverage")+ylab("Standardized Residuals")
p5<-p5+ggtitle("Residual vs Leverage Plot")
#p5<-p5+scale_size_continuous("Cook's Distance", range=c(1,5))
p5<-p5+theme_bw()+theme(legend.position="bottom")
p5 <- p5 + geom_hline(yintercept=0)
p5


# example of usage
newdata <- data.frame(ABDOMEN = 100, WEIGHT = 180, THIGH = 60)
predict(model_aiccor, newdata = newdata, interval = 'confidence')
