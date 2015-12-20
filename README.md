# FEQRScanViewController

[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/fabianehlert/FEQRScanViewController)
[![Platform](https://img.shields.io/badge/platform-iOS-yellow.svg)](https://github.com/fabianehlert/FEQRScanViewController)
[![Build Status](https://travis-ci.org/fabianehlert/FEQRScanViewController.svg?branch=master)](https://travis-ci.org/fabianehlert/FEQRScanViewController)
[![Twitter: @fabianehlert](https://img.shields.io/badge/twitter-fabianehlert-blue.svg)](https://twitter.com/fabianehlert)

**Swift 2.2 ready**

**100% Swift** 🤓

---

## About FEQRScanViewController

Coming soon!

## Usage

### Import

1. Import `AVFoundation.framework` into your Project
2. Add `FEQRScanViewController.swift` to your Project
3. Have fun!

### Code examples

Simply presenting the scanner:
```swift
let scanner = FEQRScanViewController()
presentViewController(scanner, animated: true, completion: nil)
```

Presenting the scanner in a `UINavigationController` and setting its Close-Button title:
```swift
let scanner = FEQRScanViewController(closeTitle: "Ciao!")

let navController = UINavigationController(rootViewController: scanner)
presentViewController(navController, animated: true, completion: nil)
```

In order to receive a result from the scanner, you'll need to implement the `FEQRScanViewControllerDelegate` protocol and set the `delegate` property of the scanner accordingly:
```swift
let scanner = FEQRScanViewController()
scanner.delegate = self
```

Furthermore you'll also need to implement the `didScanCodeWithResult()` protocol function. The result is passed as a String:
```swift
func didScanCodeWithResult(result: String) {
    print("Scanner returned result: \(result)")
}
```

## License

The MIT License (MIT)

Copyright (c) 2015 Fabian Ehlert

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
