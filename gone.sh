#!/bin/bash
for ex in `ls *.list | sed "s|.list||g"`
do
bash  script_GONE.sh $ex.$tail.thin50.vcf.gz 
done
