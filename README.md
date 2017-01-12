# SpaceView

[![CI Status](http://img.shields.io/travis/Xopoko/SpaceView.svg?style=flat)](https://travis-ci.org/Xopoko/SpaceView)
[![Version](https://img.shields.io/cocoapods/v/SpaceView.svg?style=flat)](http://cocoapods.org/pods/SpaceView)
[![License](https://img.shields.io/cocoapods/l/SpaceView.svg?style=flat)](http://cocoapods.org/pods/SpaceView)
[![Platform](https://img.shields.io/cocoapods/p/SpaceView.svg?style=flat)](http://cocoapods.org/pods/SpaceView)

![space](https://cloud.githubusercontent.com/assets/6337061/21842749/2f803ae8-d7f9-11e6-8cb6-f0dd2628205a.png)

## Example

<img src="https://cloud.githubusercontent.com/assets/6337061/21762103/ef8748ce-d667-11e6-83c7-4a058e49e2d5.gif" width="301" height="590" alt="SpaceView"/> 

- SpaceView On top
```swift
//View will be shown on the top
self.showSpace(title: "title", description: "description", spaceOptions: [.spacePosition(position: .top)
])
```

<img src="https://cloud.githubusercontent.com/assets/6337061/21762101/ef869e38-d667-11e6-90c4-3d9de76f8e29.gif" width="301" height="590" alt="SpaceView"/>

- SpaceView On bottom
```swift
//View will be shown at the bottom
self.showSpace(title: "title", description: "description", spaceOptions: [.spacePosition(position: .bot)
])
```

<img src="https://cloud.githubusercontent.com/assets/6337061/21762102/ef86d196-d667-11e6-84ad-309193ee8e09.gif" width="301" height="590" alt="SpaceView"/>

- SpaceView with default styles
```swift
self.showSpace(title: "title", description: "description", spaceOptions: [.spaceStyle(style: .success)
])
```

- SpaceView set time to hide 
```swift
//SpaceView will not hide
self.showSpace(title: "title", description: "description", spaceOptions: [.spaceTimer(timer: 3.0)
])
```

- SpaceView set autohide
```swift
//View will hide after 3 second
self.showSpace(title: "title", description: "description", spaceOptions: [ .shouldAutoHide(should: false)
])
```

- SpaceView set image
```swift
//Image which will be shown on the right side of spaceView
self.showSpace(title: "title", description: "description", spaceOptions: [.image(img: UIImage()),
])
```

- SpaceView set swipe and tap handler
```swift
//Set the your custom handlers. By default tap handler will hide SpaceView. 
//SwipeAction will perform after user did swipe SpaceView
self.showSpace(title: "title", description: "description", spaceOptions: [
.swipeAction {print("SPACE VIEW DID SWIPE")}, 
.tapAction {print("SPACE VIEW DID TAP")}
])
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- iOS 8.0
- Xcode 8.2

## Installation

SpaceView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SpaceView"
```

## Author

Xopoko, alonsik1@gmail.com

## License

SpaceView is available under the MIT license. See the LICENSE file for more info.