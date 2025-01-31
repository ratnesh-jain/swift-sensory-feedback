# SensoryFeedbackClient
A Swift Dependency library for providing dependency entries for Sensory Feeback to trigger the sensory/haptic feedback
This can be done from anywhere where, for example in your code specially where business logic resides (i.e ViewModel, Reducer, Store, etc) but this can also be used inside SwiftUI without any hassle.

## Installation:
```swift
dependencies: [
  .package(url: "https://github.com/ratnesh-jain/swift-sensory-feedback", upToNextMajor("0.0.1")
]
```

### Dependencies:
This library dependens on [swift-dependencies](https://github.com/pointfreeco/swift-dependencies) from the pointfreeco.

The primary reason to choose this is its context awareness, it allows us to change implementation for specific context like Live environment, Unit Test environment or also in Xcode preview environment.

### Internal Details:
- By default the library implemets its feature using UIKit's UIFeedbackGenerator subclasses. But you can override this default implementation using `prepareDependencies` closure at the start of your project or any of live, preview or unit test context.

- ```swift
  class MyApp: App {
    prepareDependencies {
      $0.sensoryFeedback.impact = { type, impact in
      AudioPlayerClient.shared.play(for: type, volume: impact)
    }
    var scene: some Scene {
      AppRootView()
    }
  }
  ```

## Usage:
Library provide three inbuild feedback methods
- UINotificationFeedbackGenerator
```swift
  public var notify: @Sendable (_ type: UINotificationFeedbackGenerator.FeedbackType) -> Void
```
- UISelectionFeedbackGenerator
```swift
public var impact: @Sendable (_ style: UIImpactFeedbackGenerator.FeedbackStyle, _ intesity: CGFloat) -> Void
```
- UISelectionFeedbackGenerator
```swift
public var selection: @Sendable () -> Void
```

```swift
Button("Success Feedback") {
  @Dependency(\.sensoryFeedback) var feedback
  feedback.notify(type: .success)
}
Button("Warning Feedback") {
  @Dependency(\.sensoryFeedback) var feedback
  feedback.notify(type: .warning)
}
Button("Error Feedback") {
  @Dependency(\.sensoryFeedback) var feedback
  feedback.notify(type: .error)
}
```

## Playfull Example
```swift
import Dependencies
import SwiftUI
import SensoryFeedbackClient

struct ContentView: View {
    @State var selectedImpactStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light
    @State var value: CGFloat = 0
    
    var body: some View {
        List {
            Section {
            Button("Success Feedback") {
                @Dependency(\.sensoryFeedback) var feedback
                feedback.notify(type: .success)
            }
            Button("Warning Feedback") {
                @Dependency(\.sensoryFeedback) var feedback
                feedback.notify(type: .warning)
            }
            Button("Error Feedback") {
                @Dependency(\.sensoryFeedback) var feedback
                feedback.notify(type: .error)
            }
            } header: {
                Text("Notification feedback")
            }
            
            Section {
                Picker("Style", selection: $selectedImpactStyle) {
                    ForEach([UIImpactFeedbackGenerator.FeedbackStyle.light, .medium, .heavy, .soft, .rigid], id: \.self) { item in
                        Text("\(item)")
                            .id(item)
                            .tag(item)
                    }
                }
                ForEach(Array(stride(from: 0, to: 2, by: 0.2)), id: \.self) { index in
                    Button("Soft \(index.formatted()) Intensity") {
                        @Dependency(\.sensoryFeedback) var feedback
                        feedback.impact(style: selectedImpactStyle, intesity: CGFloat(index))
                    }
                }
                
            } header: {
                Text("Impact")
            }
            
            Section {
                Slider(value: $value, in: 0...100)
            } header: {
                Text("Selection")
            }
            .onChange(of: value) { oldValue, newValue in
                @Dependency(\.sensoryFeedback) var feedback
                feedback.selection()
            }
        }
    }
}

#Preview {
    ContentView()
}

```
