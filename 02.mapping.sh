#!/bin/sh
start=`date +%s`
WD=/projects/whj-chenhm/pig/hair/
WD=/project-whj/zhuqy/20230814_bannajjx/38samples-NGS-data/
WD1=${WD}41samples.cleandata/copy/
REF=/project-whj/chm/pig/ref/Sus_scrofa.Sscrofa11.1.dna.toplevel.fa
WD2=${WD1}bam/
mkdir ${WD2}
cd ${WD2}
mkdir ${WD2}log
for SRA in  `ls ../Yucatan*.fq.gz | cut -d "_"  -f1-2 |cut -d "/" -f2  | uniq`
do
{
echo `date`
#trimmomatic PE -threads 1 -phred33 ${WD1}${SRA}_1.clean.fq.gz ${WD1}${SRA}_2.clean.fq.gz ${WD2}${SRA}_1.paired.fastq.gz ${WD2}${SRA}_1.unpaired.fastq.gz ${WD2}${SRA}_2.paired.fastq.gz ${WD2}${SRA}_2.unpaired.fastq.gz LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 
## map paired
bwa mem -t 2 -M -R  "@RG\tID:${SRA}\tLB:${SRA}\tPL:ILLUMINA\tSM:${SRA}" ${REF} ${WD2}${SRA}_1.paired.fastq.gz ${WD2}${SRA}_2.paired.fastq.gz | samtools view -bS -o ${WD2}${SRA}.pe.bam
cat ${WD2}${SRA}_1.unpaired.fastq.gz ${WD2}${SRA}_2.unpaired.fastq.gz >${WD2}${SRA}.se.fastq.gz
bwa mem -t 2 -M -R  "@RG\tID:${SRA}\tLB:${SRA}\tPL:ILLUMINA\tSM:${SRA}" ${REF} ${WD2}${SRA}.se.fastq.gz  | samtools view -bS -o ${WD2}${SRA}.se.bam

# rm ${WD2}${SRA}_1.paired.fastq.gz ${WD2}${SRA}_2.paired.fastq.gz
# rm ${WD2}${SRA}_1.unpaired.fastq.gz ${WD2}${SRA}_2.unpaired.fastq.gz 
# SortSam -I /projects/whj-chenhm/pig/labdata/cleandata/bam/Wildboar_SRR949645.pe.bam -O /projects/whj-chenhm/pig/labdata/cleandata/bam/Wildboar_SRR949645.pe.sort.bam -SORT_ORDER coordinate

picard -Xmx8g -Djava.io.tmpdir=${SRA}.pe SortSam I=${WD2}${SRA}.pe.bam O=${WD2}${SRA}.pe.sort.bam SORT_ORDER=coordinate
picard -Xmx8g -Djava.io.tmpdir=${SRA}.se SortSam I=${WD2}${SRA}.se.bam O=${WD2}${SRA}.se.sort.bam SORT_ORDER=coordinate
#rm ${SRA}_1.unpaired.fastq.gz ${SRA}_2.unpaired.fastq.gz ${SRA}.se.fastq.gz
samtools index ${WD2}${SRA}.se.sort.bam
samtools index ${WD2}${SRA}.pe.sort.bam


picard -Xmx8g -Djava.io.tmpdir=${SRA}.pe MarkDuplicates I=${WD2}${SRA}.pe.sort.bam O=${WD2}${SRA}.pe.sort.dedup.bam REMOVE_DUPLICATES=true METRICS_FILE=${WD2}${SRA}.pe.dedup.metrics VALIDATION_STRINGENCY=LENIENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=50
picard -Xmx8g -Djava.io.tmpdir=${SRA}.pe MarkDuplicates I=${WD2}${SRA}.se.sort.bam O=${WD2}${SRA}.se.sort.dedup.bam REMOVE_DUPLICATES=true METRICS_FILE=${WD2}${SRA}.se.dedup.metrics VALIDATION_STRINGENCY=LENIENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=50

samtools index ${WD2}${SRA}.pe.sort.dedup.bam
samtools index ${WD2}${SRA}.se.sort.dedup.bam

picard -Xmx8g MergeSamFiles  INPUT=${WD2}${SRA}.pe.sort.dedup.bam INPUT=${WD2}${SRA}.se.sort.dedup.bam  OUTPUT=${WD2}${SRA}.sus_scrofa.merge.sort.dedup.bam
samtools index ${WD2}${SRA}.sus_scrofa.merge.sort.dedup.bam

# rm -r ${WD2}${SRA}.pe* ${WD2}${SRA} ${WD2}${SRA}.se ${WD2}${SRA}.pe ${WD2}${SRA}.se*

} >./log/${SRA}.1.log 2>&1 &
 
done
wait

end=`date +%s`
echo "******bam done chm ****** TIME:`expr $end - $start`s"
