# Getting consistent temperature preferences on iOS

iOS' Settings app allows for a variety of fine-tunings of user preferences, which is particularly handy if you've grown up half the time in Canada and the USA and your personal locale is best described as "it's complicated".

![The Language & Region Settings page on iOS, showing a selected temperature preference of Celsius](/gfx/temperaturepref.png)

One of [Sidecar](https://sidecar.clutch.engineering)'s core design principles is to **reduce actions to value**, and in this spirit I wanted Sidecar to respect system preferences out of the box while still providing the option to override them within the app. This desire meant supporting metric vs imperial measurements, 12 vs 24 hour time, and - you guessed it - temperature preferences.

## The problem

The naive approach to providing a configurable temperature preference might look something like this:

```swift
struct ContentView: View {
  enum TemperaturePreference {
    case celsius
    case fahrenheit
    case systemDefault

    var preferredUnit: UnitTemperature? {
      switch self {
      case .celsius:
        return .celsius
      case .fahrenheit:
        return .fahrenheit
      case .systemDefault:
        return nil
      }
    }
  }
  @State private var temperaturePreference: TemperaturePreference = .systemDefault

  var body: some View {
    VStack {
      HStack(alignment: .firstTextBaseline) {
        Text("Initially 32 celsius:")
        Text(formattedTemperature(Measurement(value: 32, unit: UnitTemperature.celsius)))
      }
      HStack(alignment: .firstTextBaseline) {
        Text("Initially 32 fahrenheit:")
        Text(formattedTemperature(Measurement(value: 32, unit: UnitTemperature.fahrenheit)))
      }

      Picker(selection: $temperaturePreference) {
        Text("Celsius")
          .tag(TemperaturePreference.celsius)
        Text("Fahrenheit")
          .tag(TemperaturePreference.fahrenheit)
        Text("System default")
          .tag(TemperaturePreference.systemDefault)
      } label: {
        Text("Preference")
      }
    }
    .padding()
  }

  private func formattedTemperature(_ temperature: Measurement<UnitTemperature>) -> String {
    var temperature = temperature
    let measurementFormatter = MeasurementFormatter()
    if let preferredUnit = temperaturePreference.preferredUnit {
      temperature = temperature.converted(to: preferredUnit)
      measurementFormatter.unitOptions = .providedUnit
    }
    return measurementFormatter.string(from: temperature)
  }
}
```

This code relies on `MeasurementFormatter` to handle the system preference when `preferredUnit` is nil. While this works on device, there's an unfortunate gotcha: the iOS Simulator ignores the system temperature preference. Deviations between the simulator and device drive me bananas, and I wanted to make sure that the app behaves similarly in each environment that I test it in.

| Preference |  Unexpected simulator behavior  |
|:----------:|:-----------:|
| ![System preference set to Celsius](/gfx/systemtemperature.png) | ![Correctly formatted temperature showing Celsius values](/gfx/temperaturebad.png) |

## The solution

Thankfully Apple introduced a reliable way to access the user's system temperature preference in iOS 16:

```swift
let unitTemperature = UnitTemperature(forLocale: Locale.current)
```

The API lacks any notable [documentation](https://developer.apple.com/documentation/foundation/unittemperature/4020257-init), which can make it an easy API to miss.

We can now fix our previous implementation:

```swift
var preferredUnit: UnitTemperature {
  switch self {
  case .celsius:
    return .celsius
  case .fahrenheit:
    return .fahrenheit
  case .systemDefault:
    // Use the iOS 16 API to get the system temperature unit preference.
    return UnitTemperature(forLocale: Locale.current)
  }
}

private func formattedTemperature(_ temperature: Measurement<UnitTemperature>) -> String {
  var temperature = temperature
  let measurementFormatter = MeasurementFormatter()
  // We can now always convert to the preferred unit.
  temperature = temperature.converted(to: temperaturePreference.preferredUnit)
  measurementFormatter.unitOptions = .providedUnit
  return measurementFormatter.string(from: temperature)
}
```

Love it!

| Preference |  Correctly formatted on the simulator  |
|:----------:|:-----------:|
| ![System preference set to Celsius](/gfx/systemtemperature.png) | ![Correctly formatted temperature showing Celsius values](/gfx/temperaturegood.png) |

## What changed?

The key differences in the fixed implementation are:

1. `preferredUnit` is no longer optional.
2. We always explicitly specify the unit rather than relying on MeasurementFormatter's undocumented and inconsistent behavior.
3. We use `UnitTemperature(forLocale:)` to respect the system preference consistently.
