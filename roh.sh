WD6=/projects/whj-chenhm/pig/labdata/05vcfnew
WD65=$WD6/bethshapiro

mkdir ${WD65} 
#/project-whj/chm/pig/labdata/yaqi_vcf/final_rawVariant.vcf.gz
cd $WD6
geno=85.1_18.SNP.filtered.PASS.vcf.gz
geno2=85.1_18.SNP.filtered.PASS.novariants.vcf.gz
geno3=85-82.1_18.SNP.filtered.PASS.novariants.cluster.windows.wms.vcf.gz
for K in  $geno $geno2
do 
{
# vcftools --gzvcf ${K} --plink --out ${WD6}/${K}
# plink --noweb --file ${WD6}/${K} --make-bed --out ${WD6}/${K}

# plink --bfile ${WD6}/${K} --homozyg --homozyg-kb 50 --homozyg-window-snp 50  --homozyg-snp 20 --homozyg-gap 1000 --allow-extra-chr --out ${WD66}/yaqi.${K}

# plink --file ${WD6}/${K} --homozyg --homozyg-window-snp 20 --homozyg-kb 10 -allow-no-sex --noweb --homozyg-window-het 1 --homozyg-window-missing 20 --out ${WD67}/wgs.${K}
 plink --file ${WD6}/${K} --homozyg-window-het 20 --homozyg-window-missing 20 --homozyg-window-threshold 0.02 --homozyg-het 750 --homozyg-kb 500  --out ${WD65}/bethshapiro.${K}

}> ${WD6}/${K}.log &
done

for K in  $geno3
do 
{
vcftools --gzvcf ${K} --plink --out ${WD6}/${K}
plink --noweb --file ${WD6}/${K} --make-bed --out ${WD6}/${K}

# plink --bfile ${WD6}/${K} --homozyg --homozyg-kb 50 --homozyg-window-snp 50  --homozyg-snp 20 --homozyg-gap 1000 --allow-extra-chr --out ${WD66}/yaqi.${K}

# plink --file ${WD6}/${K} --homozyg --homozyg-window-snp 20 --homozyg-kb 10 -allow-no-sex --noweb --homozyg-window-het 1 --homozyg-window-missing 20 --out ${WD67}/wgs.${K}
 plink --file ${WD6}/${K} --homozyg-window-het 20 --homozyg-window-missing 20 --homozyg-window-threshold 0.02 --homozyg-het 750 --homozyg-kb 500  --out ${WD65}/bethshapiro.${K}

}> ${WD6}/${K}.log &
done
