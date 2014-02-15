cat results.xls | awk '{if($2>5 && $1>10 && $1<30 && $4!~/300/)print $0;}' | sort -n -k 3 > tmp
codes=`cat tmp | awk '{code=substr($4,0,6); if(code>=600000){printf("%s.sh ",code);}else{printf("%s.sz ",code);} }'`
for code in $codes ; do
	url="http://bdcjhq.hexun.com/quote?s2=${code}";
	#echo $code >> codes_pe.xls
	curl ${url} | awk 'BEGIN{FS="sy:\"";}{print $2;}' | awk -v code=$code 'BEGIN{FS="\",lt:";}{printf("%s\t%f\n",code,$1);}' >> codes_pe.xls 
done

 
