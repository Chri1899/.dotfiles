function proj_create_java
    set project_dir $argv[1]
    set project_name $argv[2]
    set build $argv[3]

    switch $build
        case "gradle"
            mkdir -p $project_dir/src/main/java $project_dir/src/test/java
            # build.gradle
            echo "plugins { id 'java' }
group '$project_name'
version '1.0-SNAPSHOT'" > $project_dir/build.gradle

            # simple App.java
            echo "public class App {
    public static void main(String[] args) {
        System.out.println(\"Hello World from $project_name!\");
    }
}" > $project_dir/src/main/java/App.java

        case "maven"
            mkdir -p $project_dir/src/main/java $project_dir/src/test/java
            # pom.xml minimal
            echo "<project xmlns='http://maven.apache.org/POM/4.0.0'
         xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
         xsi:schemaLocation='http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd'>
  <modelVersion>4.0.0</modelVersion>
  <groupId>$project_name</groupId>
  <artifactId>$project_name</artifactId>
  <version>1.0-SNAPSHOT</version>
</project>" > $project_dir/pom.xml

        case "*"
            echo "Unknown Java build system: $build. Use 'gradle' or 'maven'."
            return 1
    end
end
