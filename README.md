---
title: "New Functions"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## createMasterA

This function is for compiling data from acoustic receiver text files. It has three arguments that must be specified in order for the function to work.

The first argument is the "drive" argument. This tells the function where the data are. It is always going to be one capital letter, and usually either C or G, depending on whether you are working off of the local drive or the external back up drive.
```{r eval=F}
drive = "G"
```

The second argument is "batch". This tells the function which batch or batches of receivers you want to compile into one data frame. For example, if you want to look at all the data from the lower alabama river and claiborne lake combined, you would specify those two batches like this: 

```{r eval=F}
batch = c("LA BANK","CL BANK")
```


The third argument is "tagIDs". This tells the function which fish you're interested in looking at. You can either give it a single M.Code ID like "28690" or pass it the entire column of M.Code IDs from your fish data workbook file like this:

```{r eval=F}
tagIDs = c("28690","28990") 
#or
tagIDs = fishdata$M.Code.ID
```

Proper usage of the function should look something like this:
```{r eval=F}
dat <- createMasterA(drive="C",batch=c("LA BANK","CL BANK"), tagIDs = fishdata$M.Code.ID)
```


## createMasterR

This function is for compiling data from radio receiver text files. The arguments are mostly the same, except you can specify whether you want EMG data or just regular data.



