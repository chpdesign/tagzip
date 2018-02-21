#!/usr/bin/env bash
# inspiration by me and Kaspars Dambis - https://kaspars.net/blog/dev/create-release-zip-git-tags
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
# init
NC='\033[0m' # No Color
DARKGRAY='\033[0;90m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
dirname=${PWD##*/}

logo="${DARKGRAY}  _                  _       \n | |                (_)      \n | |_ __ _  __ _ _____ _ __  \n | __/ _' |/ _' |_  / | '_ \ \n | || (_| | (_| |/ /| | |_) |\n  \__\__,_|\__, /___|_| .__/ \n            __/ |     | |    \n           |___/      |_|\n${NC}"
version=0.0.1

# https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
# https://www.cyberciti.biz/faq/bash-for-loop-array/
# https://www.thegeekstuff.com/2010/06/bash-array-tutorial/

# https://www.lifewire.com/pass-arguments-to-bash-script-2200571
while getopts ":d:s:g:lhbuv" option
do
 opts=1
 case "${option}"
 in
 s) slug=${OPTARG:-$dirname};;
 b) branch=${OPTARG:-master};;
 g) glue=${OPTARG:--};;
 d) save=${OPTARG:-$PWD/tags/};;
 l) onlylist=1;;
 u) update=1;;
 v)
 echo -e "${version}"
 exit 0
 ;;
 h)
 echo -e "${logo}"
 echo -e "version: ${version}"
 echo -e "-------------------"
 echo -e "-d saving location"
 echo -e "  default: current_folder/tags/"
 echo -e "-b branch for tags"
 echo -e "  default: master"
 echo -e "-s slug the prefix of file names"
 echo -e "  default: current dirname"
 echo -e "-g glue of tags like ${RED}-${NC} project${RED}-${NC}1.0.zip"
 echo -e "  default: -"
 echo -e "-u update zip will be created"
 echo -e "zips will be created from tag to tag"
 echo -e "  default: not set (as this like github tag release)"
 echo -e "-l only file names return without pimp"
 echo -e ""
 echo -e "Created by Gergely Nagy CHiP <info@nagygergely.eu>"
 echo -e ""
 echo -e "${DARKGRAY}My favorite hungarian sentences:"
 echo -e "Nincs többé haj csak gyönyörű korpa!"
 echo -e "Nem a szándék a részvétel hanem a fontos!${NC}"
 exit 0
 ;;
 \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
 :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
 esac
done

if [ -z ${opts} ]; then
    slug=${1:-$dirname}
    branch=${4:-master}
    glue=${3:--}
    save=${2:-$PWD/tags/}
    onlylist=${5:-0}
    update=${6:-0}
else
    slug=${slug:-$dirname}
    branch=${branch:-master}
    glue=${glue:--}
    save=${save:-$PWD/tags/}
    onlylist=${onlylist:-0}
    update=${update:-0}
fi
# https://gist.github.com/luciomartinez/c322327605d40f86ee0c
length=${#save}
last_char=${save:length-1:1}

[[ $last_char != "/" ]] && save="$save/"; :

# init end

[[ $onlylist != 1 ]] &&
echo -e "${logo}"

mkdir -p $save
if [ $onlylist != 1 ]; then
  echo -e "branch: ${RED}${branch}${NC}"
  echo -e "saving dir: ${YELLOW}${save}${NC}"
fi
commits=()
# old version : list=`git log --simplify-by-decoration --decorate --pretty=oneline "${branch}" | fgrep 'tag: '`
# https://stackoverflow.com/questions/4211604/show-all-tags-in-git-log
# https://git-scm.com/docs/pretty-formats
list=`git log --format="%H %d" "${branch}" | fgrep 'tag: '`
while read -r line; do
    commit=$(awk '{ print $1 }' <<< "$line")
    commits=("${commits[@]}" "${commit}")
done <<< "$list"
# echo ${#commits[@]} commit found
# echo They are: $tags
# for tag in "${tags[@]}"
# do
#     echo $tag
# done
# https://gist.github.com/zulhfreelancer/41eac7d775c3c5c57d07d6b1b7f4c21e
firstcommit=`git log --format="%H" --decorate=full "${branch}" | tail -1`
for (( idx=${#commits[@]}-1 ; idx>=0 ; idx-- )) ; do
    commit="${commits[idx]}"
    # echo "${commit}"
    # echo "${firstcommit}"
    list=`git tag --points-at $commit`
    # echo $list
    while read -r line; do
        tag=$(awk '{ print $1 }' <<< "$line")
        echo -e "${GREEN}"$save$slug$glue$tag.zip
        if [ ${update} -eq 1 ]; then
            # git archive --output=$save$slug$glue$tag.zip $branch $(git diff --diff-filter=d --name-only $firstcommit $commit)
            git archive $commit --output=$save$slug$glue$tag.zip $(git diff --diff-filter=d --name-only $firstcommit $commit)
        else
            git archive $commit --output=$save$slug$glue$tag.zip
        fi
    done <<< "$list"
    if [ ${update} -eq 1 ]; then
       firstcommit="${commits[idx]}"
    fi
done
