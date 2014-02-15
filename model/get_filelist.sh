ls -l /Users/qiuxe/data/stock | awk '{if($5!=0 && NR>1 )print $9;}' > filelist.xls 

