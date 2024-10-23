#!bin/bash

groupid = $1
artifactid = $2

echo "Creating Maven Project for GROUP: $1, with NAME $2."
mvn archetype:generate -DgroupId=com.$1 -DartifactId=$2 -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
