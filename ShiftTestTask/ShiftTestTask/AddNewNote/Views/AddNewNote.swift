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
        let strings = textView.findStrings(in: textView)
        guard let title = strings.title else { return }
        presenter.saveData(title: title, text: strings.text)
        textView.text = ""
    }
}

extension AddNewNote: PHPickerViewControllerDelegate {
    
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

extension AddNewNote: UITextViewDelegate {

    func setupFirstValue() {
        textView.delegate = self
        textView.becomeFirstResponder()
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
    
    @objc func addPhoto() {
        configureImagePicker()
    }
    
    @objc func correctTextStyle() {
        
    }
    
}



extension AddNewNote: AddNewNoteProtocol {
    
}
