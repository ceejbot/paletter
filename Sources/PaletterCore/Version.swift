import Foundation

public struct AppVersion {
  public static let current = "1.0.0"
  public static let name = "paletter"

  public static var fullVersion: String {
    return "\(name) \(current)"
  }
}
