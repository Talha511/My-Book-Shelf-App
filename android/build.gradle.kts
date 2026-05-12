allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.layout.buildDirectory.value(rootProject.layout.projectDirectory.dir("../build"))

subprojects {
    val rootProjectDir = rootProject.projectDir.parentFile
    if (project.projectDir.toString().startsWith(rootProjectDir.toString())) {
        project.layout.buildDirectory.value(rootProject.layout.buildDirectory.dir(project.name))
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
