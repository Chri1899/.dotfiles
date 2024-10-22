#!bin/bash

groupid = "$1"
artifactid = "$2"

echo "Creating Maven Project for GROUP: ${groupid}, with NAME ${artifactid}."
mvn archetype:generate -DgroupId=com.${groupid} -DartifactId=${artifactid} -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
