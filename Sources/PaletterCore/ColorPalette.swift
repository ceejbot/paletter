import Foundation

public struct ColorPalette: Decodable {
  public let system: String?
  public let name: String
  public let author: String?
  public let variant: String?
  public let palette: PaletteVariant

  enum CodingKeys: String, CodingKey {
    case system, name, author, variant, palette
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.system = try container.decodeIfPresent(String.self, forKey: .system)
    self.name = try container.decode(String.self, forKey: .name)
    self.author = try container.decodeIfPresent(String.self, forKey: .author)
    self.variant = try container.decodeIfPresent(String.self, forKey: .variant)

    // The "system" field is an internal tag that indicates which variety this
    // palette is: 16 or 24 colors?
    if let system = self.system {
      switch system {
      case "base16":
        let base16 = try container.decode(Base16Palette.self, forKey: .palette)
        self.palette = .base16(base16)
      case "base24":
        let base24 = try container.decode(Base24Palette.self, forKey: .palette)
        self.palette = .base24(base24)
      default:
        // Try to decode as base24 first (superset), then base16
        if let base24 = try? container.decode(Base24Palette.self, forKey: .palette) {
          self.palette = .base24(base24)
        } else {
          let base16 = try container.decode(Base16Palette.self, forKey: .palette)
          self.palette = .base16(base16)
        }
      }
    } else {
      // No system field, try to detect
      if let base24 = try? container.decode(Base24Palette.self, forKey: .palette) {
        self.palette = .base24(base24)
      } else {
        let base16 = try container.decode(Base16Palette.self, forKey: .palette)
        self.palette = .base16(base16)
      }
    }
  }
}

public enum PaletteVariant {
  case base16(Base16Palette)
  case base24(Base24Palette)

  public var allColors: [(name: String, hex: String)] {
    switch self {
    case .base16(let palette):
      return palette.allColors
    case .base24(let palette):
      return palette.allColors
    }
  }
}

public struct Base16Palette: Codable {
  public let base00: String
  public let base01: String
  public let base02: String
  public let base03: String
  public let base04: String
  public let base05: String
  public let base06: String
  public let base07: String
  public let base08: String
  public let base09: String
  public let base0A: String
  public let base0B: String
  public let base0C: String
  public let base0D: String
  public let base0E: String
  public let base0F: String

  public var allColors: [(name: String, hex: String)] {
    return [
      ("Base 00", base00),
      ("Base 01", base01),
      ("Base 02", base02),
      ("Base 03", base03),
      ("Base 04", base04),
      ("Base 05", base05),
      ("Base 06", base06),
      ("Base 07", base07),
      ("Base 08", base08),
      ("Base 09", base09),
      ("Base 0A", base0A),
      ("Base 0B", base0B),
      ("Base 0C", base0C),
      ("Base 0D", base0D),
      ("Base 0E", base0E),
      ("Base 0F", base0F),
    ]
  }
}

public struct Base24Palette: Codable {
  public let base00: String
  public let base01: String
  public let base02: String
  public let base03: String
  public let base04: String
  public let base05: String
  public let base06: String
  public let base07: String
  public let base08: String
  public let base09: String
  public let base0A: String
  public let base0B: String
  public let base0C: String
  public let base0D: String
  public let base0E: String
  public let base0F: String
  public let base10: String
  public let base11: String
  public let base12: String
  public let base13: String
  public let base14: String
  public let base15: String
  public let base16: String
  public let base17: String

  public var allColors: [(name: String, hex: String)] {
    return [
      ("Base 00", base00),
      ("Base 01", base01),
      ("Base 02", base02),
      ("Base 03", base03),
      ("Base 04", base04),
      ("Base 05", base05),
      ("Base 06", base06),
      ("Base 07", base07),
      ("Base 08", base08),
      ("Base 09", base09),
      ("Base 0A", base0A),
      ("Base 0B", base0B),
      ("Base 0C", base0C),
      ("Base 0D", base0D),
      ("Base 0E", base0E),
      ("Base 0F", base0F),
      ("Base 10", base10),
      ("Base 11", base11),
      ("Base 12", base12),
      ("Base 13", base13),
      ("Base 14", base14),
      ("Base 15", base15),
      ("Base 16", base16),
      ("Base 17", base17),
    ]
  }
}
