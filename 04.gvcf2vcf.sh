#!/bin/sh
#04vcf******************************************************************************************************************
REF=/project-whj/chm/pig/ref/Sus_scrofa.Sscrofa11.1.dna.toplevel.fa
gatk=/project-whj/software/anaconda3/share/gatk4-4.3.0.0-0/gatk-package-4.3.0.0-local.jar
# /project-whj/zhuqy/20230814_bannajjx/38samples-NGS-data/03gvcf/chmvcf
WD=/project-whj/zhuqy/20230814_bannajjx/38samples-NGS-data/
WD3=${WD}03gvcf/chmvcf
WD4=${WD}04vcf_c
WD5=${WD}05vcf_raw2
TMPDIR=$WD4/tmp
mkdir ${WD4} ${WD5} ${TMPDIR}
tail=.Sscrofa11.1.sort.dedup.g.vcf.gz
tailr=.Sscrofa11.1.raw.vcf.gz
cd ${WD4}
cp ${WD}chr.list ${WD4}
cp ${WD}sample.list ${WD4}
#/projects/whj-chenhm/pig/hair/03vcf/H1/H1.chr_1.Sscrofa11.1.sort.dedup.g.vcf.gz
#######combine_gvcf############### 
for n in `cat chr.list`
do
cd ${WD4}
ls -d ${WD3}/*/*chr${n}.*gz   >chr_${n}.list
done
for i in `cat chr.list`
do
{
echo `date`
java -Xms20g -Xmx30g -Djava.io.tmpdir=$TMPDIR -jar $gatk CombineGVCFs -R ${REF} -V  ${WD4}/chr_${i}.list -O  ${WD4}/chr_${i}${tail}
echo `date`
} > ${WD4}/chr_${i}.log 2>&1 &
done
wait
echo `date`

