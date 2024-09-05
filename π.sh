WD=/projects/whj-chenhm/pig/labdata/05vcfnew
filename=85-81.1_18.SNP.filtered.PASS.novariants.cluster.windows.wms.vcf.gz
WD6=/projects/whj-chenhm/pig/labdata/06vcf_diversity/
INWD=/projects/whj-chenhm/pig/labdata/06vcf_diannan_banna
mkdir $WD6 
cd $WD6 
# sh mkdir_file.sh
# for  group in  `ls *.txt`
for  group in $INWD/BN.list $INWD/DNBN.list
do
{
vcftools --gzvcf $WD/$filename --keep $group --window-pi 100000 --out pi$group
vcftools --gzvcf $WD/$filename --keep $group --window-pi 100000 --window-pi-step 25000 --out pi-set$group
} > ${group}.log &
done
wait
