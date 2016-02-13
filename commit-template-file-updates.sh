STARTTIME=$(date +%s)
echo $(date)
file='.nsprc'
path=$(pwd)
# updateDeps='n'
# read -p "Update dependencies? [yn]: " updateDeps
cd ..
# echo "commit package changes"
read -p "Push changes? [yn]: " push
read -p "Create pull-requests? [yn]: " answer
for f in */; do
	if [[ -d $f ]]; then
		if [[ -f $f/$file && -d $f/.git/ ]]; then
			echo $f; # $f is a directory
			cd $f 
			
			# git status -s
			
			# git add $file
			
			git status -s | grep $file &> /dev/null && {
				
				# commit the changes
				git commit -m "$file updates" -- $file
				
				if [[ $push = y ]]; 
					then
						# push the changes
						git push origin master
						echo "pushed $file update"
				fi
				
				# check for an upstream remote
				git remote -v | grep 'upstream' &> /dev/null && {
					
					# check if the pull-request should be made
					
					if [[ $answer = y ]]; 
						then
							stash pull-request master upstream/master
							echo "pull-request created"
					fi
				}
			}
			cd ..
		fi
	fi
done
ENDTIME=$(date +%s)
echo $(date)
echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
exit 1
;;