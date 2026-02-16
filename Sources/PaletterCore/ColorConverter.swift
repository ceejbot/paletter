import AppKit

extension String {
  public func hexToNSColor() -> NSColor? {
    var hexString = self.trimmingCharacters(in: .whitespacesAndNewlines)

    if hexString.hasPrefix("#") {
      hexString = String(hexString.dropFirst())
    }

    guard hexString.count == 6 else {
      return nil
    }

    let scanner = Scanner(string: hexString)
    var rgbValue: UInt64 = 0

    guard scanner.scanHexInt64(&rgbValue) else {
      return nil
    }

    let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

    return NSColor(red: red, green: green, blue: blue, alpha: 1.0)
  }
}

public struct ColorConverter {
  public static func createColorList(from palette: ColorPalette) -> NSColorList {
    let colorList = NSColorList(name: palette.name)

    for (name, hexColor) in palette.palette.allColors {
      if let color = hexColor.hexToNSColor() {
        colorList.setColor(color, forKey: NSColor.Name(name))
      }
    }

    return colorList
  }

  public static func saveColorList(_ colorList: NSColorList, to outputURL: URL) throws {
    try colorList.write(to: outputURL)

    print("  Created: \(outputURL.lastPathComponent)")
  }
}
