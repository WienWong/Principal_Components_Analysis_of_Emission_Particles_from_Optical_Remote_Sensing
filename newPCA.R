# New PCA for data sets of IRI and DOAS .
# 2017-11-06, 2nd version by Weihua Wang
# Spikes filtering first, merge all data later and PCA last.

setwd("/home/wien/")

day=8; month=5; tempdir="085555"; numRows=14716 

source("./findBegEndtime.R")
BegEnd <- findBegEndtime(day, month, tempdir, numRows)
START_MEASUREMENT <- BegEnd[1]
END_MEASUREMENT <- BegEnd[2]

source("./calTOTime.R")
totime <- calTOTime(START_MEASUREMENT, END_MEASUREMENT)
totime

# Read IR(340/675, 440/500, etc) and I500 from a saved dat file calculated by Octave.
IRI <- read.table('IR0508.dat', header = F, stringsAsFactors = FALSE,
                  col.names = c("IR_310T340", "IR_340T440", "IR_340T500", "IR_340T675", "IR_340T870", "IR_440T500",
                                "IR_440T675", "IR_440T870", "IR_500T675", "IR_500T870", "IR_675T870", "I_500"))
#class(IRI$IR_340T675)

timeratio = totime / dim(IRI)[1]
timeratio

# Set time column for IRI
Time <- timeratio*c(1:dim(IRI)[1])  # make up time vector from 0s to 29800s (timeratio*dim(IRI)[1]).
Time <- data.frame(Time)  # add time as a new column into IRI

# Spikes filtering
source("./HpFilterIRI.R")
kk=3
IRI_t <- cbind(IRI,Time)       # _t means time added
IRI.F <- HpFilterIRI(kk,IRI_t) # .F means filtered

# Set another time variable with format of "XX:XX:XX"
TSTD <- read.csv("Time0508.csv", sep = ",", col.names = c("Tstart","Tend"),
                 stringsAsFactors = FALSE) # 14716 X 2
#class(TSTD$Tstart)

IRI.F.T <- cbind(IRI.F, TSTD)  # .T means add another time variable (for merge DOAS data with IR data purpose).

# read csv files with format of e.g. 'DOASeval_YYMMDD_xxxxxx.csv'
fst=52; fed=59

source("./reaDOASfiles.R")
dataset11 <- reaDOASfiles(fst,fed)  
# HCHO at 17th column, NO2a at 20th column, SO2 at 23th column, O3 at 24th column
doasdat <- dataset11[1:dim(dataset11)[1], c(2,17,20,23)]
apply(doasdat, 2, var)

# make a time series column for DOAS data
START_0 = "8:56:38"; END_0 = "17:12:23"
time0 <- as.numeric( toString(difftime(strptime(END_0, format="%H:%M:%OS"), strptime(START_0, format="%H:%M:%OS"), units = "secs") ))
tr0 = time0 / dim(doasdat)[1]
doasdat$Time <- tr0*(1:dim(doasdat)[1])   # add time as a new column into doasdat 

# filter the NO2,HCHO. But SO2 unfiltered for keeping those peak values.
setwd("/home/wien/")
source("./SpikeFilter.R")
width = 1

doasdat.s <- doasdat[3045:dim(doasdat)[1], ] # .s menas sub-set of doasdat

plot(doasdat.s$Time, doasdat.s$SO2conc, type = "l", col='blue', xlab='time', ylab='concentration', main='SO2 concentration')
doasdat.s$SO2conc[doasdat.s$SO2conc < 0.01 ] <- 0.01 # throw values less than 0.01.
plot(doasdat.s$Time, doasdat.s$SO2conc, type = "l", col='blue', xlab='time', ylab='concentration', main='SO2 concentration')

doasdat.s$NO2aconc[doasdat.s$NO2aconc < 0.01 ] <- 0.01
plot(doasdat.s$Time, doasdat.s$NO2aconc, type = "l", col='green', xlab="time", ylab="", main='NO2 concentration')
NO2aconc <- SpikeFilter(doasdat.s$NO2aconc,width)
doasdat.s$NO2aconc <- NO2aconc[[1]]
lines(doasdat.s$Time, doasdat.s$NO2aconc, type = "l", col='red', xlab='time', ylab='concentration', main='Filtered NO2 concentration')

