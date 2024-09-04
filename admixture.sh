#!/bin/sh
INWD=/project-whj/zhuqy/20230814_bannajjx/38samples-NGS-data/06vcf_ld
OUTWD=/project-whj/zhuqy/20230814_bannajjx/38samples-NGS-data/06vcf_admixture
filename=85-82.1_18.SNP.filtered.PASS.novariants.cluster.windows.wms.vcf.gz
# plink   --allow-extra-chr  -bfile  $INWD/${filename}  --indep-pairwise  50 25 0.2 --chr-set 18 --out ld.${filename}-502502  --double-id
# plink  --allow-extra-chr   --chr-set 18  -bfile   $INWD/${filename}  --extract  ld.${filename}-502502.prune.in  --make-bed --out  ld.${filename}-502502 --double-id
# plink  --allow-extra-chr --chr-set 18  -bfile  ld.${filename}-502502  --geno 0.2   --make-bed --out  ld.QC.${filename}-502502-geno02  --double-id #  --geno 0.2 > 20% 

for num in $(shuf -i 1-99999 -n 10) 
do
test=$OUTWD/$num
mkdir $test
cd  $test
for K in  $(seq 1 10)
do 
{
echo `date`
admixture --cv  $OUTWD/ld.QC.${filename}-502502-geno02.bed $K -s $num -j5 | tee  $test/log${K}.out
echo `date`
} >$test/$k.log &
done
wait
# 
grep -h CV log*.out | sort -t= -k2n |  awk -F "=" '{print $0 "\t"$2}' | awk -F ")" '{print $1 ")"$2}' | cut -d ":" -f1-2 > cv.list

#
touch cv_script.R | echo 'cv <- read.table("cv.list")
library(ggplot2)
p <- ggplot(cv)+geom_line(aes(x=V5,y=V4))+geom_point(aes(x=V5,y=V4))+theme_bw()
ggsave(filename="cv.png")' >cv_script.R

Rscript cv_script.R
done

##
source activate Perl5

export PERL5LIB=$PERL5LB:/home/wangms/00.software/CLUMPAK/CLUMPAK

ln -s /home/wangms/00.software/CLUMPAK/CLUMPAK/CLUMPP .
ln -s /home/wangms/00.software/CLUMPAK/CLUMPAK/distruct .
ln -s /home/wangms/00.software/CLUMPAK/CLUMPAK/fonts .
ln -s /home/wangms/00.software/CLUMPAK/CLUMPAK/mcl . 

1. Move Q-marix to K folder using:
for y in {1..10}
do
rm -R  K-$y
mkdir K-$y
for i in 17201 8380 21298 2999 32719 35152 36385 49012 57087 82037
do

cp $i/ld.QC.85-82.1_18.SNP.filtered.PASS.novariants.cluster.windows.wms.vcf.gz-502502-geno02.$y.Q K-$y/$i-ld.QC.85-82.1_18.SNP.filtered.PASS.novariants.cluster.windows.wms.vcf.gz-502502-geno02.$y.Q
done
done

2. move K_x folder to the folder chenmanK1-10, and then zip in the windows:
 get the chenmanK1-10.zip

3. run CLUMPAK.pl

perl /home/wangms/00.software/CLUMPAK/CLUMPAK/CLUMPAK.pl --id 2 --dir K-1-CLUMPAK-result  --file chenmanK1-10.zip --inputtype admixture


step 4. 
for i in {1..10}
do
cat K-1-CLUMPAK-result/2/K=${i}/CLUMPP.files/ClumppIndFile.output | cut -d ":" -f 2 | sed 's/^ *//g' >CLUMP.ld.QC.85-82.1_18.SNP.filtered.PASS.novariants.cluster.windows.wms.vcf.gz-502502-geno02.${i}.Q
#mv CLUMP.152RJF_693dom.mv3.no3.autos.withMinor_prunedData_pairwise.${i}.Q CLUMP.noGGB.152RJF_693dom.mv3.no3.autos.withMinor_prunedData_pairwise.${i}.Q
done

