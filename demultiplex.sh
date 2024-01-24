#!/bin/bash
# This file is created for demultiplex fastq.gz file by custom index.

#the input $1 is R1-index
#the input $2 is R2-index
#the input $3 is R1 file
#the input $4 is R2 file
#the input $5 is R1 output
#the input $6 is R2 output
#the input $7 is barcode's max distance to the 5' start

index1=$1
index2=$2

r1=$3
r2=$4

o1=$5
o2=$6

d=$7
session=$(cat /proc/sys/kernel/random/uuid)


index1=CTCG
index2=GCGT

r1=/home/chief/demux/a_r1.fastq.gz
r2=/home/chief/demux/a_r2.fastq.gz
r1=/home/chief/demux/ITIH5-AAVS1-NGS_R1.fq.gz
r2=/home/chief/demux/ITIH5-AAVS1-NGS_R2.fq.gz

o1=/home/chief/demux/o1_r1.fastq
o2=/home/chief/demux/o1_r2.fastq

d=4
#session='a-'
#echo "zcat ${r1} |grep -A 2 -B 1  --no-group-separator -E  \"^.{0,$d}${index1}\" >  ${index1}.${session}.tmp.txt"

# 符合index1
zcat ${r1} |grep -A 2 -B 1  --no-group-separator -E  "^.{0,$d}${index1}" >  ${index1}.${session}.tmp.txt
n=$(cat  ${index1}.${session}.tmp.txt |grep @|wc -l)
echo "find $n record with barcode $index1"

grep  --no-group-separator -oE '^@[^ ]+ ' ${index1}.${session}.tmp.txt > ${index1}.${session}.tmp.idx
n=$(cat  ${index1}.${session}.tmp.idx |grep @|wc -l)
echo "export $n barcode id"

zcat  ${r2} | grep  -A 3 --no-group-separator -F -f ${index1}.${session}.tmp.idx |grep -A 2 -B 1 --no-group-separator  -E "^.{0,4}${index2}" > ${o2}
n=$(cat  ${o2} |grep @|wc -l)
echo "find $n record in r2"

# R2索引名称列表
grep  --no-group-separator -oE '^@[^ ]+ '  ${o2} > ${index1}.${index2}.${session}.tmp.idx
n=$(cat  ${index1}.${index2}.${session}.tmp.idx |grep @|wc -l)
echo "created $n id by r2"

# 根据R2索引输出R1
cat  ${index1}.${session}.tmp.txt | grep  -A 3 --no-group-separator -F -f ${index1}.${index2}.${session}.tmp.idx > ${o1}
n=$(cat  ${o1} |grep @|wc -l)
echo "get $n record in r1"
rm -rf ${o1}.gz
rm -rf ${o2}.gz
gzip $o1
gzip $o2
rm -rf ${index1}.${session}.tmp.txt
rm -rf ${index1}.${session}.tmp.idx
rm -rf ${index1}.${index2}.${session}.tmp.idx

