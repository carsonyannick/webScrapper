loopCount=$1
outputFile=$2

# first argument, the # of Names generated
if [ -z "$1" ]
then
    loopCount=99999
fi

numRE='^[0-9]+$'
if ! [[ $loopCount =~ $numRE ]] ; then
    echo "error: First argument is not a number" >&2; exit 1
fi

# second argument, the output file
if [ -z "$2" ]
then 
    outputFile="Names"
fi

while [ $loopCount -ne 0 ]
do
    output=$(wget -S -O - "https://www.behindthename.com/random/random.php?number=1&gender=both&surname=&randomsurname=yes&all=yes" -q -nv 2>/dev/null | grep "\/name\/")
    output=$(echo $output | sed  's/.*name\/.*">\([A-Z][a-z]*\).*surname.*">\([A-Z][a-z]*\).*/\1 \2/')
    echo $output | grep "[A-Z][a-z]\+ [A-Z][a-z]\+" 2> /dev/null

    if [ $? -eq 0 ]
    then
     echo $output >> $outputFile
    else
        echo "regex error: " $output
    fi
    loopCount=$[$loopCount-1]
done
