allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Set custom build directory for all subprojects after they are evaluated
subprojects {
    afterEvaluate {
        val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get().asFile.resolve(project.name)
        project.buildDir = newBuildDir
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
