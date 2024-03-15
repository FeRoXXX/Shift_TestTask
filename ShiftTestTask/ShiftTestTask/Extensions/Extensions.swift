//
//  GlobalFunctions.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 13.03.2024.
//

import UIKit

extension UITextView {
    
    func highlightingTitle() {
        guard let text = self.text else {
            return
        }

        let attributedString = NSMutableAttributedString(attributedString: self.attributedText)

        let lines = text.components(separatedBy: "\n")

        var location = 0
        for line in lines {
            
            let lineRange = NSRange(location: location, length: line.utf16.count)
            location += line.utf16.count + 1
            
            var lineAttributes : [NSAttributedString.Key : Any] = [:]
            if location != 0 && lineRange.length != 0 {
                lineAttributes = attributedString.attributes(at: lineRange.location, effectiveRange: nil)
            }

            let hasAttachment = lineAttributes.keys.contains { key in
                key == NSAttributedString.Key.attachment
            }
            let hasAnyAttributed = lineAttributes.keys.contains { key in
                let string = NSMutableAttributedString(AttributedString(stringLiteral: "a"))
                let attribute = string.attributes(at: 0, effectiveRange: nil)
                if attribute.keys.contains(where: { newKey in
                    newKey == key
                }) {
                    return true
                } else {
                    return false
                }
            }

            if !hasAttachment && !hasAnyAttributed {
                if lineRange.location == 0 {
                    attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: lineRange)
                } else {
                    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18), range: lineRange)
                }
            }
        }
        self.attributedText = attributedString
    }
    
    func moveCursor() {
        self.selectedRange = NSRange(location: self.text.count, length: 0)
        
        self.replace(self.selectedTextRange!, withText: "\n")
    }

    
    func findCursorIndex() -> Int {
        if self.text == "" { return 0 }
        if let selectedRange = self.selectedTextRange {
            let cursorPosition = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
            return cursorPosition
        }
        return 0
    }
    
}

extension String {
    
    func findTitleAndText() -> (title: String?, text: String?) {
        
        let lines = self.components(separatedBy: CharacterSet.newlines)
        var title: String?
        var text: String?
        
        for (_, line) in lines.enumerated() {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedLine.isEmpty {
                if title == nil {
                    title = trimmedLine
                } else {
                    if text == nil {
                        text = trimmedLine
                    } else {
                        text! += "\n" + trimmedLine
                    }
                }
            }
        }
        
        return (title, text)
    }
    
}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let height = CGFloat(ceil(width / size.width * size.height))
        let canvasSize = CGSize(width: width - 10, height: height - 10)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension NSAttributedString {
    
    convenience init?(base64EndodedImageString encodedImageString: String) {
        var html = """
        <!DOCTYPE html>
        <html>
          <body>
            <img src="data:image/png;base64,\(encodedImageString)">
          </body>
        </html>
        """
        let data = Data(html.utf8)
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        try? self.init(data: data, options: options, documentAttributes: nil)
    }

    func toNSData() -> NSData? {
        let options : [NSAttributedString.DocumentAttributeKey: Any] = [
            .documentType: NSAttributedString.DocumentType.rtfd,
            .characterEncoding: String.Encoding.utf8
        ]

        let range = NSRange(location: 0, length: length)
        guard let data = try? data(from: range, documentAttributes: options) else {
            return nil
        }

        return NSData(data: data)
    }
    
}

extension NSData {
    func toAttributedString() -> NSAttributedString? {
        let data = Data(referencing: self)
        let options : [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.rtfd,
            .characterEncoding: String.Encoding.utf8
        ]

        return try? NSAttributedString(data: data,
                                       options: options,
                                       documentAttributes: nil)
    }
}
