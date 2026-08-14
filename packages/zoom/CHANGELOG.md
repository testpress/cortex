## 0.0.1

* Initial release of local Zoom wrapper plugin fork.
* Relocate package structures and method channels to namespace `com.testpress.flutter_zoom_meeting_sdk`.
* Clean up redundant Node.js token fetching method (`getJWTToken`) and remove the redundant `http` package dependency.
* Refactor Event Channel listeners to resolve EventSinks dynamically via closure lambdas to prevent startup NullPointerExceptions.
* Enable ViewBinding build feature in Android Gradle setup.
* Add Jetpack Compose BOM platform alignment to prevent runtime preview layout conflicts.
