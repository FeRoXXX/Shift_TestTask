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

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5

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

            if !hasAttachment {
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
    func resized(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
