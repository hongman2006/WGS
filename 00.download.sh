#!/bin/sh
echo `date`
start=`date +%s`
REF=/project-whj/software/pig.genome.refence/Sscrofa11.1/Sscrofa11.1_genomic.fa
WD=/project-whj/zhuqy/20230814_bannajjx/38samples-NGS-data/
WD2=${WD}41samples.cleandata/copy/dse/bam/
WD3=${WD}03vcf/
mkdir ${WD3}
#DSE_CRR025077.sus_scrofa.merge.sort.dedup.bam

tail=.sus_scrofa.merge.sort.dedup.bam
cd ${WD3}
cp ${WD}chr.list ${WD3}
for sample in `ls ${WD2}*.sus_scrofa.merge.sort.dedup.bam | cut -d "/" -f10 | cut -d "." -f1`
do
mkdir ${sample} 
for SRA in `cat chr.list`
do

gatk  HaplotypeCaller --tmp-dir ./${sample}/ -R ${REF}  -I ${WD2}${sample}${tail} -O ./${sample}/${sample}.chr_${SRA}.Sscrofa11.1.sort.dedup.g.vcf.gz -ERC GVCF  -L ${SRA}  >${sample}.chr_${SRA}.log 2>&1 &
done
done
end=`date +%s`
echo "******gvcf done chm ****** TIME:`expr $end - $start`s"
echo `date`
