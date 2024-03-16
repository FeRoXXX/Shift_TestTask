//
//  CurrentNote.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import UIKit
import PhotosUI

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
        if textView.text != "" {
            presenter.viewDisappear(id: id, text: textView.attributedText)
        } else {
            presenter.deleteNote(id: id)
        }
    }
    
}

extension CurrentNote {
    
    func setupButtonToNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(deleteCurrentNote))
    }
    
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupMenu() -> UIMenu {
        let correctFontBold = UIAction(title: "Сделать жирным") { _ in
            self.makeBold()
        }
        let menu = UIMenu(options: .displayInline, children: [correctFontBold])
        return menu
    }
    
    @objc func deleteCurrentNote() {
        textView.text = ""
        presenter.deleteNote(id: id)
    }
    
    @objc func makeBold() {
        presenter.makeBold(textView: textView)
    }
    
}

extension CurrentNote: UITextViewDelegate {
    
    func setupTextView() {
        textView.delegate = self
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        let addPhoto = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .done, target: self, action: #selector(addPhoto))
        let menu = setupMenu()
        let correctTextStyle = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), primaryAction: nil, menu: menu)
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = view.bounds.width - addPhoto.width - correctTextStyle.width
        bar.items = [addPhoto, fixedSpace, correctTextStyle]
        
        textView.inputAccessoryView = bar
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.highlightingTitle()
    }
    
    @objc func addPhoto() {
        configureImagePicker()
    }
}

extension CurrentNote: PHPickerViewControllerDelegate {
    
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

extension CurrentNote: CurrentNoteProtocol {
    func putCurrentData(model: NoteModel? = nil) {
        guard let model = model else { return }

        textView.attributedText = model.text
    }
    
    func updateTextView(attributedText: NSAttributedString) {
        textView.moveCursor()
        textView.attributedText = attributedText
        textView.moveCursor()
    }
    
    func clearTextView() {
        textView.text = ""
    }
}
