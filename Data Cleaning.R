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



 


