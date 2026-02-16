import AppKit
import Foundation
import Testing
import Yams

@testable import PaletterCore

@Suite("ColorConverter")
struct ColorConverterTests {

  static let testYAML = """
    system: "base16"
    name: "Converter Test"
    author: "Tester"
    palette:
      base00: "002B36"
      base01: "073642"
      base02: "586E75"
      base03: "657B83"
      base04: "839496"
      base05: "93A1A1"
      base06: "EEE8D5"
      base07: "FDF6E3"
      base08: "DC322F"
      base09: "CB4B16"
      base0A: "B58900"
      base0B: "859900"
      base0C: "2AA198"
      base0D: "268BD2"
      base0E: "6C71C4"
      base0F: "D33682"
    """

  @Test("createColorList produces correct number of named colors with correct RGB")
  func createColorListFromPalette() throws {
    let decoder = YAMLDecoder()
    let palette = try decoder.decode(ColorPalette.self, from: Self.testYAML)
    let colorList = ColorConverter.createColorList(from: palette)

    // Should have 16 colors
    #expect(colorList.allKeys.count == 16)

    // Verify first color: base00 = 002B36
    let base00 = colorList.color(withKey: "Base 00")
    #expect(base00 != nil)
    #expect(abs(base00!.redComponent - 0.0) < 0.01)
    #expect(abs(base00!.greenComponent - CGFloat(0x2B) / 255.0) < 0.01)
    #expect(abs(base00!.blueComponent - CGFloat(0x36) / 255.0) < 0.01)
  }

  @Test("Round-trip: create, save to temp dir, read back, verify colors survive")
  func roundTrip() throws {
    let decoder = YAMLDecoder()
    let palette = try decoder.decode(ColorPalette.self, from: Self.testYAML)
    let colorList = ColorConverter.createColorList(from: palette)

    // Save to a temp directory
    let tempDir = FileManager.default.temporaryDirectory
      .appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    defer { try? FileManager.default.removeItem(at: tempDir) }

    let outputURL = tempDir.appendingPathComponent("test-palette.clr")
    try colorList.write(to: outputURL)

    // Read back
    let loaded = NSColorList(name: "test-palette", fromFile: outputURL.path)
    #expect(loaded != nil)

    // Verify every color name and value survives
    for key in colorList.allKeys {
      let original = colorList.color(withKey: key)
      let restored = loaded!.color(withKey: key)
      #expect(original != nil)
      #expect(restored != nil)
      #expect(abs(original!.redComponent - restored!.redComponent) < 0.001)
      #expect(abs(original!.greenComponent - restored!.greenComponent) < 0.001)
      #expect(abs(original!.blueComponent - restored!.blueComponent) < 0.001)
    }
  }

  @Test("Invalid hex in palette is gracefully skipped")
  func invalidHexSkipped() throws {
    let yamlWithBadHex = """
      system: "base16"
      name: "Bad Hex Test"
      author: "Tester"
      palette:
        base00: "ZZZZZZ"
        base01: "073642"
        base02: "586E75"
        base03: "657B83"
        base04: "839496"
        base05: "93A1A1"
        base06: "EEE8D5"
        base07: "FDF6E3"
        base08: "DC322F"
        base09: "CB4B16"
        base0A: "B58900"
        base0B: "859900"
        base0C: "2AA198"
        base0D: "268BD2"
        base0E: "6C71C4"
        base0F: "D33682"
      """
    let decoder = YAMLDecoder()
    let palette = try decoder.decode(ColorPalette.self, from: yamlWithBadHex)
    let colorList = ColorConverter.createColorList(from: palette)

    // One invalid hex → 15 colors instead of 16
    #expect(colorList.allKeys.count == 15)
  }
}
