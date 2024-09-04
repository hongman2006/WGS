provean=/home/whj-chenhm/inbred/06vcf_annovar/annovar/provean/PROVEAN.85-81.1_18.SNP.filtered.PASS.novariants.cluster.windows.wms.vcf.tab
num=$(awk '{print NF ;exit}' $provean)
for i in $(seq 4 $num)
do
filename=$(awk 'NR==1 {print $'$i'}' $provean)
# awk 'NR > 1 {print $1"\t"$2"\t"$3"\t"$'$i'}' $provean | awk -F "/" '{print $1"\t"$2"\t"$3"\t"$4}' | awk '($3 != $4 && $4!= "." && $4==$5)  {print $1"\t"$2"\t"$3"\t"$4"/"$5}' > $filename.deleterious
awk 'NR > 1 {print $1"\t"$2"\t"$3"\t"$'$i'}' $provean | awk -F "/" '{print $1"\t"$2"\t"$3"\t"$4}' | awk '($3 != $4 && $4!= "." && $4==$5)  {print $1"\t"$2"\t"$2}' > $filename.deleterious.1
done
# rm *.deleterious
# # for list in $(ls /home/whj-chenhm/inbred/06deleterious2rohisland/*.deleterious)
# # do
# # awk '{print $1"\t"$2"\t"$2}'  $list > $list.1
# # done
#
WD=/home/whj-chenhm/inbred/06roh/bethshapiro/island_segment

for roh in `ls $WD/*.txt.bed | xargs -I {} basename {} | cut -d "." -f1`
do
bedtools intersect -a $roh.deleterious.1 -b $WD/$roh.txt.bed > $roh.deleterious.roh.list
done

# intersectBed -a $island -b $list.1 -wb 

#

for family in `ls $WD/*.list | xargs -I {} basename {} | grep -v UNBN.list`
do
for sample in $(cat $WD/$family | cut -d "." -f1)
do
bedtools intersect -b $WD/$family.island.bed -a $sample.deleterious.1 > $sample.$family.deleterious.roh.island.list
done
done

wc -l *.deleterious.1 | sed 's/.deleterious.1//g' >1.txt
wc -l *.deleterious.roh.list | sed 's/.deleterious.roh.list//g' >2.txt 
wc -l *.list.deleterious.roh.island.list | sed 's/.list.deleterious.roh.island.list//g' >3.txt
paste 3.txt 1.txt 2.txt > deleterious.roh.island.state

rm 3.txt 1.txt 2.txt 
touch head | echo "   breed.ROH_island_del sample	   del_num sample	   ROH_del sample" > head
cat head deleterious.roh.island.state > deleterious.roh.island.resulte.state
# awk '{print$6"\t"$5"\t"$3"\t"$5/$3"\t"$2"\t"$1}' deleterious.roh.island.state
#
for roh in `ls $WD/*.txt.bed | xargs -I {} basename {} | cut -d "." -f1`
do
bedtools intersect -a $roh.deleterious.1 -b $WD/$roh.txt.bed -wb > $roh.deleterious.roh.segment.list
done
for seg in `ls *.deleterious.roh.segment.list`
do
awk '{a[$4"\t"$5"\t"$6]++} END {for (i in a) {print i"\t"a[i]}}' $seg | awk '{ print$0"\t"($3-$2)/1000000}'    > $seg.state
awk '{ print FILENAME"\t"$0 }' $seg.state | sed 's/.deleterious.roh.segment.list.state//g' >  $seg.result
rm $seg.state
done
#
cat *.deleterious.roh.segment.list.result > deleterious.roh.segment.result


# 
provean=/home/whj-chenhm/inbred/06vcf_annovar/annovar/provean/PROVEAN.85-81.1_18.SNP.filtered.PASS.novariants.cluster.windows.wms.vcf.tab
num=$(awk '{print NF ;exit}' $provean)
for i in $(seq 4 $num)
do
filename=$(awk 'NR==1 {print $'$i'}' $provean)
# awk 'NR > 1 {print $1"\t"$2"\t"$3"\t"$'$i'}' $provean | awk -F "/" '{print $1"\t"$2"\t"$3"\t"$4}' | awk '($3 != $4 && $4!= "." && $4==$5)  {print $1"\t"$2"\t"$3"\t"$4"/"$5}' > $filename.deleterious
awk 'NR > 1 {print $1"\t"$2"\t"$3"\t"$'$i'}' $provean | awk -F "/" '{print $1"\t"$2"\t"$3"\t"$4}' | awk '($4 != $5 && $4!= "." && $5!= ".")  {print $1"\t"$2"\t"$2"\t"$3"\t"$4"\t"$5}' > $filename.deleterious.1
done
#
WD=/home/whj-chenhm/inbred/06roh/bethshapiro/island_segment
for roh in `ls $WD/*.txt.bed | xargs -I {} basename {} | cut -d "." -f1`
do
bedtools intersect -a $roh.deleterious.1 -b $WD/$roh.txt.bed > $roh.het.deleterious.roh.list
done
#

