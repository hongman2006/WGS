#!/bin/sh
InDir=/projects/whj-chenhm/pig/labdata/05vcfnew
FilePre=85-84.1_18.SNP.filtered.PASS.novariants.cluster.windows.wms
ScriptDir=$InDir
OutDir=$InDir
vcftools --gzvcf $InDir/$FilePre.vcf.gz --recode --stdout | perl -lane '@f=split/\s+/;if((/^#/)||((length $f[3]==1)&&(length $f[4]==1))){print;}' | perl $ScriptDir/vcf2fasta.byHUANG.pl > $OutDir/$FilePre.fa
filepre=85-84.1_18.SNP.filtered.PASS.novariants.cluster.windows.wms
raxmlHPC-PTHREADS-SSE3 -T 40  -x 12345 -p 12345 -k -# 100 -o ERR2984771  -m GTRGAMMA -s $filepre.fa -f a -n $filepre.raxml.tre   