doasdat.s$HCHOaconc[doasdat.s$HCHOaconc < 0.01 ] <- 0.01
plot(doasdat.s$Time, doasdat.s$HCHOaconc, type = "l", col='black', xlab="time", ylab="", main='HCHO concentration')
HCHOaconc <- SpikeFilter(doasdat.s$HCHOaconc,width)
doasdat.s$HCHOaconc <- HCHOaconc[[1]]
lines(doasdat.s$Time, doasdat.s$HCHOaconc, type = "l", col='red', xlab='time', ylab='concentration', main='Filtered NO2 concentration')

apply(doasdat.s, 2, var)  # Now SO2 has the largest variance

#class(doasdat.s$Time); class(doasdat.s$Daytime)
doasdat.s$Daytime <- as.numeric( doasdat.s$Daytime )

#class(IRI.F.T$Tstart)
# Convert a charactor matrix with string format of "xx:xx:xx" to string format of "xxxxx". e.g. "08:52:01" to "85201". 
source("./strVecfromtimeStrvec.R")
IRI.F.T$Tstart <- strVecfromtimeStrvec(IRI.F.T$Tstart)
#class(IRI.F.T$Tstart)  # "character"
#IRI.F.T$Tstart[1]      # "85555"
IRI.F.T$Tend <- strVecfromtimeStrvec(IRI.F.T$Tend)
#IRI.F.T$Tend[dim(IRI)[1]]  # "171235"


IRI.F.T$Tstart.N <- as.numeric(IRI.F.T$Tstart)  # .N means numeric 
IRI.F.T$Tend.N <- as.numeric(IRI.F.T$Tend)
#class(IRI.F.T$Tend.N)

# the merge will throw some data away!
md <- merge.data.frame(doasdat.s, IRI.F.T[,c(4,12,16)], by.x = "Daytime", by.y = "Tstart.N")
apply(md, 2, var)  # check the variance 

# Normalization (because they have different dimensions) before put into PCA, while .n means normalized data set
md.n <- data.frame( scale(md[, -c(1,5),]) ) # exclude Daytime and Time column
apply(md.n, 2, var)  # variance should all be 1

setwd("/home/wien/")
source("./PCA.R")
dim(md.n)[2]

PC <- PCA(md.n[,], "none")

md.n$PC1 <- PC[,1]
md.n$PC2 <- PC[,2]
md.n$PC3 <- PC[,3]
md.n$PC4 <- PC[,4]
md.n$PC5 <- PC[,5]

md.n$Time <- md$Time  # add Time info to normalized md 

# export the result for Octave because adding legend in R is a bit disgusting.
write.csv(md.n,"pcadat1.csv",row.names = FALSE) 
             
# plots only regarding PC1, PC2 and PC3             
plot(md.n$Time, md.n$SO2conc/60, ylim=c(-0.4,0.6), type = "l", col='blue', xlab="Time", ylab="", main='Rescaled standardized SO2/NO2/HCHO, I500, IR340/675 and PC1') 
lines(md.n$Time, md.n$NO2aconc/40, type = "l", col='green', xlab="", ylab="")
lines(md.n$Time, md.n$HCHOaconc/60, type = "l", col='black', xlab="", ylab="")
lines(md.n$Time, md.n$IR_340T675/40, type = "l", col="#CC0000", xlab="", ylab="")
lines(md.n$Time, md.n$I_500/6, type = "l", col='cyan', xlab="", ylab="")
lines(md.n$Time, md.n$PC1/25, type = "l", col="#CC79A7", xlab="", ylab="")
##legend("topright", lwd=1, col=c("blue", "green", 'black', "red"), legend=c("SO2conc/60", "NO2conc/40", "HCHOconc/60", "IR_340T675/40", "I_500/6", "PC2/25"))
legend("topright", lwd=1, col=c("blue", "green", 'black', "red"), legend=c("SO2", "NO2", "HCHO", "IR_340T675", "I_500", "PC2"))

