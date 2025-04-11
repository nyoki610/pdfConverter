//
//  PDFDocument.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/12.
//

import SwiftUI
import PDFKit

extension PDFDocument {
  public var imageRepresenation: UIImage? {
    guard let pdfPage = self.page(at: 0) else { return nil }
    let pageBounds = pdfPage.bounds(for: .cropBox)

    let renderer = UIGraphicsImageRenderer(size: pageBounds.size)
    let image = renderer.image { ctx in
      UIColor.white.set()
      ctx.fill(pageBounds)

      ctx.cgContext.translateBy(x: 0.0, y: pageBounds.size.height)
      ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

      UIGraphicsPushContext(ctx.cgContext)
      pdfPage.draw(with: .cropBox, to: ctx.cgContext)
      UIGraphicsPopContext()
    }
    return image
  }
}

extension PDFDocument: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .pdf) { pdf in
            guard let data = pdf.dataRepresentation() else {
                fatalError("Could not create a pdf file")
            }

    var fileURL = FileManager.default
      .temporaryDirectory

    if let title = pdf.title {
      fileURL = fileURL
        .appendingPathComponent(title)
    }

    try data.write(to: fileURL)
    return SentTransferredFile(fileURL)
    }
  }
}
extension PDFDocument {
  public var title: String? {
  guard let attributes = self.documentAttributes,
        let titleAttribute = attributes[PDFDocumentAttribute.titleAttribute]
  else { return nil }

  return titleAttribute as? String
  }
}
