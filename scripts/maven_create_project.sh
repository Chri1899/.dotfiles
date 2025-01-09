#!bin/bash

groupid = $1
artifactid = $2

echo "Creating Maven Project for GROUP: $1, with NAME $2."
mvn archetype:generate -DgroupID=com.$1 -DartifactID=$2 -DarchetypeArtifactID=maven-archetype-quickstart -DinteractiveMode=false
