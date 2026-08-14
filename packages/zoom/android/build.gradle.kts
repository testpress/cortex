group = "com.testpress.flutter_zoom_meeting_sdk"
version = "1.0-SNAPSHOT"

buildscript {
    val kotlinVersion = "2.3.20"
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:9.0.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

rootProject.allprojects {
    repositories {
        flatDir {
            dirs(project(":zoom").file("libs"))
        }
    }
}

plugins {
    id("com.android.library")
}

apply(from = "libs/build.gradle")

android {
    namespace = "com.testpress.flutter_zoom_meeting_sdk"

    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    sourceSets {
        getByName("main") {
            java.setSrcDirs(listOf("src/main/kotlin"))
        }
        getByName("test") {
            java.setSrcDirs(listOf("src/test/kotlin"))
        }
    }

    defaultConfig {
        minSdk = 28
    }

    buildFeatures {
        viewBinding = true
    }

    testOptions {
        unitTests {
            isIncludeAndroidResources = true
            all {
                it.useJUnitPlatform()

                it.outputs.upToDateWhen { false }

                it.testLogging {
                    events("passed", "skipped", "failed", "standardOut", "standardError")
                    showStandardStreams = true
                }
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    implementation(group = "", name = "mobilertc", ext = "aar")

    val libsMap = project.extensions.extraProperties["libs"] as Map<*, *>
    val composeBomVersion = libsMap["composeBomVersion"] as String
    implementation(platform("androidx.compose:compose-bom:$composeBomVersion"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.foundation:foundation")
    implementation("androidx.compose.runtime:runtime")

    val sdkDependenciesList = project.extensions.extraProperties["sdkDependenciesList"] as List<*>
    for (dep in sdkDependenciesList) {
        implementation(dep!!)
    }

    testImplementation("org.jetbrains.kotlin:kotlin-test")
    testImplementation("org.mockito:mockito-core:5.0.0")
}
