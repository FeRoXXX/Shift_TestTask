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
        let strings = textView.findStrings(in: textView)
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
        textView.highlightingTitle(textView: textView)
    }
    
}

extension AddNewNote: AddNewNoteProtocol {
    
}
