import Foundation
import UIKit
import PDFKit

class PDFGenerator {
    static func generatePDF(
        title: String,
        message: String,
        createdDate: Date,
        unlockDate: Date,
        images: [UIImage]
    ) -> URL? {
        let pdfMetaData = [
            kCGPDFContextCreator: "TimeCapsule",
            kCGPDFContextTitle: title
        ]

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.5 * 72.0
        let pageHeight = 11.0 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let margin: CGFloat = 50

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let data = renderer.pdfData { (context) in
            context.beginPage()

            var yPosition: CGFloat = margin

            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 24),
                .foregroundColor: UIColor.black
            ]
            let titleRect = CGRect(x: margin, y: yPosition, width: pageWidth - 2 * margin, height: 40)
            title.draw(in: titleRect, withAttributes: titleAttributes)
            yPosition += 50

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long

            let metaAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.gray
            ]

            let createdText = "Created: \(dateFormatter.string(from: createdDate))"
            let createdRect = CGRect(x: margin, y: yPosition, width: pageWidth - 2 * margin, height: 20)
            createdText.draw(in: createdRect, withAttributes: metaAttributes)
            yPosition += 20

            let unlockedText = "Unlocked: \(dateFormatter.string(from: unlockDate))"
            let unlockedRect = CGRect(x: margin, y: yPosition, width: pageWidth - 2 * margin, height: 20)
            unlockedText.draw(in: unlockedRect, withAttributes: metaAttributes)
            yPosition += 40

            context.cgContext.setStrokeColor(UIColor.lightGray.cgColor)
            context.cgContext.setLineWidth(1)
            context.cgContext.move(to: CGPoint(x: margin, y: yPosition))
            context.cgContext.addLine(to: CGPoint(x: pageWidth - margin, y: yPosition))
            context.cgContext.strokePath()
            yPosition += 30

            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.black
            ]

            let messageRect = CGRect(
                x: margin,
                y: yPosition,
                width: pageWidth - 2 * margin,
                height: pageHeight - yPosition - margin - (images.isEmpty ? 0 : 300)
            )

            message.draw(in: messageRect, withAttributes: messageAttributes)

            if !images.isEmpty {
                yPosition = pageHeight - margin - 250

                context.cgContext.setStrokeColor(UIColor.lightGray.cgColor)
                context.cgContext.setLineWidth(1)
                context.cgContext.move(to: CGPoint(x: margin, y: yPosition))
                context.cgContext.addLine(to: CGPoint(x: pageWidth - margin, y: yPosition))
                context.cgContext.strokePath()
                yPosition += 20

                let photosLabelAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 16),
                    .foregroundColor: UIColor.black
                ]
                let photosRect = CGRect(x: margin, y: yPosition, width: pageWidth - 2 * margin, height: 30)
                "Photos".draw(in: photosRect, withAttributes: photosLabelAttributes)
                yPosition += 30

                let imageWidth: CGFloat = 200
                let imageHeight: CGFloat = 200
                var xPosition = margin

                for (index, image) in images.enumerated() {
                    if index > 0 && index % 2 == 0 {
                        context.beginPage()
                        yPosition = margin
                        xPosition = margin
                    } else if index > 0 {
                        xPosition = pageWidth - margin - imageWidth
                    }

                    let imageRect = CGRect(x: xPosition, y: yPosition, width: imageWidth, height: imageHeight)
                    image.draw(in: imageRect)

                    if index % 2 == 1 {
                        yPosition += imageHeight + 20
                        xPosition = margin
                    }
                }
            }
        }

        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let pdfPath = documentsPath.appendingPathComponent("TimeCapsule_\(title)_\(UUID().uuidString).pdf")

        do {
            try data.write(to: pdfPath)
            return pdfPath
        } catch {
            print("Could not create PDF file: \(error.localizedDescription)")
            return nil
        }
    }
}
