fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios develop
```
fastlane ios develop
```
* Beta Distribution develop: Build ipa with develop env. Upload file ipa to firebase distribution. Send message to chatwork group.

* Run: fastlane ios develop

* Input release note

* Input END to finish release note
### ios staging
```
fastlane ios staging
```
* Beta Distribution Staging: Build ipa with staging env. Upload file ipa to firebase distribution. Send message to chatwork group.
### ios production
```
fastlane ios production
```
* Beta Distribution Production: Build ipa with prod env. Upload file ipa to firebase distribution. Send message to chatwork group.
### ios uploadFirebaseDevelop
```
fastlane ios uploadFirebaseDevelop
```

### ios uploadFirebaseStaging
```
fastlane ios uploadFirebaseStaging
```

### ios uploadFirebaseProduction
```
fastlane ios uploadFirebaseProduction
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