for family in `ls $WD/*.list | xargs -I {} basename {} | grep -v UNBN.list | grep -v BNI.list`
do
for sample in $(cat $WD/$family | cut -d "." -f1)
do
bedtools intersect -b $WD/$family.island.bed -a $sample.deleterious.1 > $sample.$family.deleterious.roh.het.island.list
done
done

wc -l *.deleterious.1 | sed 's/.deleterious.1//g' >1.het.txt
wc -l *.het.deleterious.roh.list | sed 's/.deleterious.roh.list//g' >2.het.txt 
wc -l *.list.deleterious.roh.het.island.list | sed 's/.list.deleterious.roh.het.island.list//g' >3.het.txt 
paste 3.het.txt 2.het.txt 1.het.txt | awk -v OFS='\t' ""'{print $2,$1,$3,$5}'> deleterious.het.island.roh.all.state
touch head | echo "sample   hetROHisland    hetROH hetalldeleterious" > head
cat head deleterious.het.island.roh.all.state > deleterious.roh.island.het.resulte.state
rm 3.het.txt 2.het.txt 1.het.txt head deleterious.het.island.roh.all.state

# 
for roh in `ls $WD/*.txt.bed | xargs -I {} basename {} | cut -d "." -f1`
do
bedtools intersect -a $roh.deleterious.1 -b $WD/$roh.txt.bed -wb > $roh.deleterious.roh.het.segment.list
done
for seg in `ls *.deleterious.roh.het.segment.list`
do
awk '{a[$7"\t"$8"\t"$9]++} END {for (i in a) {print i"\t"a[i]}}' $seg | awk '{ print$0"\t"($3-$2)/1000000}'    > $seg.het.state
awk '{ print FILENAME"\t"$0 }' $seg.het.state | sed 's/.deleterious.roh.het.segment.list.het.state//g' >  $seg.het.result
rm $seg.het.state
done
# 
touch head | echo "sample   chr    start    end    het.num  length(Mb)" > head
cat head *.deleterious.roh.het.segment.list.het.result > deleterious.roh.segment.het.result

# 
provean=/home/whj-chenhm/inbred/06vcf_annovar/annovar/provean/PROVEAN.85-81.1_18.SNP.filtered.PASS.novariants.cluster.windows.wms.vcf.tab
num=$(awk '{print NF ;exit}' $provean)
for i in $(seq 4 $num)
do
filename=$(awk 'NR==1 {print $'$i'}' $provean)
# awk 'NR > 1 {print $1"\t"$2"\t"$3"\t"$'$i'}' $provean | awk -F "/" '{print $1"\t"$2"\t"$3"\t"$4}' | awk '($3 != $4 && $4!= "." && $4==$5)  {print $1"\t"$2"\t"$3"\t"$4"/"$5}' > $filename.deleterious
awk 'NR > 1 {print $1"\t"$2"\t"$3"\t"$'$i'}' $provean | awk -F "/" '{print $1"\t"$2"\t"$3"\t"$4}' | awk '(($3 != $5 || $3 != $4) && $4!= "." && $5!= ".")  {print $1"\t"$2"\t"$2"\t"$3"\t"$4"\t"$5}' > $filename.deleterious.1
done
# 
for roh in `ls $WD/*.txt.bed | xargs -I {} basename {} | cut -d "." -f1`
do
bedtools intersect -a $roh.deleterious.1 -b $WD/$roh.txt.bed -wb > $roh.deleterious.roh.hom_het.segment.list
done
for seg in `ls *.deleterious.roh.hom_het.segment.list`
do
awk '{a[$7"\t"$8"\t"$9]++} END {for (i in a) {print i"\t"a[i]}}' $seg | awk '{ print$0"\t"($3-$2)/1000000}'    > $seg.hom_het.state
awk '{ print FILENAME"\t"$0 }' $seg.hom_het.state | sed 's/.deleterious.roh.hom_het.segment.list.hom_het.state//g' >  $seg.hom_het.result
rm $seg.hom_het.state
done
# 
touch head | echo "sample   chr    start    end    hom_het.num  length(Mb)" > head
cat head *.deleterious.roh.hom_het.segment.list.hom_het.result > deleterious.roh.segment.hom_het.result
ls *BNI.list.* | xargs -I {} awk '{ print $0"\t"FILENAME}' {} | sed 's/.BNI.list.deleterious.roh.island.list//g' > BNI.list.deleterious.roh.island.list
# 
bed=/home/whj-chenhm/hair/06vcf_fst/ensemble.sus.scrofa20230613.bed
bedtools intersect -a $bed -b BNI.list.deleterious.roh.island.list | awk '!seen[$1,$2,$3,$4]++' > BNI.list.deleterious.roh.island.gene.list 
