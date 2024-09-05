#!/bin/sh
filename=84-81.1_18.SNP.filtered.PASS.novariants.cluster.windows.wms.vcf.gz
WD=/projects/whj-chenhm/pig/labdata/05vcfnew/
WD6=/projects/whj-chenhm/pig/labdata/06vcf_pca/
gcta64=/projects/whj-chenhm/bin/gcta_1.94.0beta/gcta64
$gcta64 --thread-num 40 --make-grm --out ${WD6}${filename}.gcta --bfile  ${WD}${filename}  --autosome-num 18
$gcta64 --thread-num 40 --grm ${WD6}${filename}.gcta  --pca 20 --out ${WD6}${filename}.gcta &
plink  --chr-set 18  --noweb --bfile  ${WD}${filename}   --pca 20 --genome --out  ${WD6}${filename}

perl vcf_pca_tree.pl
###
filename=DNBN.1_18.SNP.filtered.PASS.novariants.cluster.windows.wms.vcf.gz
WD=/projects/whj-chenhm/pig/labdata/06vcf_diannan_banna/
WD6=/projects/whj-chenhm/pig/labdata/06vcf_pca/
gcta64=/projects/whj-chenhm/bin/gcta_1.94.0beta/gcta64

vcftools --gzvcf ${WD}${filename}  --plink --out ${WD}${filename} 
plink --noweb --file ${WD}${filename}  --make-bed --out ${WD}${filename} 
$gcta64 --thread-num 40 --make-grm --out ${WD6}${filename}.gcta --bfile  ${WD}${filename}  --autosome-num 18
$gcta64 --thread-num 40 --grm ${WD6}${filename}.gcta  --pca 20 --out ${WD6}${filename}.gcta &
plink  --chr-set 18  --noweb --bfile  ${WD}${filename}   --pca 20 --genome --out  ${WD6}${filename}

perl vcf_pca_tree.pl
