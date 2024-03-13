//
//  GlobalFunctions.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 13.03.2024.
//

import UIKit

extension UITextView {
    
    func highlightingTitle(textView: UITextView) {
        guard let text = textView.text else {
            return
        }

        let attributedString = NSMutableAttributedString(string: text)

        let firstLineRange = (text as NSString).lineRange(for: NSRange(location: 0, length: 0))
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: firstLineRange)

        let otherLinesRange = NSRange(location: firstLineRange.upperBound, length: attributedString.length - firstLineRange.upperBound)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18), range: otherLinesRange)

        textView.attributedText = attributedString
    }
    
    func findStrings(in textView: UITextView) -> (title: String?, text: String?) {
        guard let textView = textView.text else {
            return (nil, nil)
        }
        
        let lines = textView.components(separatedBy: CharacterSet.newlines)
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
    
    func findIndex(in textView: UITextView) -> Int {
        if textView.text == "" { return 0 }
        if let selectedRange = textView.selectedTextRange {
            let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
            return cursorPosition
        }
        return 0
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
