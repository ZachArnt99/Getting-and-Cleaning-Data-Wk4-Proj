library(tidyverse)
library(data.table)
features <- read.csv("C:/Users/Public/Documents/Getting and Cleaning Data/Week 4 Course Project/features.txt",
                     sep=" ",header=FALSE)
features <- as.character(features[[2]])
means <- grep("mean", features)
stds <- grep("std", features)
both <- unique(c(means,stds))

trainingactivity <- read.table("C:/Users/Public/Documents/Getting and Cleaning Data/UCI HAR Dataset/train/y_train.txt",
                               header = FALSE, sep = "", dec = ".")
trainingactivity <- as.character(trainingactivity[[1]])
trainingactivity <- parse_number(trainingactivity)
trainingactivity <- as.character(trainingactivity)
trainingactivity <- gsub("1","walking",trainingactivity)
trainingactivity <- gsub("2","walkingupstairs",trainingactivity)
trainingactivity <- gsub("3","walkingdownstairs",trainingactivity)
trainingactivity <- gsub("4","sitting",trainingactivity)
trainingactivity <- gsub("5","standing",trainingactivity)
trainingactivity <- gsub("6","laying",trainingactivity)

trainingsubject <- read.table("C:/Users/Public/Documents/Getting and Cleaning Data/UCI HAR Dataset/train/subject_train.txt",
                                header = FALSE, sep = "", dec = ".")
trainingsubject <- as.character(trainingsubject[[1]])

trainingdata <- read.table("C:/Users/Public/Documents/Getting and Cleaning Data/UCI HAR Dataset/train/X_train.txt",
                           header = FALSE, sep = "", dec = ".")
trainingdata <- trainingdata[,both]
trainingdata <- mutate(trainingdata,activity=trainingactivity,subject=trainingsubject)

testactivity <- read.table("C:/Users/Public/Documents/Getting and Cleaning Data/UCI HAR Dataset/test/y_test.txt",
                           header = FALSE, sep = "", dec = ".")
testactivity <- as.character(testactivity[[1]])
testactivity <- parse_number(testactivity)
testactivity <- as.character(testactivity)
testactivity <- gsub("1","walking",testactivity)
testactivity <- gsub("2","walkingupstairs",testactivity)
testactivity <- gsub("3","walkingdownstairs",testactivity)
testactivity <- gsub("4","sitting",testactivity)
testactivity <- gsub("5","standing",testactivity)
testactivity <- gsub("6","laying",testactivity)

testsubject <- read.table("C:/Users/Public/Documents/Getting and Cleaning Data/UCI HAR Dataset/test/subject_test.txt",
                              header = FALSE, sep = "", dec = ".")
testsubject <- as.character(testsubject[[1]])

testdata <- read.table("C:/Users/Public/Documents/Getting and Cleaning Data/UCI HAR Dataset/test/X_test.txt",
            header = FALSE, sep = "", dec = ".")
testdata <- testdata[both]
testdata <- mutate(testdata,activity=testactivity,subject=testsubject)

alldata <- rbind(trainingdata,testdata)
names <- c(features[both],"activity","subject")
names(alldata) <- names
subjectnumber <- as.numeric(alldata$subject)
alldata$subject <- subjectnumber

alldata <- split(alldata,alldata$activity)
aggregatenames <- character(length=80)
aggregatenames[1] <- "subject"
for(i in 1:79){
  aggregatenames[i+1] <- paste("MEAN",features[both][i],sep="")
}

MEANSwalking <- aggregate(alldata$walking[, 1:79], by = list(subject = alldata$walking$subject), FUN = mean)
MEANSwalkingupstairs <- aggregate(alldata$walkingupstairs[, 1:79], by = list(subject = alldata$walkingupstairs$subject), FUN = mean)
MEANSwalkingdownstairs <- aggregate(alldata$walkingdownstairs[, 1:79], by = list(subject = alldata$walkingdownstairs$subject), FUN = mean)
MEANSsitting <- aggregate(alldata$sitting[, 1:79], by = list(subject = alldata$sitting$subject), FUN = mean)
MEANSstanding <- aggregate(alldata$standing[, 1:79], by = list(subject = alldata$standing$subject), FUN = mean)
MEANSlaying <- aggregate(alldata$laying[, 1:79], by = list(subject = alldata$laying$subject), FUN = mean)

names(MEANSwalking) <- aggregatenames
names(MEANSwalkingupstairs) <- aggregatenames
names(MEANSwalkingdownstairs) <- aggregatenames
names(MEANSsitting) <- aggregatenames
names(MEANSstanding) <- aggregatenames
names(MEANSlaying) <- aggregatenames

