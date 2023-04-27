<div align="center">
    <img src="./Assets/NetworkDebugger.png" alt="Network Debugger" />
    <h2>Network Debugger</h2>
    <p>A Swift package designed to view your App's networking activity with minimal setup.</p>
    <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen.svg?style=flat-square" alt="PRs Welcome" />
</div>

---

## Features
- Minimal setup. Add one line of code and the package does the rest!
- Built-in shake gestures that can be disabled!
- SwiftUI and UIKit compatible!
- Ignore hosts from being recorded!
- Use settings at runtime to filter the requests!
- Syntax highlighting for body data!

## Installation

### Swift Package Manager
Install through the Swift Package Manager using Xcode.

### Cocoa Pods
Add to your `podfile` and install using `pod install`.
```ruby
pod 'NetworkDebugger', '~> 1.0.1'
```

## Setup
In order for the package to work properly, you need to call `start()` as the first method in your `AppDelegate`! (For SwiftUI apps you need to use `@UIApplicationDelegateAdaptor`)
**Note:** It is highly encouraged to only call `start()` in debug or testing environments and **not** in production.
```swift
final class ApplicationDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        #if DEBUG
        NetworkDebugger.start()
        #endif
    }
}
```

## Configuration
All configuration has to be called *before* the `start()` method is called.

### Ignoring hosts
Simply set the `ignoredHosts` property!
```swift
NetworkDebugger.ignoredHosts = [
    "subdomain.example.com",
    "example.com"
]
```

### Limiting amount of requests
`NetworkDebugger` only stores n amount of requests. You can configure this by setting the `maxRequests` property!
```swift
NetworkDebugger.maxRequests = 100 // Default
```

### Disabling shake gestures
To disable shake gestures simply set the `shakeEnabled` property!
```swift
NetworkDebugger.shakeEnabled = false
```

### Displaying NetworkDebugger

#### SwiftUI
For SwiftUI, simply return the `NetworkDebuggerView()`!
```swift
struct MyView: View {
    var body: some View {
        NetworkDebuggerView()
    }
}
```

#### UIKit
For UIKit, simply call `presentNetworkDebugger()`! Optionally you can provide the `UIViewController` to present `NetworkDebugger` on.
```swift
class MyViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // If the ViewController is known
        NetworkDebugger.presentNetworkDebugger(on: self)
        // Will attempt to display on the top most ViewController
        NetworkDebugger.presentNetworkDebugger()
    }
}
```

## Maintainers
| Name                                   | Email                      |
| :------------------------------------- | :------------------------- |
| [@Asmeili](https://github.com/Asmeili) | michael.artes@mail.schwarz |
