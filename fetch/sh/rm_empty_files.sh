output_dir="/Users/qiuxe/data/stock/"
codes=`ls ${output_dir}`
echo $codes
for code in ${codes} ; do
        output_file="${output_dir}${code}"
        if [ -s ${output_file} ] #FILE exists and has a size greater than zero, do nothing
        then
                echo "output file ${output_file} already exists and is not empty, do noting"
        else #file not exists or file is empty
                echo "rm ${output_file} ..."
		rm ${output_file}
        fi
done

