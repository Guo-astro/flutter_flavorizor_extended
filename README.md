# Flutter Flavorizr Extended

## TLDR;

### Differences from the Original flutter_flavorizr:

- No Overwriting of Android signingConfig: The signingConfig section in Android is no longer
  overwritten.
- Compatibility with Existing Projects: Running the original flutter_flavorizr on an existing
  project could cause errors due to file references and base structure dependencies. This has been
  addressed.
- No Overwriting of Custom Dart Files: After running flutter pub run flutter_flavorizr_extended for
  the first time, we avoid overwriting .dart files that you may have manually modified. The
  following processors are skipped in subsequent runs:

```dart
// 'flutter:flavors',
// 'flutter:app',
// 'flutter:pages',
// 'flutter:main',
// 'flutter:targets',
```

## Installation

- Add the following in your buildspec.yaml

```yaml
dev_dependencies:
  flutter_flavorizr_extended: ^0.0.7
```

## Getting Started with working Example Configuration:


### Step 0: **Configure pubspec.yaml**


<details>
      <summary>Assume we need have 4 flavors named: development,qa,uat,prod</summary>

  ```yaml
        name: flutter_template_app
        description: "A new Flutter project."
        publish_to: 'none'
        version: 0.1.0
        
        environment:
          sdk: ^3.5.3
        
        dependencies:
          flutter:
            sdk: flutter
        
        dev_dependencies:
          flutter_test:
            sdk: flutter
          flutter_lints: ^5.0.0
          flutter_flavorizr_extended: ^0.0.4
        
        
        flutter:
          uses-material-design: true
        
        
        flavorizr:
          flavors:
            development:
              app:
                name: "FlutterTemplateApp"
              android:
                applicationId: "go.template.flutter"
                generateDummyAssets: true
                icon: "assets/images/icons/appicon.png"
                customConfig:
                  applicationIdSuffix: "\".development\""
                  versionNameSuffix: "\"Dev\"" # Don't forget to escape strings with \"
                  signingConfig: signingConfigs.debug
              ios:
                bundleId: "go.template.flutter.development"
                generateDummyAssets: true
                icon: "assets/images/icons/appicon.png"
                buildSettings:
            qa:
              app:
                name: "FlutterTemplateApp"
              android:
                applicationId: "go.template.flutter.qa"
                generateDummyAssets: true
                icon: "assets/images/icons/appicon.png"
                customConfig:
                  applicationIdSuffix: "\".qa\""
                  versionNameSuffix: "\"QA\"" # Don't forget to escape strings with \"
                  signingConfig: signingConfigs.qa
              ios:
                bundleId: "go.template.flutter.qa"
                generateDummyAssets: true
                icon: "assets/images/icons/appicon.png"
            uat:
              app:
                name: "FlutterTemplateApp"
              android:
                applicationId: "go.template.flutter"
                generateDummyAssets: true
                icon: "assets/images/icons/appicon.png"
                customConfig:
                  applicationIdSuffix: "\".uat\""
                  versionNameSuffix: "\"UAT\"" # Don't forget to escape strings with \"
                  signingConfig: signingConfigs.uat
              ios:
                bundleId: "go.template.flutter.uat"
                generateDummyAssets: true
                icon: "assets/images/icons/appicon.png"
            prod:
              app:
                name: "FlutterTemplateApp"
              android:
                applicationId: "go.template.flutter"
                generateDummyAssets: true
                icon: "assets/images/icons/appicon.png"
                customConfig:
                  signingConfig: signingConfigs.release
              ios:
                bundleId: "go.template.flutter"
                generateDummyAssets: true
                icon: "assets/images/icons/appicon.png"
  ```
</details>


### Step 1: **Ensure the Icon Exists:**
<details>
      <summary>Make sure your app icons is correctly placed in the specified path.</summary>
</details>



### Step 2: **Android Signing Configuration:**
<details>
  <summary>Make sure all the signingConfig listed in the pubsec.yaml exists</summary>


- ### 1: Generate a Signing Key

  Run this command to create a keystore for signing your app:

  ```bash 
   keytool -genkey -V -keystore template_app.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias template_app_key ```

- ### 2: Organize Your Keystore

    - Create a folder called keystores and place the generated template_app.jks file inside it.

