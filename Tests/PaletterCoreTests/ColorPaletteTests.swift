import Foundation
import Testing
import Yams

@testable import PaletterCore

@Suite("ColorPalette YAML decoding")
struct ColorPaletteTests {

  static let base16YAML = """
    system: "base16"
    name: "Test Base16"
    author: "Tester"
    palette:
      base00: "000000"
      base01: "111111"
      base02: "222222"
      base03: "333333"
      base04: "444444"
      base05: "555555"
      base06: "666666"
      base07: "777777"
      base08: "888888"
      base09: "999999"
      base0A: "AAAAAA"
      base0B: "BBBBBB"
      base0C: "CCCCCC"
      base0D: "DDDDDD"
      base0E: "EEEEEE"
      base0F: "FFFFFF"
    """

  static let base24YAML = """
    system: "base24"
    name: "Test Base24"
    author: "Tester"
    palette:
      base00: "000000"
      base01: "111111"
      base02: "222222"
      base03: "333333"
      base04: "444444"
      base05: "555555"
      base06: "666666"
      base07: "777777"
      base08: "888888"
      base09: "999999"
      base0A: "AAAAAA"
      base0B: "BBBBBB"
      base0C: "CCCCCC"
      base0D: "DDDDDD"
      base0E: "EEEEEE"
      base0F: "FFFFFF"
      base10: "101010"
      base11: "121212"
      base12: "131313"
      base13: "141414"
      base14: "151515"
      base15: "161616"
      base16: "171717"
      base17: "181818"
    """

  static let noSystemYAML = """
    name: "Auto Detect"
    author: "Tester"
    palette:
      base00: "000000"
      base01: "111111"
      base02: "222222"
      base03: "333333"
      base04: "444444"
      base05: "555555"
      base06: "666666"
      base07: "777777"
      base08: "888888"
      base09: "999999"
      base0A: "AAAAAA"
      base0B: "BBBBBB"
      base0C: "CCCCCC"
      base0D: "DDDDDD"
      base0E: "EEEEEE"
      base0F: "FFFFFF"
    """

  @Test("Base16 YAML decodes with 16 colors and correct metadata")
  func base16Decoding() throws {
    let decoder = YAMLDecoder()
    let palette = try decoder.decode(ColorPalette.self, from: Self.base16YAML)
    #expect(palette.name == "Test Base16")
    #expect(palette.author == "Tester")
    #expect(palette.system == "base16")
    #expect(palette.palette.allColors.count == 16)
  }

  @Test("Base24 YAML decodes with 24 colors")
  func base24Decoding() throws {
    let decoder = YAMLDecoder()
    let palette = try decoder.decode(ColorPalette.self, from: Self.base24YAML)
    #expect(palette.name == "Test Base24")
    #expect(palette.system == "base24")
    #expect(palette.palette.allColors.count == 24)
  }

  @Test("Auto-detection infers base16 when no system field")
  func autoDetection() throws {
    let decoder = YAMLDecoder()
    let palette = try decoder.decode(ColorPalette.self, from: Self.noSystemYAML)
    #expect(palette.name == "Auto Detect")
    #expect(palette.system == nil)
    // Only 16 base colors present, so should detect as base16
    #expect(palette.palette.allColors.count == 16)
  }
}
