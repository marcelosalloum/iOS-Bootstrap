[![Codacy Badge](https://api.codacy.com/project/badge/Grade/2bdb7d141ace469dbe74e362ca150d68)](https://www.codacy.com/app/marcelosalloum/iOS-Bootstrap?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=marcelosalloum/iOS-Bootstrap&amp;utm_campaign=Badge_Grade)

# iOS-Bootstrap

This app contains a set of pre-build common structures so serve as a search base. In other words, the idea is to use this structure as a basis for my/your new features and project structure.

## Project Requirements

* iOS Min Version: **10.0**
* Swift version: **Swift 4.2**
* Cocoapods Version: **1.5.3**

## Pods Versions

| Pod | Version | Description |
|:------                                                        |:-----------   |:----------- |
| Alamofire                                                     | **4.7.3**     | Deals with API requests |
| Bagel                                                         | **1.3.2**     | Helps debugging network requests |
| Crashlytics                                                   | **3.10.8**    | Crash reports |
| [EZCoreData](https://github.com/CheesecakeLabs/EZCoreData)    | **0.7.0**     | Deals with Core Data and concurrent core data requests |
| Fabric                                                        | **1.7.12**    | Beta distribution |
| Flurry-SDK/FlurrySDK                                          | **9.1.0**     | Analytics |
| Kingfisher                                                    | **4.10.0**    | Image caching |
| SwiftMessages                                                 | **6.0.0**     | Display Status Bar Messages |
| SVProgressHUD                                                 | **2.2.5**     |HUD: Head-Up Display |
| PromiseKit                                                 | **6.8.1**     |Promises impleemntation, used to improve callback readability |

## Project Structure

I'm using a few things I consider vital to an iOS project. A more in-depth explanation can be found in the items below:

### Views

* **Views Interface**: the interface was mainly built from storyboards. Since I currently hav more experience with code built interfaces, I decided to challenge myself with storyboard this time, to make sure I know well of both approaches.
* **Reusable Views**: The project uses reusable Xibs that are actually drawn in the interface builder through `IBDesignable`.
* **IBInspectable**: there are a few designable views that are not being highly used at te moment, but are very customizable

### API

At the moment, the app is using a very simple API that is defined within a struct. It uses Alamofire and the async callbacks use clojures. A must-do in the short future is start using Promises, probably the [PromiseKit](https://github.com/mxcl/PromiseKit) library.

The API is actually a mocked APIary, which doesn't have authentication in place.

The API calls implement a layer on top of Alamofire, which is a good practice and better explained [here](https://mecid.github.io/2019/02/13/hiding-third-party-dependencies-with-protocols-and-extensions/).

### Persistence

For persistence the project currently uses the cocapod [EZCoreData](https://github.com/CheesecakeLabs/EZCoreData), which is a pod authored by me in my persuit to better understand Core Data for iOS 10+. In the future I consider to migrate EZCoreData to use PromiseKit.

As a rule of thumb, I firsly use CoreData to show the locally stored data before updating it from the backend. A step-by-step explanation:

1. A user opens a screen (a table view or a colection view for instance)
2. The app first shows any available data that is already stored in core data
3. Meanwhile, the app performs an API request to update the data with the API response
4. The retrieved data is then stored in the core data and any outdated data is removed
5. Finally, the app displays the most recently updated data from the backend to the user

### App Architecture: MVVM-C

 The project makes use of MVVM-C (Model–View–ViewModel Coordinator). It basically has all advantages of classic MVVM and adds a layer for dependency injection and flow coordination, which is the Coordinator.

 I'm particularly a big fan of raw MVVM and I'm finding great advantages of using the Coordinator as well, such as having simpler ViewControllers that con't know where they are in terms of application flow. This way it's easier to reuse ViewControllers throughout the application.

 If you don't use Cordinators, you're probabbly placing some of that kind of code in a custom UINavigationController or a base UIViewController. I find coordinators a more elegant solution though.

 There are a few posts about the subject, some [over complicated](https://medium.com/sudo-by-icalia-labs/ios-architecture-mvvm-c-introduction-1-6-815204248518) and others [over simplified](https://tech.trivago.com/2016/08/26/mvvm-c-a-simple-way-to-navigate/). It's definetly not a must-go rhitectures, but it's a nice way to split your application, in my opinion.

### Localization

The structure for Localization is currently in place making use only of a base language (which is in english). It can be easily replicated to other languages, since the structure is already in place, like in the following piece of code:
```Swift
self.title = "NEWS".localized
```

### Constants

All constants are placed in a dedicated struct to avoid using literals. You could call the database name constant by invoking:
```Swift
let databaseName = Constants.databaseName
```

### Custom Fonts

There is a class declaring custom fonts using class/static methods, that instantiate the fonts nams using a string-struct instead of String literals. That is a very common setup to be used in any kind if project that uses custom fonts. You can call a cusstom font as easy as:
```Swift
self.font = UIFont.proximaNovaRegular(size: 16)
```

### Custom Colors

There is a class declaring custom colors using computed properties (similar to `UIColor.blue`, for instance). This is too a very common setup to be used in any kind if project. Check out an example below:
```Swift
self.backgroundColor = .gray5
```

### Crash Tracking

Crashlytics is configured in the project but the keyy is actually public, which is a bad practice.

### User Interaction Tracking

Flurry is configured in the project but the keyy is actually public, which is a bad practice.

### Continuous Integration (CI)

The only CI tool this project is currently using is Codacy's Code Quality. It's not meant for building, testing or delivering, just for measuring the overall code quality of the project.

### Unit Tests

Currently, that part is still missing in this project but I've made a setup to make sure the AppDelegate won't be loaded for the Unit Tests, which makes your environment easier to control.

If you'd like to check how I like o do Unit Tests, have a look on my Core Data lib: [EZCoreData](https://github.com/CheesecakeLabs/EZCoreData).

### TO-DO

* Add a few Unit tests and UI tests.
* Put on an implementation of `Codable` that makes sense for my current `NSManagedObject` models

## Interesting Links

* Generate all icon sizes from one source image: https://appicon.co/
* [Unit Test]: [Faking App Delegate](https://marcosantadev.com/fake-appdelegate-unit-testing-swift/)
* [Unit Test]: [Preparing InMemory Persistent Store](https://medium.com/flawless-app-stories/cracking-the-tests-for-core-data-15ef893a3fee) to avoid messing with production data
* [Hiding third-party dependencies with protocols and extensions](https://mecid.github.io/2019/02/13/hiding-third-party-dependencies-with-protocols-and-extensions/)