plot(md.n$SO2conc/60, md.n$PC1/40, type="p", col="blue", xlab="SO2", ylab="PC1", main="Scatter plot of SO2 and PC1")
plot(md.n$NO2aconc/40, md.n$PC1/25, type="p", col="blue", xlab="NO2", ylab="PC1", main="Scatter plot of NO2 and PC1")
plot(md.n$HCHOaconc/60, md.n$PC1/25, type="p", col="blue", xlab="HCHO", ylab="PC1", main="Scatter plot of NO2 and PC1")
plot(md.n$IR_340T675/40, md.n$PC1/25, type="p", col="blue", xlab="IR340T675", ylab="PC1", main="Scatter plot of IR340T675 and PC1")
plot(md.n$I_500/6, md.n$PC1/25, type="p", col="blue", xlab="I500", ylab="PC1", main="Scatter plot of I500 and PC1")

#

plot(md.n$Time, md.n$SO2conc/60, ylim=c(-0.4,0.5), type = "l", col='blue', xlab="Time", ylab="", main='Rescaled standardized SO2/NO2/HCHOconc. PC2') 
lines(md.n$Time, md.n$NO2aconc/40, type = "l", col='green', xlab="", ylab="")
lines(md.n$Time, md.n$HCHOaconc/60, type = "l", col='black', xlab="", ylab="")
lines(md.n$Time, md.n$IR_340T675/40, type = "l", col="#CC0000", xlab="", ylab="")
lines(md.n$Time, md.n$I_500/6, type = "l", col='cyan', xlab="", ylab="")
lines(md.n$Time, md.n$PC2/30, type = "l", col="#CC79A7", xlab="", ylab="")
legend("topright", lwd=1, col=c("blue", "green", 'black', "red"), legend=c("SO2conc/60", "NO2conc/40", "HCHOconc/60", "IR_340T675/40", "I_500/6", "PC2/30") )

plot(md.n$SO2conc/60, md.n$PC2/30, type="p", col="blue", xlab="SO2", ylab="PC2", main="Scatter plot of SO2 and PC2")
plot(md.n$NO2aconc/40, md.n$PC2/30, type="p", col="blue", xlab="NO2", ylab="PC2", main="Scatter plot of NO2 and PC2")
plot(md.n$HCHOaconc/60, md.n$PC2/30, type="p", col="blue", xlab="HCHO", ylab="PC2", main="Scatter plot of NO2 and PC2")
plot(md.n$IR_340T675/40, md.n$PC2/30, type="p", col="blue", xlab="IR340T675", ylab="PC2", main="Scatter plot of IR340T675 and PC2")
plot(md.n$I_500/6, md.n$PC2/30, type="p", col="blue", xlab="I500", ylab="PC2", main="Scatter plot of I500 and PC2")

#

plot(md.n$Time, md.n$SO2conc/60, ylim=c(-0.4,0.6), type = "l", col='blue', xlab="Time", ylab="", main='Rescaled standardized SO2/NO2/HCHOconc. PC3') 
lines(md.n$Time, md.n$NO2aconc/40, type = "l", col='green', xlab="", ylab="")
lines(md.n$Time, md.n$HCHOaconc/60, type = "l", col='black', xlab="", ylab="")
lines(md.n$Time, md.n$IR_340T675/40, type = "l", col="#CC0000", xlab="", ylab="")
lines(md.n$Time, md.n$I_500/6, type = "l", col='cyan', xlab="", ylab="")
lines(md.n$Time, md.n$PC3/35, type = "l", col="#CC79A7", xlab="", ylab="")
legend("topright", lwd=1, col=c("blue", "green", 'black', "red"), legend=c("SO2conc/60", "NO2conc/40", "HCHOconc/60", "IR_340T675/40", "I_500/6", "PC3/35") )

plot(md.n$SO2conc/60, md.n$PC3/35, type="p", col="blue", xlab="SO2", ylab="PC3", main="Scatter plot of SO2 and PC3")
plot(md.n$NO2aconc/40, md.n$PC3/35, type="p", col="blue", xlab="NO2", ylab="PC3", main="Scatter plot of NO2 and PC3")
plot(md.n$HCHOaconc/60, md.n$PC3/35, type="p", col="blue", xlab="HCHO", ylab="PC3", main="Scatter plot of NO2 and PC3")
plot(md.n$IR_340T675/40, md.n$PC3/35, type="p", col="blue", xlab="IR340T675", ylab="PC3", main="Scatter plot of IR340T675 and PC3")
plot(md.n$I_500/6, md.n$PC3/35, type="p", col="blue", xlab="I500", ylab="PC3", main="Scatter plot of I500 and PC3")

