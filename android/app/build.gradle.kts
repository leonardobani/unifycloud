import com.android.build.gradle.internal.api.ApkVariantOutputImpl
import java.io.File
import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}

android {
    namespace = "io.gitlab.leorise25.unifycloud"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "io.gitlab.leorise25.unifycloud"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                val storeFileName = keystoreProperties["storeFile"] as String?
                if (storeFileName != null) {
                    val f = rootProject.file(storeFileName)
                    storeFile = if (f.exists()) f else file(storeFileName)
                }
                storePassword = keystoreProperties["storePassword"] as String?
            }
        }
    }

    buildTypes {
        release {
            val releaseSigning = signingConfigs.findByName("release")
            signingConfig = if (releaseSigning?.storeFile?.exists() == true) {
                releaseSigning
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }

    sourceSets {
        getByName("main") {
            jniLibs.srcDir("src/main/jniLibs")
        }
    }
}

val abiCodes = mapOf("armeabi-v7a" to 1, "arm64-v8a" to 2, "x86_64" to 3)
android.applicationVariants.configureEach {
    val variant = this
    variant.outputs.forEach { output ->
        val abiVersionCode = abiCodes[output.filters.find { it.filterType == "ABI" }?.identifier]
        if (abiVersionCode != null) {
            (output as ApkVariantOutputImpl).versionCodeOverride = variant.versionCode * 10 + abiVersionCode
        }
    }
}

tasks.register("buildGoAndroid") {
    description = "Compiles Go Rclone core backend for Android architectures using NDK"
    val rootDir = project.rootDir.parentFile
    val goBackendDir = File(rootDir, "go_backend")
    val jniLibsDir = File(projectDir, "src/main/jniLibs")
    val arm64Lib = File(jniLibsDir, "arm64-v8a/librclone_wrapper.so")

    inputs.dir(goBackendDir)
    outputs.file(arm64Lib)

    doLast {
        val script = if (org.gradle.internal.os.OperatingSystem.current().isWindows) {
            File(rootDir, "scripts/build_go_android.bat")
        } else {
            File(rootDir, "scripts/build_go_android.sh")
        }

        if (script.exists()) {
            val process = ProcessBuilder(
                if (org.gradle.internal.os.OperatingSystem.current().isWindows) listOf("cmd", "/c", script.absolutePath)
                else listOf("bash", script.absolutePath)
            )
                .directory(rootDir)
                .redirectOutput(ProcessBuilder.Redirect.INHERIT)
                .redirectError(ProcessBuilder.Redirect.INHERIT)
                .start()
            val exitCode = process.waitFor()
            if (exitCode != 0 && !arm64Lib.exists()) {
                println("WARNING: build_go_android exited with code $exitCode and no librclone_wrapper.so found in jniLibs.")
            }
        }
    }
}

tasks.matching {
    it.name.startsWith("preBuild") || (it.name.startsWith("merge") && it.name.endsWith("JniLibFolders"))
}.configureEach {
    dependsOn("buildGoAndroid")
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
