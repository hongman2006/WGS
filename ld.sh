#!/bin/sh
PopLDdecay=/projects/whj-chenhm/bin/PopLDdecay/bin/PopLDdecay
WD=/home/whj-chenhm/inbred/06vcf_ld
IPWD=/home/whj-chenhm/inbred/05vcfnew
file=85-81.1_18.SNP.filtered.PASS.novariants.cluster.windows.wms.vcf.gz
listWD=/home/whj-chenhm/inbred/06vcf_diannan_banna

for sub in `ls $listWD/*.list | grep -v UNBN.list | grep -v BN.list | grep -v DNBN.list | grep -v sample.list | xargs -I {} basename {} `
do
{
$PopLDdecay -InVCF  $IPWD/$file  -OutStat ${sub}.${file}  -SubPop $listWD/${sub}
} > ${sub}.log &
done
wait
ls *.vcf.stat.gz |awk  -F "." '{print $0"\t"$1}' > Pop.txt
Plot_OnePop=/projects/whj-chenhm/bin/PopLDdecay/bin/Plot_OnePop.pl
Plot_MultiPop=/projects/whj-chenhm/bin/PopLDdecay/bin/Plot_MultiPop.pl
perl $Plot_MultiPop  -inList  Pop.txt -output sub_Fig
