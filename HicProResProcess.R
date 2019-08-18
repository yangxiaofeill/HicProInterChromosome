########################################################
## HiC-pro results process to implement HiCPlotter can 
##    plot interchromosome-interactions
########################################################
library(data.table)
library(ggplot2)
rm(list = ls())

args = commandArgs(trailingOnly=TRUE)
theBedFile    <- ""
theMatrixFile <- ""
chr_1         <- ""
chr_2         <- ""
printHelpMessage <- function(){
  cat(paste("#################################################################################### \n", 
            "This program is used to process HiCPro results to interact inter-chromosome \n",
            "interactions, and recode to the format that can be used to HiCPlotter. \n",
            "Usage: Rscript --vanilla HicProResProcess.R theBinBedFile theMatrixFile chr_1 chr_2 \n",
            "Parameters: \n",
            "theBinBedFile, the bin bed file of HiCPro results, \n" ,
            "theMatrixFile, the interaction score matrix file \n " ,
            "chr_1, the first chr id \n",
            "chr_2, the second chr id \n", 
            "#####################################################################################\n",
            "copyright @ Xiaofei Yang, xfyang@xjtu.edu.cn", sep = '')
  )
  stop("", call.=FALSE)
}

printEndMessage <- function(theBedFile, theMatrixFile){
  newBedFile <- paste(theBedFile, ".", chr_1, "-", chr_2, ".new.bed \n", sep = '')
  newMatrixFile <- paste(theNewMatrix, ".", chr_1, "-", chr_2, ".new.matrix", sep = '')
  cat(paste("#################################################################################### \n", 
            "the prgram finished, and generate two files: \n",
            paste(newBedFile, "\n", sep = ''),
            paste(newMatrixFile, "\n", sep = ''),
            "HicPlotter commands: \n",
            paste("python HiCPlotter.py -f  ", newMatrixFile, " -wg 1 -chr chr11 -o wg -tri 1 -bed ", newBedFile, " -n HN1_LEAF -r $RES -hmc 5 -ext pdf \n", sep = ''),
            sep = '')
  )
}

if(length(args) == 0 | length(args) != 4){
  printHelpMessage()
}else{
  theBedFile    <- args[1]
  theMatrixFile <- args[2]
  chr_1         <- args[3]
  chr_2         <- args[4]
}

theBedData    <- fread(theBedFile,    header = F, stringsAsFactors = F)
colnames(theBedData) <- c("chr", "start", "end", "binID")
chr_1_bin <- theBedData[which(theBedData$chr == chr_1)]
chr_2_bin <- theBedData[which(theBedData$chr == chr_2), ]

theMatrixData <- fread(theMatrixFile, header = F, stringsAsFactors = F)
colnames(theMatrixData) <- c("binID_1", "binID_2", "score")
theMatrixChr_1_Chr_2 <- theMatrixData[which((theMatrixData$binID_1 %in% chr_1_bin$binID & theMatrixData$BinID_2 %in% chr_2_bin$binID) |
                                            (theMatrixData$binID_1 %in% chr_2_bin$binID & theMatrixData$BinID_2 %in% chr_1_bin$binID)), ]
theBins <- c(chr_1_bin, chr_2_bin)
theBins <- theBins[order(theBins$binID), ]
theNewBinID <- 1 : nrow(theBins)
theNewBin <- cbind(theBins, theNewBinID)
rownames(theNewBin) <- theNewBin$binID

theChrs <- unique(theNewBin$chr)
theNewBin$chr[which(theBins$chr == theChrs[1])] <- "chr1"
theNewBin$chr[which(theBins$chr == theChrs[2])] <- "chr2"
theNewBin <- theNewBin[, -4]
write.table(paste(theBedFile, ".", chr_1, "-", chr_2, ".new.bed", sep = ''), quote = F, sep = "\t", row.names = F, col.names = F)

theNewMatrix <- theMatrixChr_1_Chr_2
oldID_1 <- as.character(theNewMatrix$binID_1)
oldID_2 <- as.character(theNewMatrix$binID_2)
newID_1 <- theNewBin[oldID_1, "theNewBinID"]
newID_2 <- theNewBin[oldID_2, "theNewBinID"]

theNewMatrix$binID_1 <- newID_1
theNewMatrix$binID_2 <- newID_2
write.table(paste(theNewMatrix, ".", chr_1, "-", chr_2, ".new.matrix", sep = ''), quote = F, sep = "\t", row.names = F, col.names = F)

printEndMessage(theBedFile, theMatrixFile)



