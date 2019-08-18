# HicProInterChromosome
Process the HiCPro results of inter-chromosome matrix, and make it fit to hicPlotter input.
#################################################################################### 
This program is used to process HiCPro results to interact inter-chromosome 
interactions, and recode to the format that can be used to HiCPlotter. 
Usage: Rscript --vanilla HicProResProcess.R theBinBedFile theMatrixFile chr_1 chr_2 
Parameters: 
theBinBedFile, the bin bed file of HiCPro results, 
theMatrixFile, the interaction score matrix file 
 chr_1, the first chr id 
chr_2, the second chr id 
#####################################################################################
copyright @ Xiaofei Yang, xfyang@xjtu.edu.cn
