import Foundation

public struct Config {
    #if DEBUG
    public static let email: String = "INSERT ADMIN TEST-ENV EMAIL"
    public static let password: String = "INSERT ADMIN TEST-ENV PASSWORD"
    #else
    public static let email: String = "INSERT ADMIN PROD-ENV EMAIL"
    public static let password: String = "INSERT ADMIN PROD-ENV PASSWORD"
    #endif
}
