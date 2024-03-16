//
//  AddNewNote.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import UIKit
import PhotosUI

class AddNewNote: UIViewController {
    @IBOutlet weak var textView: UITextView!

    var presenter: AddNewNotePresenterProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstValue()
        presenter.viewLoaded(controller: self, view: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        guard textView.text != "" else { return }
        presenter.saveData(text: textView.attributedText)
    }
}

extension AddNewNote: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        presenter.processingResultsFromPicker(results: results, textView: textView)
    }
    
    func configureImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    
}

extension AddNewNote: UITextViewDelegate {

    func setupFirstValue() {
        textView.delegate = self
        textView.becomeFirstResponder()
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        let addPhoto = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .done, target: self, action: #selector(addPhoto))
        let menu = setupMenu()
        let correctTextStyle = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), primaryAction: nil, menu: menu)
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = view.bounds.width - addPhoto.width - correctTextStyle.width
        bar.items = [addPhoto, fixedSpace, correctTextStyle]
        textView.inputAccessoryView = bar
    }
    
    func setupMenu() -> UIMenu {
        let correctFontBold = UIAction(title: "Сделать жирным") { _ in
            self.makeBold()
        }
        let menu = UIMenu(options: .displayInline, children: [correctFontBold])
        return menu
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.textView.highlightingTitle()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.textView.highlightingTitle()
        return true
    }
    
    @objc func addPhoto() {
        configureImagePicker()
    }
    
    @objc func makeBold() {
        presenter.makeBold(textView: textView)
    }
    
}



extension AddNewNote: AddNewNoteProtocol {
    
    func clearTextView() {
        textView.text = ""
    }
    
    func updateTextView(attributedText: NSAttributedString) {
        textView.moveCursor()
        textView.attributedText = attributedText
        textView.moveCursor()
    }
    
}
