#url_example: http://ichart.finance.yahoo.com/table.csv?s=YHOO&a=03&b=12&c=1996&d=09&e=5&f=2013&g=d&ignore=.csv
url_head='http://ichart.finance.yahoo.com/table.csv?s=';
url_tail='&a=03&b=12&c=1996&d=09&e=5&f=2013&g=d&ignore=.csv'; # not necessary, specify time interval

codes=`awk 'BEGIN{FS=","}{if($1>=600000){printf("%s.ss ",$1);}else{printf("%s.sz ",$1);}}' corp_codes.csv`
output_dir="/Users/qiuxe/data/stock/"
for code in ${codes} ; do
	url=${url_head}${code}
	output_file="${output_dir}${code}.csv"
	if [ -s ${output_file} ] #FILE exists and has a size greater than zero, do nothing
	then
		echo "output file ${output_file} already exists and is not empty, do noting"
	else #file not exists or file is empty
		echo "fetching data from ${url} ..." 
		curl "${url}" > /Users/qiuxe/data/stock/${code}.csv &
		sleep 1
	fi
done
sleep 10
ls -l -S ${output_dir} | awk '{line++; size+=$5; if($5==0){cnt++;}}END{printf("total %d, empty %d, size %d MB\n",line,cnt,size/(1024*1024));}' 
exit



