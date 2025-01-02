// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import CoreImage
import Foundation
import UniformTypeIdentifiers

extension CGImage {
    public enum ExportType: String {
        case png
        case jpeg
        case heif
        case tiff

        public var utType: UTType {
            switch self {
            case .png: return .png
            case .jpeg: return .jpeg
            case .heif: return .heif
            case .tiff: return .tiff
            }
        }
    }

    public func export(type: ExportType, to url: URL) throws {
        let ciContext = CIContext()
        let ciImage = CIImage(cgImage: self)

        guard let colorSpace = ciImage.colorSpace else {
            throw NSError(description: "Invalid colorSpace in returned CIImage")
        }

        switch type {
        case .png:
            try ciContext.writePNGRepresentation(of: ciImage, to: url, format: .RGBA8, colorSpace: colorSpace)

        case .jpeg:
            try ciContext.writeJPEGRepresentation(of: ciImage, to: url, colorSpace: colorSpace)

        case .heif:
            try ciContext.writeHEIFRepresentation(of: ciImage, to: url, format: .RGBA8, colorSpace: colorSpace)

        case .tiff:
            try ciContext.writeTIFFRepresentation(of: ciImage, to: url, format: .RGBA8, colorSpace: colorSpace)
        }
    }
}
