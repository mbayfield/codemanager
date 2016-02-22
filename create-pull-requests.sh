STARTTIME=$(date +%s)
echo $(date)
path=$(pwd)
# updateDeps='n'
# read -p "Update dependencies? [yn]: " updateDeps
cd ..
# echo "commit package changes"
for f in */; do
	if [[ -d $f ]]; then
		if [[ -d $f/.git/ ]]; then
			echo $f; # $f is a directory
			cd $f 
			
			git remote -v | grep 'upstream' &> /dev/null && {
				
				git status -v
				
				read -p "Add modified files? [yn]: " modified
				if [[ $modified = y ]]; 
					then
						git add -A
						git commit
				fi
				
				git status -v | grep 'Your branch is ahead' &> /dev/null && {
					
					ncu 
					ncu | grep 'upgrade package.json' &> /dev/null && {
						read -p "Update & commit dependencies? [yn]: " updateDeps
						if [[ $updateDeps = 'y' ]];
							then
								ncu -u
								git commit -m "package updates" -- package.json
						fi
					}
					
					read -p "Bump version? [yn]: " bump
					if [[ $bump = y ]]; 
						then
							npm version patch
							echo "version patched"
					fi
					
					read -p "Push changes? [yn]: " push
					# check if the pull-request should be made
					if [[ $push = y ]]; 
						then
							# push the changes
							git push origin master
							echo "pushed changes"
					fi
					
					read -p "Create pull-requests? [yn]: " pull
					if [[ $pull = y ]]; 
						then
							stash pull-request master upstream/master
							echo "pull-request created"
					fi
					
					echo "Local revision: " && npm run revision
					echo "NPM revision: " && npm info | jsawk -s 'return this.version'
					read -p "Publish to npm? [yn]: " npmPublish	
					if [[ $npmPublish = y ]]; 
						then
							npm publish
							echo "published"
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