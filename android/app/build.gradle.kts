import java.io.File

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.unifycloud"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.unifycloud"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    sourceSets {
        getByName("main") {
            jniLibs.srcDir("src/main/jniLibs")
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
