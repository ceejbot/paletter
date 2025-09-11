import Foundation

struct AppVersion {
  static let current = "1.0.0"
  static let name = "paletter"

  static var fullVersion: String {
    return "\(name) \(current)"
  }
}
