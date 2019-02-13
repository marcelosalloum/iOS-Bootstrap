# iOS-Bootstrap

This app contains a set of pre-build common structures so serve as a search base. In other words, the idea is to use this structure as a basis for my/your new features and project structure. 

## Project Requirements

* iOS Min Version: **10.0**
* Swift version: **Swift 4.2**
* Cocoapods Version: **1.5.3**

## Pods Versions

* Alamofire: **4.7.3**                  # Deals with API requests
* Bagel: **1.3.2**                      # Helps debugging network requests
* Crashlytics: **3.10.8**               # Crash reports
* EZCoreData: **0.2.0**                 # Deals withCore Data
* Fabric: **1.7.12**                    # Beta distribution
* Flurry-SDK/FlurrySDK **9.1.0**        # Analytics
* Kingfisher: **4.10.0**                # Image caching
* SwiftMessages: **6.0.0**              # Display Status Bar Messages
* PKHUD: **5.2.0**                      # HUD: Head-Up Display

## Project Structure

I'm using a few things I consider vital to an iOS project. A more in-depth explanation can be found in the items below:

### Views

* Views Interface: the interface was mainly built from storyboards. Since I currently hav more experience with code built interfaces, I decided to challenge myself with storyboard this time, to make sure I know well of both approaches.
* Reusable Views: The project uses reusable Xibs that are actually drawn in the interface builder through `IBDesignable`.
* IBInspectable: there are a few designable views that are not being highly used at te moment, but are very customizable

### API

At the moment, the app is using a very simple API that is defined within a struct. It uses Alamofire and the async callbacks use clojures. A must-do in the short future is start using Promises, probably the [PromiseKit](https://github.com/mxcl/PromiseKit) library.

### Persistence

For persistence the project currently uses the cocapod [EZCoreData](https://github.com/CheesecakeLabs/EZCoreData), which is a pod authored by me in my persuit to better understand Core Data for iOS 10+.

As a rule of thumb, I firsly use CoreData to show the locally stored data before updating it from the backend. A step-by-step explanation:

1. A user opens a screen (a table view or a colection view for instance)
2. The app first shows any available data that is already stored in core data
3. Meanwhile, the app performs an API request to update the data with the API response
4. The retrieved data is then stored in the core data and any outdated data is removed
5. Finally, the app displays the most recently updated data from the backend to the user

### Localization

The structure for Localizationis currently in place for the global project and one of the Storyboards.

### Constants

All constants are placed in a dedicated struct, to avoid using literals.

### Custom Fonts

There is a class declaring custom fonts using class/static methods, that instantiate the fonts nams using a string-struct instead of String literals. That is a very common setup to be used in any kind if project that uses custom fonts.

### Custom Colors

There is a class declaring custom colors using computed properties (similar to `UIColor.blue`, for instance). This is too a very common setup to be used in any kind if project that uses custom colors.

### Crash Tracking

Crashlytics is configured in the project but the keyy is actually public, which is a bad practice.

### User Interaction Tracking

Flurry is configured in the project but the keyy is actually public, which is a bad practice.

### TO-DO

* Implement promises using [PromiseKit](https://github.com/mxcl/PromiseKit)
* Make sure all Storyboardsare localized
* Put on an implementation of `Codable` that makes sense for my current `NSManagedObject` models

## Study Sources

* Generate all icon sizes from one source image: https://appicon.co/
* [Unit Test]: [Faking App Delegate](https://marcosantadev.com/fake-appdelegate-unit-testing-swift/)
* [Unit Test]: [Preparing InMemory Persistent Store](https://medium.com/flawless-app-stories/cracking-the-tests-for-core-data-15ef893a3fee) to avoid messing with production data
