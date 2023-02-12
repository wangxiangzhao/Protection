# Protection

[![CI Status](https://img.shields.io/travis/小叨/Protection.svg?style=flat)](https://travis-ci.org/小叨/Protection)
[![Version](https://img.shields.io/cocoapods/v/Protection.svg?style=flat)](https://cocoapods.org/pods/Protection)
[![License](https://img.shields.io/cocoapods/l/Protection.svg?style=flat)](https://cocoapods.org/pods/Protection)
[![Platform](https://img.shields.io/cocoapods/p/Protection.svg?style=flat)](https://cocoapods.org/pods/Protection)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Protection is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Protection'
```
## 使用方法
[XDProtection openProtection:XDExcetionTypeAll callHandler:^(XDException * _Nonnull exception) {
    NSLog(@"%@", exception.description);
}];

## Author

小叨, 13269532539@163.com

## License

Protection is available under the MIT license. See the LICENSE file for more info.
