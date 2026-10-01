import java.util.Properties

// A chave de assinatura fica fora do repositório, em `android/key.properties`, no mesmo formato dos outros apps
// (FRDividends, destinydice, cardkingdoms):
//
//     storePassword=...
//     keyPassword=...
//     keyAlias=frcc24
//     storeFile=ks_lh.jks      (relativo a android/app, ou caminho absoluto)
//
// Sem o arquivo, `flutter run` e os testes continuam funcionando com a chave de depuração, mas o build de
// release FALHA em vez de sair assinado em debug sem ninguém perceber.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
val hasKeystoreProperties = keystorePropertiesFile.exists()

if (hasKeystoreProperties) {
    keystorePropertiesFile.inputStream().use(keystoreProperties::load)
} else {
    logger.warn("android/key.properties não encontrado: o build de release vai falhar (a Play recusaria o upload).")
}

fun resolveKeystoreFile(path: String) =
    listOf(file(path), rootProject.file(path), rootProject.file("app/$path")).firstOrNull { it.exists() }
        ?: throw GradleException("keystore não encontrado: $path")

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.francocorrea.magiccounter"

    // Os padrões do Flutter já atendem o que a Play exige hoje (compileSdk/targetSdk 36). Não fixar números
    // aqui: congelaria o app numa versão velha na próxima virada.
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.francocorrea.magiccounter"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // vêm do `version:` do pubspec (3.0.0+100). O último versionCode na Play era 22; este precisa ser maior.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasKeystoreProperties) {
            create("release") {
                storeFile = resolveKeystoreFile(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = if (hasKeystoreProperties) signingConfigs.getByName("release") else null
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
