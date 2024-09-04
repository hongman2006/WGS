#!/bin/bash
filename=list.85-81.1_18.SNP.filtered.PASS.novariants.cluster.windows.wms.ld502502.vcf.gz
for ex in `ls *.$filename.map | cut -d "." -f1 | grep -v A3 | grep -v BM`
do
bash  script_GONE.sh $ex.$filename 
done
