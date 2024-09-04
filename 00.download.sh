#!/bin/sh
echo `date`
start=`date +%s`
for i in `ls *.txt` 
do
{
prefetch  $i
} &
done
wait
end=`date +%s`
echo "******download done chm ****** TIME:`expr $end - $start`s"
echo `date`
