<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.2-orange.svg?style=flat" />
    <img src="https://img.shields.io/badge/Platforms-iOS11+-blue.svg?style=flat" />
    <img src="https://img.shields.io/github/license/mashape/apistatus.svg" />
</p>

## What is this?

A customizable `DrawerView` similar to the one in Maps.

## Example Project

The project contains an example of the `DrawerView`, with a simple `UITableViewController` inside of it and a custom `Header`. To run the example project clone the repo and add the `BottomDrawerView` `Swift Package`.

## Usage

Inside your ViewController create your `DrawerView` object. I prefer to use a `lazy` loaded drawer so that I can configure it right inside.

```swift
private lazy var bottomDrawer: DrawerView = {
  let drawer = DrawerView(...)
  ...
  return drawer
}()
```

You can either initialize it using a `UIView` or a `UIViewController`, and customize various properties.
```swift
let drawer = DrawerView(containing: yourViewControllerOrView, inside: self, headerViewHeight: 60)
// Each position represents the precentage of the screen that it will occupy
drawer.supportedPositions = [DVPosition(0.2), DVPosition(0.8)]
// This only affects the topLeft and topRight corners
drawer.cornerRadius = 24
// Only for the header
drawer.tapToExpand = true
```

Then in the `viewDidLoad()` add it to your viewController as a subview, simple as that!
```swift
view.addSubview(bottomDrawer)
```

## Installation

### CocoaPods

It is available through [CocoaPods](https://cocoapods.org), a dependecy manager for Cocoa projects. To add `BottomDrawerView` to your project specify it in your `Podfile`:
```ruby
pod 'BottomDrawerView'
```

### Swift Package Manager

It is also available using [Swift Package Manager](https://swift.org/package-manager/).


## TODOs
- [ ] support for `UIVisualEffectView`
