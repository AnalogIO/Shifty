import Foundation

struct Config {
    #if DEBUG
    static let apikey: String = "INSERT TEST-ENV API KEY"
    #else
    static let apikey: String = "INSERT PROD-ENV API KEY"
    #endif
}
