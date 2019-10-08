
title: "Compiling Telemetry Data from the USACEFISHPASS Data Base"
author: "by Henry Hershey"


```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```


##important notes on usage
1. In order to be able to use these functions, you have to download the HHCOMPILER package from Henry's GitHub page. The source code is also saved in the database, so you could get it that way too. Run the following code to install and load the package.

```{r eval=F}
install.packages("devtools")
devtools::install_github("henryjhershey/HHCOMPILER")
library(HHCOMPILER)
```

2. You also have to install three packages in order for the functions to work. But, you only have to do this the first time. Once the packages are downloaded onto your machine, they will stay there. Run the following code to download the packages:
```{r eval=F}
install.packages(c("lubridate","readr","plyr"))
```


## createMasterA

This function is for compiling data from acoustic receiver text files. The *A* in the function name is for "Acoustic". It has three arguments that must be specified in order for the function to work.

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

This function is for compiling data from radio receiver text files. The *R* in the name is for "Radio". The arguments are mostly the same, except you can specify whether you want data from EMG transmitters or from CARTs.

The first two arguments are the same, but the third, `tagIDs`, now has new options. Because the two tag types (CARTS and EMGs) have different IDs, you have to specify the right ones for the type of data you are compiling. To compile EMG data, you would set the `EMG` argument to `TRUE`, and you would have to supply a vector of EMG IDs. In the fish workbook data, EMG IDs are in a column called EMG.ID. If you set the `EMG` argument to `FALSE`, you will have to supply a vector of "M Codes", which are unique to the CARTs. CARTs have both radio IDs and acoustic IDs, and it's important to keep track of both when you tag fish. 
Proper usage of the function should look something like this:
```{r eval=F}
dat <- createMasterR(drive="G",batch=c("LA BANK","CL BANK"), tagIDs = fishdata$M.Code.ID, EMG=F)
```


## createMasterT

This function is for compiling triangulated position text files. The *T* in the name is for "triangulated". There are only two arguments: `drive` and `batch`. The batch argument still allows you to select multiple batches, so you can compile positions from both the upper and lower arrays together into one dataframe. There are no other arguments for this function yet.
Proper usage of the function should look something like this:
```{r eval=F}
dat <- createMasterT(drive="G",batch=c("LC ARRAY","UC ARRAY"))
```
\
\
\
\
\
\
\
\
\
\
REVISED: 2019-10-07
