#!/bin/sh
REF=/projects/whj-chenhm/RNA-seq/pigtest/00ref/Sus_scrofa.Sscrofa11.1.dna.toplevel.fa
gatk=/projects/software/anaconda3/share/gatk4-4.2.6.1-1/gatk-package-4.2.6.1-local.jar
WD=/projects/whj-chenhm/pig/labdata/05vcfnew
filename=SNP.filtered.PASS
# 85.SNP.filtered.PASS.vcf.gz
TMPDIR=$WD/tmp
mkdir $TMPDIR
# tabix 85.${filename}.vcf.gz 
java -Xms80g -Xmx120g -Djava.io.tmpdir=$TMPDIR -jar $gatk SelectVariants --exclude-non-variants \
       -R ${REF} \
       -V 85.${filename}.vcf.gz \
       -O 85.${filename}.novariants.wms.vcf.gz &

java -Xms80g -Xmx120g -Djava.io.tmpdir=$TMPDIR -jar $gatk SelectVariants --exclude-non-variants \
       -R ${REF} \
       -V 85.${filename}.vcf.gz \
       -O 85-82.${filename}.novariants.wms.vcf.gz \
       --sample-name 82sample.list 
echo "extract finished: $(date) chenhongman"
