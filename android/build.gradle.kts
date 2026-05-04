allprojects {
    repositories {
        google()
        mavenCentral()
        // this line(maven(url = "https://jitpack.io")) is specifically
        //added for .lottie animation support on this project
        //which it is needed by dotlottie_flutter plugin
        maven(url = "https://jitpack.io")
         // Allow resolving local AARs copied into android/app/libs (used by telebirr_inapp_sdk)
        flatDir {
            dirs("${project.rootDir}/app/libs")
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
