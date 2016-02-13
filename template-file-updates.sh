STARTTIME=$(date +%s)
echo $(date)
file='.nsprc'
path=$(pwd)
# updateDeps='n'
# read -p "Update dependencies? [yn]: " updateDeps
cd ..
echo "Updating all $file"
for f in */; do
	if [[ -d $f ]]; then
		if [[ -f $f/$file ]]; then
			echo $f; # $f is a directory
			cd $f 
			# echo $(pwd)
			cp $path/templates/$file $(pwd)/$file
			# ncu 
			# if [[ $updateDeps = 'y' ]];
			# 	then
			# 		ncu | grep 'upgrade package.json' &> /dev/null && {
			# 			read -p "Update package $f? [yn]: " answer
			# 			if [[ $answer = y ]]; 
			# 				then
			# 					ncu -u && npm install
			# 			fi
			# 		}
			# fi
			cd ..
		fi
	fi
done
ENDTIME=$(date +%s)
echo $(date)
echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
exit 1
;;