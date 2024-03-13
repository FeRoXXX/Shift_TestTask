//
//  CurrentNote.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import UIKit

class CurrentNote: UIViewController {
    @IBOutlet weak var textView: UITextView!

    var presenter : CurrentNotePresenterProtocol!
    var id : UUID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        setupButtonToNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewLoaded(controller: self, view: self, id: id)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let strings = textView.findStrings(in: textView)
        if let title = strings.title,
           title != "" {
            presenter.viewDisappear(id: id, title: title, text: strings.text)
        } else {
            presenter.deleteNote(id: id)
        }
        clearTextView()
    }
    
}

extension CurrentNote: UITextViewDelegate {
    
    func setupTextView() {
        textView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.highlightingTitle(textView: textView)
    }
    
    func clearTextView() {
        textView.text = ""
    }
}

extension CurrentNote {
    
    func setupButtonToNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(deleteCurrentNote))
    }
    
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteCurrentNote() {
        presenter.deleteNote(id: id)
    }
    
}

extension CurrentNote: CurrentNoteProtocol {
    func putCurrentData(model: NoteModel? = nil) {
        guard let model = model else { return }
        let attributedString = NSMutableAttributedString()

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.black
        ]
        let titleAttributedString = NSAttributedString(string: model.title + "\n", attributes: titleAttributes)
        attributedString.append(titleAttributedString)

        if let text = model.text {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.darkGray
            ]
            let textAttributedString = NSAttributedString(string: text, attributes: textAttributes)
            attributedString.append(textAttributedString)
        }

        textView.attributedText = attributedString
    }
    
}
