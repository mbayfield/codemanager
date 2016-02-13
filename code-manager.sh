#!/bin/bash

# command -v ncu >/dev/null 2>&1 || { echo "I require ncu but it's not installed.  Aborting." >&2; exit 1; }

echo "Select option:"
echo "1) check all/update dependencies"
echo "2) update dependencies"
echo "3) commit package changes"
echo "4) git fetch & pull all"
echo "5) run eslint"
echo "6) run nsp"
echo "7) git remote"
echo "8) run tests"
echo "9) run coverage"
echo "10) git status"
echo "11) clean node_modules folder"
echo "12) list global npm packages"
echo "13) exit"
read case;

# Go up a directory
cd ..

case $case in
	1) 
		STARTTIME=$(date +%s)
		echo $(date)
		updateDeps='n'
		read -p "Update dependencies? [yn]: " updateDeps
		echo "Checking dependencies"
		for f in */; do
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
								ncu -u && npm install
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
		
	2) 
		echo "Updating dependencies"
		for f in */; do
			if [[ -d $f ]]; then
				if [[ -f $f/package.json ]]; then
					echo $f; # $f is a directory
					cd $f && npm update #&& npm install
					# git status -s | grep 'package.json' &> /dev/null && {
					# 	git commit -m "package updates" -- package.json
					# 	git push origin master
					# 	echo 'pushed package update'
					# }
					cd ..
				fi
			fi
		done
		exit 1
		;;
	3) 
		STARTTIME=$(date +%s)
		echo $(date)
		echo "commit package changes"
		read -p "Push changes? [yn]: " push
		read -p "Create pull-requests? [yn]: " answer
		for f in */; do
			if [[ -d $f ]]; then
				if [[ -f $f/package.json && -d $f/.git/ ]]; then
					echo $f; # $f is a directory
					cd $f 
					
					git status -s | grep 'package.json' &> /dev/null && {
						
						# commit the changes
						git commit -m "package updates" -- package.json
						
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
	4) 
		STARTTIME=$(date +%s)
		echo $(date)
		echo "Fetching latest from git"
		for f in */; do
			if [[ -d $f ]]; then
				if [[ -d $f/.git/ ]]; then
					echo $f; # $f is a directory
					cd $f && git fetch --all && git pull --all || true && cd ..
				fi
			fi
		done
		ENDTIME=$(date +%s)
		echo $(date)
		echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
		exit 1
		;;
	5) 
		STARTTIME=$(date +%s)
		echo $(date)
		echo "Running eslint"
		for f in */; do
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
	6) 
		STARTTIME=$(date +%s)
		echo $(date)
		echo "Running nsp check"
		for f in */; do
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
	7) 
		STARTTIME=$(date +%s)
		echo $(date)
		echo "Running git remote"
		for f in */; do
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
	8) 
		STARTTIME=$(date +%s)
		echo $(date)
		echo "Running tests"
		for f in */; do
			if [[ -d $f ]]; then #&& $f == 'environment/' 
				if [[ -f $f/package.json && -d $f/.git/ ]]; then
					echo $f; # $f is a directory
					export NODE_ENV=dev
					# export APP_CONFIG_PATH='/www/Code/enviroment/env.json'
					cd $f && npm install && npm run test || true && cd ..
				fi
			fi
		done
		ENDTIME=$(date +%s)
		echo $(date)
		echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
		exit 1
		;;
	9) 
		STARTTIME=$(date +%s)
		echo $(date)
		echo "Running coverage reports"
		for f in */; do
			if [[ -d $f ]]; then
				if [[ -f $f/package.json && -d $f/.git/ ]]; then
					echo $f; # $f is a directory
					# export NODE_ENV=dev
					# export APP_CONFIG_PATH='/www/Code/enviroment/env.json'
					cd $f && npm install && npm run cover || true && cd ..
				fi
			fi
		done
		ENDTIME=$(date +%s)
		echo $(date)
		echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
		exit 1
		;;
	10) 
		STARTTIME=$(date +%s)
		echo $(date)
		echo "git status"
		for f in */; do
			if [[ -d $f ]]; then
				if [[ -f $f/package.json && -d $f/.git/ ]]; then
					echo $f; # $f is a directory
					cd $f #&& ncu -u 
					git status -s #| grep 'package.json' &> /dev/null && {
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
	11) 
		STARTTIME=$(date +%s)
		echo $(date)
		echo "clean node_modules folder"
		read -p "Remove node_modules? [yn]: " modules
		read -p "NPM Install? [yn]: " npmInstall
		for f in */; do
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
	12)
		echo "list global packages"
		npm list -g --depth=0
		exit 1
		;;
	13) exit 1;;
esac 