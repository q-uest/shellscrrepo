# usage: <this_program> <file1> <file2> <directory_the_backup_to_be_taken>
################

clear

dest=`echo $*|rev|cut -d " " -f1|rev`
echo $dest

if [ -f $dest ]
then
 echo "$dest is a regular file....Provide a Directory to take the backup as the last parameter"
 exit
fi

if [ ! -d $dest ]
then
  echo "The directory $dest does not exist...creating it now...."
  mkdir $dest

fi



files=`echo $*|rev|cut -d " " -f2-|rev`
echo $files


for file in $files
do
   # getting name of the latest version of the file from the backup directory

   fn=`ls -1 ./$dest/$file.[1-9]* ./$dest/$file|cut -d "/" -f3|sort -t "."  +1n|tail -1`
   echo "start of the for loop"
   echo the latest version of $file in dest is $fn
   echo
   # copy the file from source if it does not exist in the target path
if [ -z "$fn" ]
then
        cp $file ./$dest/$file
else
    echo $fn|grep "\."
    if [ $? -eq 0 ]
    then
          echo "extension is present with "$file

          # Get extension
          #######
          #
          extn=`echo $fn|rev|cut -d "." -f1|rev`
          echo The identified extn of this file=$extn
          echo $extn |grep "[0-9]" > /dev/null
          if [ $? -eq 0 ]
          then
            echo "the extension is numberic"
            extn=`expr $extn + 1`
            newfn=`echo $fn|rev|cut -d "." -f2-|rev`
          else
            echo $extn is a non-numberic
            newfn=$fn
            extn=1

            #extn="$extn.1"
           # newfn=`echo $fn|cut -d "." -f1`
          fi
    else
        newfn=$fn
        extn=1
   fi


   echo sourcefile=$file $Final-file-name=$newfn.$extn
   cp $file ./$dest/$newfn.$extn

fi

done

echo "Change2"
