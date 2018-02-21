# tagzip
A bash script for git release and patch/update

[![License][license-image]][license-url]
> ```
>   _                  _       
>  | |                (_)      
>  | |_ __ _  __ _ _____ _ __  
>  | __/ _' |/ _' |_  / | '_ \ 
>  | || (_| | (_| |/ /| | |_) |
>   \__\__,_|\__, /___|_| .__/ 
>             __/ |     | |    
>            |___/      |_|
> 
> ```
## version: 0.0.1
## usage
```bash
-d saving location
  default: current_folder/tags/
-b branch for tags
  default: master
-s slug the prefix of file names
  default: current dirname
-g glue of tags like - project-1.0.zip
  default: -
-u update zip will be created
zips will be created from tag to tag
  default: not set (as this like github tag release)
-l only file names return without pimp
```
## example
```bash
./tagzip.sh -l -u -d updates
```
-l is listing out the created zips
-u is update zips only, these zips not contains all the files from the beginnings
-d is the directory where the zips will be stored/saved
returns
```bash
updates/project-1.0.0.0.zip
updates/project-1.0.5.16.zip
updates/project-1.0.5.17.zip
updates/project-1.0.5.18.zip
```
so the updates folder contains the update zips
## credits
Created by Gergely Nagy <info@nagygergely.eu>

[license-image]:          http://img.shields.io/badge/license-MIT-blue.svg?style=flat
[license-url]:            LICENSE
