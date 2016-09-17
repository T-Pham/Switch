```
'   :::===  :::  ===  === ::: :::==== :::===== :::  ===
'   :::     :::  ===  === ::: :::==== :::      :::  ===
'    =====  ===  ===  === ===   ===   ===      ========
'       ===  ===========  ===   ===   ===      ===  ===
'   ======    ==== ====   ===   ===    ======= ===  ===
'                                                              
```

# Switch

[![CI Status](https://img.shields.io/travis/T-Pham/Switch/master.svg?style=flat-square)](https://travis-ci.org/T-Pham/Switch)
[![GitHub issues](https://img.shields.io/github/issues/T-Pham/Switch.svg?style=flat-square)](https://github.com/T-Pham/Switch/issues)
[![Codecov](https://img.shields.io/codecov/c/github/T-Pham/Switch.svg?style=flat-square)](https://codecov.io/gh/T-Pham/Switch)
[![Documentation](https://img.shields.io/cocoapods/metrics/doc-percent/RoundedSwitch.svg?style=flat-square)](http://cocoadocs.org/docsets/RoundedSwitch)

[![GitHub release](https://img.shields.io/github/tag/T-Pham/Switch.svg?style=flat-square&label=release)](https://github.com/T-Pham/Switch/releases)
[![Platform](https://img.shields.io/cocoapods/p/RoundedSwitch.svg?style=flat-square)](https://github.com/T-Pham/Switch)
[![License](https://img.shields.io/cocoapods/l/Switch.svg?style=flat-square)](LICENSE)

[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)

[![CocoaPods](https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg?style=flat-square)](https://cocoapods.org/pods/RoundedSwitch)
[![CocoaPods downloads](https://img.shields.io/cocoapods/dt/RoundedSwitch.svg?style=flat-square)](https://cocoapods.org/pods/RoundedSwitch)

## Description

An iOS switch control implemented in Swift with full Interface Builder support.

To run the demo project:

`pod try RoundedSwitch`

![Switch](https://github.com/T-Pham/Switch/blob/master/switch.gif?raw=true)

![Switch](https://github.com/T-Pham/Switch/blob/master/switch.png?raw=true)

## Usage

Either config the switch in the Interface Builder or programatically as follow:

```swift
import Switch
...
let mySwitch = Switch()
mySwitch.leftText = "Windows"
mySwitch.rightText = "Mac"
mySwitch.rightSelected = true
mySwitch.tintColor = UIColor.purple
mySwitch.disabledColor = mySwitch.tintColor.withAlphaComponent(0.2)
mySwitch.sizeToFit()
mySwitch.addTarget(self, action: #selector(ViewController.switchDidChangeValue(_:)), for: .valueChanged)
```

Please note that the module name is `Switch`. However, when installed with CocoaPods, it is `RoundedSwitch`.

Please see the [Reference Documentation](http://cocoadocs.org/docsets/RoundedSwitch) for details.

## Installation

### [Carthage](https://github.com/Carthage/Carthage)

Add the line below to your Cartfile:

```ruby
github "T-Pham/Switch"
```

### [CocoaPods](https://cocoapods.org/pods/RoundedSwitch)

Add the line below to your Podfile:

```ruby
pod 'RoundedSwitch'
```

### Manually

Add the file [`Switch.swift`](Switch.swift) to your project. You are all set.

## Compatibility
From version 2.0.0, Swift 3 syntax is used. If your project is still using Swift version 2, please use a UITextField-Navigation version prior to 2.0.0.

Podfile

```ruby
pod 'RoundedSwitch', '~> 1.0.3'
```

or Cartfile

```ruby
github "T-Pham/Switch" ~> 1.0.3
```

## License

Switch is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
