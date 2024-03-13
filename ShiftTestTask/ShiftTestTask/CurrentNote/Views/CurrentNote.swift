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

extension CurrentNote {
    
    func setupButtonToNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(deleteCurrentNote))
    }
    
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteCurrentNote() {
        textView.text = ""
        presenter.deleteNote(id: id)
    }
    
}

extension CurrentNote: UITextViewDelegate {
    
    func setupTextView() {
        textView.delegate = self
        let bar = UIToolbar()
        let addPhoto = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .done, target: self, action: #selector(addPhoto))
        let correctTextStyle = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(correctTextStyle))
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = view.bounds.width - addPhoto.width - correctTextStyle.width
        bar.items = [addPhoto, fixedSpace, correctTextStyle]
        bar.sizeToFit()
        textView.inputAccessoryView = bar
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.highlightingTitle(textView: textView)
    }
    
    func clearTextView() {
        textView.text = ""
    }
    
    @objc func addPhoto() {
        configureImagePicker()
    }
    
    @objc func correctTextStyle() {
        
    }
}

extension CurrentNote: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let item = results.first?.itemProvider {
            if item.canLoadObject(ofClass: UIImage.self){
                item.loadObject(ofClass: UIImage.self) { image, error in
                    if let error {
                        print(error.localizedDescription)
                    }
                    if let image = image as? UIImage {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            let attachment = NSTextAttachment()
                            attachment.image = image

                            let imageSize = image.size
                            let screenWidth = UIScreen.main.bounds.width
                            let scale = screenWidth / imageSize.width
                            let scaledSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
                            attachment.bounds = CGRect(origin: .zero, size: scaledSize)

                            let imageString = NSAttributedString(attachment: attachment)
                            self.textView.textStorage.insert(imageString, at: self.textView.findIndex(in: self.textView))
                        }
                    }
                }
            }
        }
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
