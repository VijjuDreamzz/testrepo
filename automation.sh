stage ("Execute the test suite"){

steps {

script {


try { 

sh '''

targetPath=$WORKSPACE
echo $targetPath
SAVEIFS=$IFS # Save current IFS
#IFS=$'\n' # Change IFS to new line
linesArr=($targetPath) # split to array $names
IFS=$SAVEIFS # Restore IFS

for (( i=0; i<${#linesArr[@]}; i++ ))
do

line=${linesArr[$i]}

SAVEIFS=$IFS # Save current IFS
#IFS=$':' # Change IFS to new line
fields=($line) # split to array $names
IFS=$SAVEIFS # Restore IFS
projectPath=${fields[0]}"/"${fields[0]}".prj"
testSuitePath="Test Suites"/${fields[1]}

testSuitePath=$(echo $testSuitePath)
testSuitePath=${testSuitePath%$'\r'}

cd /opt/Katalon_Studio_Engine_Linux_64-7.6.2
./katalonc -noSplash -runMode=console -projectPath="$WORKSPACE/$projectPath" -reportFolder="/var/lib/jenkins/workspace/PublishReportToJira/Reports/$i" -reportFileName="report" -retry=0 -testSuitePath="$testSuitePath" -executionProfile="default" -browserType="Web Service" -apiKey="b44be0d6-c44f-450e-9815-e287f5bfcb10" --config -proxy.auth.option=NO_PROXY -proxy.system.option=NO_PROXY -proxy.system.applyToDesiredCapabilities=true || error=true



#echo "the project path is "$projectPath
#echo "the test suite path is "$testSuitePath


done

if [ $error ]
then 

echo "going to catch block"
exit 1
fi

'''

} catch (err) {

sh '''

echo "proceeding with other test cases"

'''

} finally {

echo "success"

}
}
}
}
}
}