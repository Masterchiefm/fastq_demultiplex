# Fastq file demultiplexer
Purpose:
This script is created to demultiplex paired-end fastq files, NOT the bcl file!

## Background
In amplicon NGS sequencing, it's a good trick to add extra barcode to the amplicons.
It looks something like this:
```commandline
i5_index----barcode_1---Amplicon---
                     ---Amplicon---barcode_2---i7_index                       
```

So, there must a way to demultiplex the fastq file by the barcodes, not by the i5 or i7.
This script is created to deal with it.

If you got yor fastq files, which is demultiplexed by sequencing company, you may get the R1 and R2 file.
The R1 file is read from 5' to 3' of the top strand, with the sequence structure below:
```commandline
5'---barcode_1---Amplicon---3'
```

the R2 sequnece is somthing like this:
```commandline
5'---barcode_2---Amplicon---3'
```

I'll demultiplex them by barcode_1 and 2. Here is a description:
```commandline

Input:
    A_r1.fq.gz
    A_r2.fq.gz
    
    barcode pairs
        |--ATCG,GATC
        |--GATC,CATG
 
Output:
    ATCG,GATC_on_A_r1.fq.gz
    ATCG,GATC_on_A_r2.fq.gz

    GATC,CATG_on_A_r1.fq.gz
    GATC,CATG_on_A_r2.fq.gz
```
That's how fastq demultiplex work!

## Usage
clone this project, then run the following：
```commandline
demultiplex.sh  index_1 index_2 r1 r2 distance_to_5'
```

Here is an example:
```
demultiplex.sh ATCG  GATC  A_r1.fq.gz  A_r2.fq.gz 4
```
the input $1 is R1-index

the input $2 is R2-index

the input $3 is R1 file

the input $4 is R2 file

the input $5 is R1 output

the input $6 is R2 output

the input $7 is barcode's max distance to the 5' start


