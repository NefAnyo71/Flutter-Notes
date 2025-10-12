plugins {
    id("com.android.application")
    id("kotlin-android")
    // Google Services eklentisini uygula
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.not_tut"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        // google-services.json ile eşleşmesi için applicationId güncellendi.
        applicationId = "com.arif2.com"
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
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
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BoM (Bill of Materials) import et.
    // Bu, Firebase kütüphanelerinin uyumlu sürümlerini otomatik olarak yönetir.
    implementation(platform("com.google.firebase:firebase-bom:34.3.0"))

    // Kullanmak istediğiniz Firebase ürünleri için bağımlılıkları ekleyin.
    // BoM kullanırken, Firebase bağımlılıklarında sürüm belirtmeyin.
    implementation("com.google.firebase:firebase-analytics")

    // Firestore için gerekli olan cloud_firestore paketi zaten Flutter tarafında eklendiği için buraya eklemeye gerek yoktur.
}
