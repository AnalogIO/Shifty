# Shifty

Architecture: Clean Swift

## Setup

1. Clone repository
2. Navigate to the root of the project `cd Shifty`
3. Install dependencies `carthage bootstrap --platform ios`
4. Add Config.swift file in `ShiftPlanningAPI/Sources/Config.swift` and `ClipCardAPI/Sources/Config.swift`

### ShiftPlanningAPI/Sources/Config.swift Template

```swift
public struct Config {
    #if DEBUG
    static let apikey: String = "API-KEY TEST-ENV"
    #else
    static let apikey: String = "API-KEY PROD-ENV"
    #endif
}
```

### ClipCardAPI/Sources/Config.swift Template


```swift
public struct Config {
    #if DEBUG
    public static let email: String = "ADMIN EMAIL TEST-ENV"
    public static let password: String = "ADMIN PASSWORD TEST-ENV"
    #else
    public static let email: String = "ADMIN EMAIL PROD-ENV"
    public static let password: String = "ADMIN PASSWORD PROD-ENV"
    #endif
}
```
