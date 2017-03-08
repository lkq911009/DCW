#!bin/bash
DATE=`date +%m%d%Y.%H%M%S`
TARGET="$1.$DATE"
DIR=`pwd`


function batch_convert() {
for file in `ls $1`
do
if [ -d $1"/"$file ]
then
batch_convert $1"/"$file
else
dos2unix $1"/"$file
#echo $1"/"$file
fi
done
}

##################

echo $TARGET
cd $DIR/DCW
git checkout develop
git pull
cd ../
batch_convert DCW
cp -R DCW tmp/$TARGET
cd tmp/$TARGET
find . -type d -name "*git*"| xargs -n20 rm -rf



for db in `cat $DIR/tmp/$TARGET/Dblist` ; do
        echo "********** DB IS $db *******"
       for dbfolder in `find * -maxdepth 0 -type d` ;do
	echo `ls -a`
        echo "***** DBFolder is  $dbfolder *****"
	if [ ! $dbfolder = $db ];then
	cp -R $dbfolder $db
	find $db -name "*.ctl"| xargs -I '{}' mv '{}' $db/${db}.ctl
	fi
	done
done
cd ../
tar -cf $TARGET.tar $TARGET


