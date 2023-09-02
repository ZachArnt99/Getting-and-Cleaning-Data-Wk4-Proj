---
title: "Codebook for Getting and Cleaning Data Week 4 Course Project"
author: "Zachary B Arnt"
date: "2023-09-02"
output: html_document
---

## R Markdown

Source of data:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
downloaded 02-SEP-2023

Description of original dataset from:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
downloaded 02-SEP2023

**Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.**

Analysis and code:

Downloading and unzipping data. Loading tidyverse and data.table with library().
Features.txt contains all 561 original variables. Narrowing them to just those 
containing "mean" or "std" with grep() and saving column numbers for later using
R object called both.

```
library(tidyverse)
library(data.table)
features <- read.csv("C:/Users/Public/Documents/Getting and Cleaning Data/Week 4 Course Project/features.txt", sep=" ",header=FALSE)
features <- as.character(features[[2]])
means <- grep("mean", features)
stds <- grep("std", features)
both <- unique(c(means,stds))
knitr::opts_chunk$set(echo = TRUE)
```
Getting and converting a list of training activities as described in original
dataset file called activity_labels.txt.
```
trainingactivity <- read.table("C:/Users/Public/Documents/Getting and Cleaning Data/UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "", dec = ".")
trainingactivity <- as.character(trainingactivity[[1]])
trainingactivity <- parse_number(trainingactivity)
trainingactivity <- as.character(trainingactivity)
trainingactivity <- gsub("1","walking",trainingactivity)
trainingactivity <- gsub("2","walkingupstairs",trainingactivity)
trainingactivity <- gsub("3","walkingdownstairs",trainingactivity)
trainingactivity <- gsub("4","sitting",trainingactivity)
trainingactivity <- gsub("5","standing",trainingactivity)
trainingactivity <- gsub("6","laying",trainingactivity)
```
Getting list of training subjects for later. Loading large trainingdata
dataset and slimming it down to only keep the column headings needed.
Adding activity and subject columns to the dataset.
```
trainingsubject <- read.table("C:/Users/Public/Documents/Getting and Cleaning Data/UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "", dec = ".")
trainingsubject <- as.character(trainingsubject[[1]])
trainingdata <- read.table("C:/Users/Public/Documents/Getting and Cleaning Data/UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "", dec = ".")
trainingdata <- trainingdata[,both]
trainingdata <- mutate(trainingdata,activity=trainingactivity,subject=trainingsubject)
```
Repeat with testdata
```
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
testsubject <- read.table("C:/Users/Public/Documents/Getting and Cleaning Data/
UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "", dec = ".")
testsubject <- as.character(testsubject[[1]])
testdata <- read.table("C:/Users/Public/Documents/Getting and Cleaning Data/UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "", dec = ".")
testdata <- testdata[both]
testdata <- mutate(testdata,activity=testactivity,subject=testsubject)

```
Combining datasets, adding column names, and converting subjects to numeric for
later.
```
alldata <- rbind(trainingdata,testdata)
names <- c(features[both],"activity","subject")
names(alldata) <- names
subjectnumber <- as.numeric(alldata$subject)
alldata$subject <- subjectnumber
```
Splitting by activity and creating appropriate column names for aggregated data.
```
alldata <- split(alldata,alldata$activity)
aggregatenames <- character(length=80)
aggregatenames[1] <- "subject"
for(i in 1:79){
  aggregatenames[i+1] <- paste("MEAN",features[both][i],sep="")
}
```
Creating tidy datasets by variable and subject for each activity according to
tidy data principles. Adding column names. 
```
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
```
Printing results
```
MEANSwalking
MEANSwalkingupstairs
MEANSwalkingdownstairs
MEANSsitting
MEANSstanding
MEANSlaying
```
