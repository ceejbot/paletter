import AppKit
import Testing

@testable import PaletterCore

@Suite("String.hexToNSColor()")
struct HexToColorTests {

  @Test("Valid 6-digit hex with # prefix")
  func validHexWithPrefix() {
    let color = "#FF8000".hexToNSColor()
    #expect(color != nil)
    let c = color!
    #expect(abs(c.redComponent - 1.0) < 0.01)
    #expect(abs(c.greenComponent - 0.502) < 0.01)
    #expect(abs(c.blueComponent - 0.0) < 0.01)
  }

  @Test("Valid 6-digit hex without prefix gives same result")
  func validHexWithoutPrefix() {
    let withPrefix = "#FF8000".hexToNSColor()
    let withoutPrefix = "FF8000".hexToNSColor()
    #expect(withPrefix != nil)
    #expect(withoutPrefix != nil)
    #expect(withPrefix!.redComponent == withoutPrefix!.redComponent)
    #expect(withPrefix!.greenComponent == withoutPrefix!.greenComponent)
    #expect(withPrefix!.blueComponent == withoutPrefix!.blueComponent)
  }

  @Test("000000 gives black")
  func blackColor() {
    let color = "000000".hexToNSColor()
    #expect(color != nil)
    #expect(color!.redComponent == 0.0)
    #expect(color!.greenComponent == 0.0)
    #expect(color!.blueComponent == 0.0)
  }

  @Test("FFFFFF gives white")
  func whiteColor() {
    let color = "FFFFFF".hexToNSColor()
    #expect(color != nil)
    #expect(color!.redComponent == 1.0)
    #expect(color!.greenComponent == 1.0)
    #expect(color!.blueComponent == 1.0)
  }

  @Test("Too short returns nil")
  func tooShort() {
    #expect("FFF".hexToNSColor() == nil)
  }

  @Test("Too long returns nil")
  func tooLong() {
    #expect("FF00FF00".hexToNSColor() == nil)
  }

  @Test("Non-hex characters return nil")
  func nonHexCharacters() {
    #expect("ZZZZZZ".hexToNSColor() == nil)
  }
}