- ### 3: Create key.properties

  Create a file named key.properties with the following content. Never push this file to public
  repositories!
  - Note after 2,3 you should have folder structure like the following:<img src="doc%2Fsetup%2Fandroid_signing_config.png" width="200" height="200"/>
  ```gradle
  development.keyAlias=template_app_key
  development.keyPassword=<Your password>
  development.storeFile=../keystores/template_app.jks
  development.storePassword=<Your password>
  
  qa.keyAlias=template_app_key
  qa.keyPassword=<Your password>
  qa.storeFile=../keystores/template_app.jks
  qa.storePassword=<Your password>
  
  uat.keyAlias=template_app_key
  uat.keyPassword=<Your password>
  uat.storeFile=../keystores/template_app.jks
  uat.storePassword=<Your password>
  
  prod.keyAlias=template_app_key
  prod.keyPassword=<Your password>
  prod.storeFile=../keystores/template_app.jks
  prod.storePassword=<Your password>
  ```

- ### 4:Update app/build.gradle
  Add the following signingConfigs section to your app/build.gradle:
  ```gradle
    signingConfigs {
        debug {

            if (System.getenv()["CI"]) { // CI=true is exported by Codemagic
                storeFile file(System.getenv()["CM_KEYSTORE_PATH"])
                storePassword System.getenv()["CM_KEYSTORE_PASSWORD"]
                keyAlias System.getenv()["CM_KEY_ALIAS"]
                keyPassword System.getenv()["CM_KEY_PASSWORD"]
            } else {
                keyAlias keyProperties['dev.keyAlias']
                keyPassword keyProperties['development.keyPassword']
                storeFile keyProperties['development.storeFile'] ? file(keyProperties['development.storeFile']) : null
                storePassword keyProperties['dev.storePassword']
            }

        }
        qa {
            if (System.getenv()["CI"]) { // CI=true is exported by Codemagic
                storeFile file(System.getenv()["CM_KEYSTORE_PATH"])
                storePassword System.getenv()["CM_KEYSTORE_PASSWORD"]
                keyAlias System.getenv()["CM_KEY_ALIAS"]
                keyPassword System.getenv()["CM_KEY_PASSWORD"]
            } else {
                keyAlias keyProperties['qa.keyAlias']
                keyPassword keyProperties['qa.keyPassword']
                storeFile keyProperties['qa.storeFile'] ? file(keyProperties['qa.storeFile']) : null
                storePassword keyProperties['qa.storePassword']
            }

        }
        uat {
            if (System.getenv()["CI"]) { // CI=true is exported by Codemagic
                storeFile file(System.getenv()["CM_KEYSTORE_PATH"])
                storePassword System.getenv()["CM_KEYSTORE_PASSWORD"]
                keyAlias System.getenv()["CM_KEY_ALIAS"]
                keyPassword System.getenv()["CM_KEY_PASSWORD"]
            } else {
                keyAlias keyProperties['uat.keyAlias']
                keyPassword keyProperties['uat.keyPassword']
                storeFile keyProperties['uat.storeFile'] ? file(keyProperties['uat.storeFile']) : null
                storePassword keyProperties['uat.storePassword']
            }

        }
        release {
            if (System.getenv()["CI"]) { // CI=true is exported by Codemagic
                storeFile file(System.getenv()["CM_KEYSTORE_PATH"])
                storePassword System.getenv()["CM_KEYSTORE_PASSWORD"]
                keyAlias System.getenv()["CM_KEY_ALIAS"]
                keyPassword System.getenv()["CM_KEY_PASSWORD"]
            } else {
                keyAlias keyProperties['prod.keyAlias']
                keyPassword keyProperties['prod.keyPassword']
                storeFile keyProperties['prod.storeFile'] ? file(keyProperties['prod.storeFile']) : null
                storePassword keyProperties['prod.storePassword']
            }

        }
  ```
</details>

### Step 3: **Genearate all flavors**

  ```terminal
  flutter pub run flutter_flavorizr_extended -r initializationRun
  ```
Note after the first time you run the above command you want to modify the flavorizr config,make sure delete the following code in Android app build.gradle:


[build_gradle_processor_test.dart](test%2Fprocessors%2Fandroid%2Fbuild_gradle_processor_test.dart)

### Step 4: **iOS Signing Configuration:**
<details>
  <summary>Make sure the app bundle identidier is the same as in the app store</summary>
  Detail comming soon...
</details>



### Step 5: Finalize:

After setting all this up,  
 ```terminal
  flutter pub run flutter_flavorizr_extended -r updateRun
```
   Note you can always comeback to regenrate your configuration use which will **not** rewrite your existing main*.dart!

---
For additional configuration details, refer to the flutter_flavorizr package documentation.
Note:All credit goes to the original author, AngeloAvv.
