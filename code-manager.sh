#!/bin/bash

# command -v ncu >/dev/null 2>&1 || { echo "I require ncu but it's not installed.  Aborting." >&2; exit 1; }

echo "Select option:"
echo "1) check all/update dependencies"
echo "2) dependency checker"
echo "3) commit package changes"
echo "4) git fetch & pull all"
echo "5) run eslint"
echo "6) run nsp"
echo "7) git remote check"
echo "8) run unit tests"
echo "9) run code coverage"
echo "10) git status check"
echo "11) clean node_modules folder"
echo "12) list global npm packages"
echo "13) Bump version"
echo "14) run eslint fix"
echo "15) Push changes - create pull requests"
echo "16) npm rebuild"
echo "17) exit"
read case;

# Go up a directory
cd ..

declare -a projects

# cd ..
for i in $(ls -d */); do 
	if [[ -f $i/package.json && -d $i/.git/ ]]; then
		projects+=("${i%%/*}")
	fi
done



case $case in
	1) # check all/update dependencies
		STARTTIME=$(date +%s)
		echo $(date)
		updateDeps='n'
		read -p "Update dependencies? [yn]: " updateDeps
		echo "Checking dependencies"
		for f in "${projects[@]}"; do
			if [[ -d $f ]]; then
				if [[ -f $f/package.json ]]; then
					echo $f; # $f is a directory
					cd $f 
					ncu 
					if [[ $updateDeps = 'y' ]];
						then
							ncu | grep 'upgrade package.json' &> /dev/null && {
								# read -p "Update package $f? [yn]: " answer
								# if [[ $answer = y ]]; 
									# then
								ncu -u #&& npm install
								# fi
							}
					fi
					cd ..
				fi
			fi
		done
		ENDTIME=$(date +%s)
		echo $(date)
		echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
		exit 1
		;;
		
	2) # dependency checker
		echo "Updating dependencies"
		for f in "${projects[@]}"; do
			if [[ -d $f ]]; then
				if [[ -f $f/package.json ]]; then
					echo $f; # $f is a directory
					cd $f 
					dependency-check ./package.json --unused 
					cd ..
				fi
			fi
		done
		exit 1
		;;
	3) # commit package changes
		STARTTIME=$(date +%s)
		echo $(date)
		echo "commit package changes"
		read -p "Push changes? [yn]: " push
		read -p "Create pull-requests? [yn]: " answer
		for f in "${projects[@]}"; do
			if [[ -d $f ]]; then
				if [[ -f $f/package.json && -d $f/.git/ ]]; then
					echo $f; # $f is a directory
					cd $f 
					
					git status -s | grep 'package.json' &> /dev/null && {
						
						# commit the changes
						git commit -m "dependency updates" -- package.json
						
						if [[ $push = y ]]; 
							then
								# push the changes
								git push origin master
								echo 'pushed package update'
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
	4) # git fetch & pull all
		STARTTIME=$(date +%s)
		echo $(date)
		echo "Fetching latest from git"
		for f in "${projects[@]}"; do
			if [[ -d $f ]]; then
				if [[ -d $f/.git/ ]]; then
					echo $f; # $f is a directory
					cd $f 
					git fetch origin && git pull origin || true
					#npm install 
					# git fetch upstream && git pull upstream master || true
					cd ..
				fi
			fi
		done
		ENDTIME=$(date +%s)
		echo $(date)
		echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
		exit 1
		;;
	5) # run eslint
		STARTTIME=$(date +%s)
		echo $(date)
		echo "Running eslint"
		for f in "${projects[@]}"; do
			if [[ -d $f ]]; then
				if [[ -f $f/package.json && -d $f/.git/ ]]; then
					echo $f; # $f is a directory
					cd $f && npm install && npm run lint || true && cd ..
				fi
			fi
		done
		ENDTIME=$(date +%s)
		echo $(date)
		echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
		exit 1
		;;
	6) # run nsp
		STARTTIME=$(date +%s)
		echo $(date)
		echo "Running nsp check"
		for f in "${projects[@]}"; do
			if [[ -d $f ]]; then
				if [[ -f $f/package.json && -d $f/.git/ ]]; then
					echo $f; # $f is a directory
					cd $f && nsp check || true && cd ..
				fi
			fi
		done
		ENDTIME=$(date +%s)
		echo $(date)
		echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
		exit 1
		;;
	7) # git remote
		STARTTIME=$(date +%s)
		echo $(date)
		echo "Running git remote"
		for f in "${projects[@]}"; do
			if [[ -d $f ]]; then
				if [[ -d $f/.git/ ]]; then
					echo $f; # $f is a directory
					cd $f && git remote -v && cd ..
				fi
			fi
		done
		ENDTIME=$(date +%s)
		echo $(date)
		echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
		exit 1
		;;
	8) # run unit tests
		STARTTIME=$(date +%s)
		echo $(date)
		echo "Running tests"
		for f in "${projects[@]}"; do
			if [[ -d $f ]]; then #&& $f == 'environment/' 
				if [[ -f $f/package.json && -d $f/.git/ -d $f/test/ ]]; then
					echo $f; # $f is a directory
					cd $f && npm install && npm run test || true && cd ..
				fi
			fi
		done
		ENDTIME=$(date +%s)
		echo $(date)
		echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
		exit 1
		;;
	9) # run code coverage
		STARTTIME=$(date +%s)
		echo $(date)
		echo "Running coverage reports"
		for f in "${projects[@]}"; do
			if [[ -d $f ]]; then #&& $f == 'environment/' 
				if [[ -f $f/package.json && -d $f/.git/ ]]; then
					echo $f; # $f is a directory
					cd $f && npm install && npm run cover || true && cd ..
				fi
			fi
		done
		ENDTIME=$(date +%s)
		echo $(date)
		echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
		exit 1
		;;
	10) # git status
		STARTTIME=$(date +%s)
		echo $(date)
		echo "git status"
		for f in "${projects[@]}"; do
			if [[ -d $f ]]; then
				if [[ -f $f/package.json && -d $f/.git/ ]]; then
					echo $f; # $f is a directory
					cd $f #&& ncu -u 
					git status -v
					# git status -s #| grep 'package.json' &> /dev/null && {
					# 	git commit -m "package updates" -- package.json
					# 	git push origin master
					# 	echo 'pushed package update'
					# }
					cd ..
				fi
			fi
		done
		ENDTIME=$(date +%s)
		echo $(date)
		echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
		exit 1
		;;
	11) # clean node_modules folder
		STARTTIME=$(date +%s)
		echo $(date)
		echo "clean node_modules folder"
		read -p "Remove node_modules? [yn]: " modules
		read -p "NPM Install? [yn]: " npmInstall
		for f in "${projects[@]}"; do
			if [[ -d $f ]]; then
				echo $f; # $f is a directory
				cd $f
				if [[ -f package.json && -d node_modules/ ]]; then
					if [[ $modules = y ]]; 
						then
							rm -fr node_modules/ 
					fi
				fi
				if [[ -f package.json ]]; then
					if [[ $npmInstall = y ]]; 
						then
							npm install
					fi
				
				fi
				cd ..
			fi
		done
		ENDTIME=$(date +%s)
		echo $(date)
		echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
		exit 1
		;;
	12) # list global npm packages
		echo "list global packages"
		npm list -g --depth=0
		exit 1
		;;
	13) # Bump version
		STARTTIME=$(date +%s)
		echo $(date)
		echo "Bump version"
		read -p "Bump? [yn]: " bump
		read -p "Create pull-requests? [yn]: " answer
		for f in "${projects[@]}"; do
			if [[ -d $f ]]; then
				echo $f; # $f is a directory
				cd $f
				if [[ -f package.json ]]; then
					if [[ $bump = y ]]; 
						then
							npm version patch
					
						# check for an upstream remote
						git remote -v | grep 'upstream' &> /dev/null && {
							
							# check if the pull-request should be made
							
							if [[ $answer = y ]]; 
								then
									stash pull-request master upstream/master
									echo "pull-request created"
							fi
						}
					fi
				fi
				cd ..
			fi
		done
		ENDTIME=$(date +%s)
		echo $(date)
		echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
		exit 1
		;;
	14) # run eslint fix
		STARTTIME=$(date +%s)
		echo $(date)
		echo "Running eslint"
		for f in "${projects[@]}"; do
			if [[ -d $f ]]; then
				if [[ -f $f/package.json && -d $f/.git/ ]]; then
					echo $f; # $f is a directory
					cd $f && npm install && npm run lint-fix || true && cd ..
				fi
			fi
		done
		ENDTIME=$(date +%s)
		echo $(date)
		echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
		exit 1
		;;
	15) # Push changes - create pull requests
		STARTTIME=$(date +%s)
		echo $(date)
		echo "push-pull"
		for f in "${projects[@]}"; do
			if [[ -d $f ]]; then
				echo $f; # $f is a directory
				cd $f 
				
				git status -v | grep 'Your branch is ahead' &> /dev/null && {
					git status -v	
					read -p "Push changes? [yn]: " push
					if [[ $push = y ]]; then
						echo "pushing changes"
						git push origin master
					fi
					read -p "Create pull-requests? [yn]: " pull
					if [[ $pull = y ]]; then
						echo "creating pull request"
						stash pull-request master upstream/master
						echo "pull-request created"
					fi
				}
				cd ..
			fi
		done
		ENDTIME=$(date +%s)
		echo $(date)
		echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
		exit 1
		;;
	16) # npm rebuild
		STARTTIME=$(date +%s)
		echo $(date)
		echo "Npm rebuilding packages"
		for f in "${projects[@]}"; do
			if [[ -d $f ]]; then
				if [[ -f $f/package.json ]]; then
					echo $f; # $f is a directory
					cd $f 
						npm rebuild
					cd ..
				fi
			fi
		done
		ENDTIME=$(date +%s)
		echo $(date)
		echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
		exit 1
		;;
	17) exit 1;;
esac 