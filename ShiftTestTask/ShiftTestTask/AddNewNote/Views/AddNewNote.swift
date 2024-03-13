//
//  AddNewNote.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import UIKit

class AddNewNote: UIViewController {
    @IBOutlet weak var textView: UITextView!

    var presenter: AddNewNotePresenterProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstValue()
        presenter.viewLoaded(controller: self, view: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let strings = presenter.findStrings(in: textView)
        guard let title = strings.title else { return }
        presenter.saveData(title: title, text: strings.text)
        textView.text = ""
    }
}

extension AddNewNote: UITextViewDelegate {

    func setupFirstValue() {
        textView.delegate = self
        textView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
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
    
}

extension AddNewNote: AddNewNoteProtocol {
    
}
