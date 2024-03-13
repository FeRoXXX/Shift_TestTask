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
        
        for (index, line) in lines.enumerated() {
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
