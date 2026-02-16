import ArgumentParser
import Foundation
import PaletterCore
import Yams

struct CLRPaletter: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "paletter",
    abstract: "Convert Tinty's YAML color palettes to macOS .clr files",
    version: AppVersion.current
  )

  @Argument(help: "Directory containing YAML color palette files")
  var inputDirectory: String

  @Option(
    name: .shortAndLong,
    help: "Output directory for .clr files (defaults to input directory)"
  )
  var output: String?

  @Flag(
    name: .shortAndLong,
    help: "Show verbose output"
  )
  var verbose = false

  func run() throws {
    let fileManager = FileManager.default
    var isDirectory: ObjCBool = false

    // Validate input directory
    guard fileManager.fileExists(atPath: inputDirectory, isDirectory: &isDirectory),
      isDirectory.boolValue
    else {
      throw CLRPaletterError.invalidInputDirectory(inputDirectory)
    }

    // Validate/create output directory if specified
    if let outputPath = output {
      if fileManager.fileExists(atPath: outputPath, isDirectory: &isDirectory) {
        if !isDirectory.boolValue {
          throw CLRPaletterError.invalidOutputDirectory(outputPath)
        }
      } else {
        if verbose {
          print("Creating output directory: \(outputPath)")
        }
        try fileManager.createDirectory(
          atPath: outputPath,
          withIntermediateDirectories: true
        )
      }
    }

    if verbose {
      print("Processing directory: \(inputDirectory)")
      if let outputPath = output {
        print("Output directory: \(outputPath)")
      } else {
        print("Output directory: \(inputDirectory) (same as input)")
      }
    }

    let yamlFiles = try findYAMLFiles(in: inputDirectory)

    if yamlFiles.isEmpty {
      print("No YAML files found in directory")
      return
    }

    if verbose {
      print("Found \(yamlFiles.count) YAML file(s):")
      for file in yamlFiles {
        print("  - \(file.lastPathComponent)")
      }
    }

    for yamlFile in yamlFiles {
      try processYAMLFile(yamlFile, outputDirectory: output)
    }

    print("Successfully converted \(yamlFiles.count) color palette(s)")
  }

  func findYAMLFiles(in directoryPath: String) throws -> [URL] {
    let fileManager = FileManager.default
    let directoryURL = URL(fileURLWithPath: directoryPath)

    let contents = try fileManager.contentsOfDirectory(
      at: directoryURL,
      includingPropertiesForKeys: nil,
      options: [.skipsHiddenFiles]
    )

    return contents.filter { url in
      let pathExtension = url.pathExtension.lowercased()
      return pathExtension == "yaml" || pathExtension == "yml"
    }
  }

  func processYAMLFile(_ fileURL: URL, outputDirectory: String?) throws {
    if verbose {
      print("\nProcessing: \(fileURL.lastPathComponent)")
    }

    let yamlString = try String(contentsOf: fileURL, encoding: .utf8)
    let decoder = YAMLDecoder()
    let palette = try decoder.decode(ColorPalette.self, from: yamlString)

    if verbose {
      print("  Name: \(palette.name)")
      if let author = palette.author {
        print("  Author: \(author)")
      }
      print("  Colors: \(palette.palette.allColors.count)")
    }

    let colorList = ColorConverter.createColorList(from: palette)

    // Use output directory if provided, otherwise use input file's directory
    let outputURL: URL
    if let outputDirectory = outputDirectory {
      let outputDirURL = URL(fileURLWithPath: outputDirectory)
      let outputFileName = fileURL.deletingPathExtension().lastPathComponent + ".clr"
      outputURL = outputDirURL.appendingPathComponent(outputFileName)
    } else {
      outputURL = fileURL.deletingPathExtension().appendingPathExtension("clr")
    }

    try ColorConverter.saveColorList(colorList, to: outputURL)

    if verbose {
      print("  Created: \(outputURL.lastPathComponent)")
    }
  }
}

enum CLRPaletterError: LocalizedError {
  case invalidInputDirectory(String)
  case invalidOutputDirectory(String)

  var errorDescription: String? {
    switch self {
    case .invalidInputDirectory(let path):
      return "'\(path)' is not a valid directory"
    case .invalidOutputDirectory(let path):
      return "'\(path)' is not a valid directory"
    }
  }
}

// Entry point
CLRPaletter.main()
