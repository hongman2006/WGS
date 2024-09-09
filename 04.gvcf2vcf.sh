#!/bin/sh
#04vcf******************************************************************************************************************
REF=/project-whj/chm/pig/ref/Sus_scrofa.Sscrofa11.1.dna.toplevel.fa
# /project-whj/zhuqy/20230814_bannajjx/38samples-NGS-data/03gvcf/chmvcf
WD=/project-whj/zhuqy/20230814_bannajjx/38samples-NGS-data/
WD3=${WD}03gvcf/chmvcf
WD4=${WD}04vcf_c14
WD5=${WD}05vcf_raw14
mkdir ${WD4} ${WD5}
tail=.Sscrofa11.1.sort.dedup.g.vcf.gz
tailr=.Sscrofa11.1.raw.vcf.gz
cd ${WD4}
cp ${WD}chr.list ${WD4}
cp ${WD}sample.list ${WD4}
#/projects/whj-chenhm/pig/hair/03vcf/H1/H1.chr_1.Sscrofa11.1.sort.dedup.g.vcf.gz
##################### 
for n in 14
do
cd ${WD4}
ls -d ${WD3}/*/*chr${n}.*gz   >chr_${n}.list
done
for i in 14
do
{
echo `date`
gatk CombineGVCFs -R ${REF} -V  ${WD4}/chr_${i}.list -O  ${WD4}/chr_${i}${tail}
echo `date`
} > ${WD4}/chr_${i}.log 2>&1 &
done
wait
echo `date`
# ##########################
for n in 14
do
{
cd ${WD4}
echo `date`
start=`date +%s`
gatk GenotypeGVCFs -R ${REF} -V ${WD4}/chr_${n}${tail} -O  ${WD5}/chr_${n}${tailr} 
# #########################
cd ${WD5}
filename=chr_${n}${tailr} 
OUT=chr_${n}.Sscrofa11.1
mkdir ./step03.tempdir.gatk/${n}


maxmem=25

if [ ! -s "${OUT}.SNP.vcf.gz.tbi" ]; then
    gatk --java-options "-Xmx${maxmem}g" SelectVariants -R ${REF} -V ${filename} -select-type SNP -O ${OUT}.SNP.vcf.gz
fi

if [ ! -s "${OUT}.INDEL.vcf.gz.tbi" ]; then
    gatk --java-options "-Xmx${maxmem}g" SelectVariants -R ${REF} -V ${filename} -select-type INDEL -O ${OUT}.INDEL.vcf.gz
fi

#       --filterExpression "QUAL < 50.0 && QUAL >= 30.0" --filterName "QUAL_lt50_gt30"
if [ ! -s "${OUT}.SNP.filtered.vcf.gz.tbi" ]; then
   gatk --java-options "-Xmx${maxmem}g" VariantFiltration \
       -R ${REF} \
       -V ${OUT}.SNP.vcf.gz \
       -O ${OUT}.SNP.filtered.vcf.gz \
       --filter-expression "QUAL < 30.0" --filter-name "QUAL_lt30" \
       --filter-expression "QD < 2.0" --filter-name "QD_lt2" \
       --filter-expression "MQ < 40.0" --filter-name "MQ_lt40" \
       --filter-expression "FS > 60.0" --filter-name "FS_gt60" \
       --filter-expression "MQRankSum < -12.5" --filter-name "MQRS_ltn12.5" \
       --filter-expression "ReadPosRankSum < -8.0" --filter-name "RPRS_ltn8"
fi



if [ ! -s "${OUT}.filtered.PASS.vcf.gz.tbi" ];  then
    bcftools view -f PASS -m 2 -M 2 -O z -o ${OUT}.SNP.filtered.PASS.vcf.gz ${OUT}.SNP.filtered.vcf.gz
    tabix ${OUT}.SNP.filtered.PASS.vcf.gz
 
fi

echo [`date`]INFO: finished!
exit 0
end=`date +%s`
echo "Combine_done_chm TIME:`expr $end - $start`s"
echo `date`
}> ${WD5}/${n}.log 2>&1 &
done
wait
echo `date`
