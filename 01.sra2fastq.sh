#!/bin/sh
mkdir fastq
for i in `ls *.sra`
do
{
fastq-dump --split-files $i --gzip -O ./fastq
}  & 
done
wait
##
echo   `date`
mkdir fastqc
for  fp in `ls ./fastq/*fastq.gz | cut -d "/" -f3 | cut -d "_" -f1 | uniq`
do
{
fastp -i ./fastq/${fp}_1.fastq.gz -o ./fastqc/${fp}_1.clean.fastq.gz \
      -I ./fastq/${fp}_2.fastq.gz -O ./fastqc/${fp}_2.clean.fastq.gz \
 --thread=10 
}&
done
wait
echo   `date`
multiqc ./
