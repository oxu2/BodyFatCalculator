BodyFat<-read.csv("BodyFat.csv")
summary(BodyFat)
#Unrealistic: 
#BodyFat: min, max
#Height: min
BodyFat[c(which(BodyFat$BODYFAT<2),which(BodyFat$BODYFAT>40)),]
495/BodyFat$DENSITY[c(172,182,216)]-450
#For 172, 182 and 216, the Bodyfat values are unrealistic. After we calculate the Bodyfat using the Density, the values are more extreme. Delete!
#For 42, Height is unrealistic. Substitute Height by sqrt(Adiposity/Weight). 
BodyFat[which.min(BodyFat$HEIGHT),]
BodyFat[42,6]<-sqrt(0.454*205/29.9)/0.0254
#pdf("b1.pdf") 
boxplot((BodyFat$BODYFAT[-c(172,182,216)]-495/BodyFat$DENSITY[-c(172,182,216)]+450),ylab="difference(100%)")
#dev.off() 
BodyFat[order((BodyFat$BODYFAT-495/BodyFat$DENSITY+450),decreasing = T)[c(1,2,252)],]
#For 48, 76, 96, we can not determine whether Bodyfat or Density is incorrect. Delete!
#pdf("b2.pdf") 
boxplot(0.454*BodyFat$WEIGHT/(0.0254*BodyFat$HEIGHT)^2-BodyFat$ADIPOSITY,ylab="difference(100%)")
#dev.off()
BodyFat[order((0.454*BodyFat$WEIGHT/(0.0254*BodyFat$HEIGHT)^2-BodyFat$ADIPOSITY),decreasing = T)[c(1,252)],]
#For 163 and 221, we can not determine which of the Height, Weight and Adiposity is incorrect. Delete! 
#pdf("b3.pdf") 
boxplot(0.454*BodyFat$WEIGHT[-c(163,221)]/(0.0254*BodyFat$HEIGHT[-c(163,221)])^2-BodyFat$ADIPOSITY[-c(163,221)],ylab="difference(100%)")
#dev.off()


library(MVA)
library(biwt)
data = BodyFat
bf <- cbind(data$IDNO, data$BODYFAT, data$ADIPOSITY, data$CHEST, data$ABDOMEN, data$HIP)
colnames(bf) <- c('IDNO', 'BODYFAT', 'ADIPOSITY', 'CHEST', 'ABDOMEN', 'HIP')
bf <- data.frame(bf)
bf$ABD_OVER_HIP <- bf$ABDOMEN/bf$HIP
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

 




