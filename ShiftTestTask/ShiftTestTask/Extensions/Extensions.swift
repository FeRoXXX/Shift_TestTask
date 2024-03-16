//
//  GlobalFunctions.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 13.03.2024.
//

import UIKit
import PhotosUI

extension UITextView {
    
    func highlightingTitle() {
        guard let text = self.text else {
            return
        }
        let cursorPosition = self.getCursorPosition()
        let string = text.findTitleAndText()

        let attributedString = NSMutableAttributedString(attributedString: self.attributedText)

        let lines = text.components(separatedBy: "\n")
        var location = 0
        for line in lines {
            let lineRange = NSRange(location: location, length: line.utf16.count)
            location += line.utf16.count + 1
            
            var lineAttributes : NSAttributedString = NSAttributedString()
            if location != 0 && lineRange.length != 0 {
                lineAttributes = attributedString.attributedSubstring(from: lineRange)
            }
            let hasAttachment = lineAttributes.attributes(at: 0, effectiveRange: nil).keys.contains { key in
                key == NSAttributedString.Key.attachment
            }
            if !hasAttachment {
                if lineRange.location != 0 {
                    if let fontBold = lineAttributes.attributes(at: 0, effectiveRange: nil)[.font] as? UIFont, fontBold.fontDescriptor.symbolicTraits.contains(.traitBold) && fontBold.pointSize == 18 {
                        continue
                    }
                    attributedString.setAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)], range: lineRange)
                    continue
                } else if lineRange.location == 0 && line == string.title{
                    attributedString.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)], range: lineRange)
                }
            }
        }
        self.attributedText = attributedString
        if let cursorPosition = cursorPosition {
            self.setCursorPosition(to: cursorPosition)
        }
    }
    
    func getCursorPosition() -> UITextPosition? {
        return self.selectedTextRange?.start
    }
    
    func isBold() -> Bool {
        guard let stringRange = self.findCurrentStringRange() else { return true }
        let attributedString = NSMutableAttributedString(attributedString: self.attributedText)
        let lineAttributes = attributedString.attributedSubstring(from: stringRange)
        if let fontBold = lineAttributes.attributes(at: 0, effectiveRange: nil)[.font] as? UIFont, fontBold.fontDescriptor.symbolicTraits.contains(.traitBold) {
            return true
        }
        return false
    }
    
    func moveCursor() {
        self.selectedRange = NSRange(location: self.text.count, length: 0)
        
        self.replace(self.selectedTextRange!, withText: "\n")
    }
    
    func setCursorPosition(to position: UITextPosition) {
        self.selectedTextRange = self.textRange(from: position, to: position)
    }
    
    func findCurrentStringRange() -> NSRange? {
        let cursorPosition = self.findCursorIndex()
        
        guard let text = self.text else { return nil}
        
        var lineStartIndex = cursorPosition
        while lineStartIndex > 0 && text[text.index(text.startIndex, offsetBy: lineStartIndex - 1)] != "\n" {
            lineStartIndex -= 1
        }
        
        var lineEndIndex = cursorPosition
        while lineEndIndex < text.count && text[text.index(text.startIndex, offsetBy: lineEndIndex)] != "\n" {
            lineEndIndex += 1
        }
        
        return NSRange(location: lineStartIndex, length: lineEndIndex - lineStartIndex)
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
        let html = """
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

extension [PHPickerResult] {
    func imageProcessing(completion: @escaping (UIImage?) -> Void){
        if let item = self.first?.itemProvider {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { image, error in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(nil)
                    }
                    guard let image = image as? UIImage else { return }
                    completion(image)
                }
            }
        }
    }
}
