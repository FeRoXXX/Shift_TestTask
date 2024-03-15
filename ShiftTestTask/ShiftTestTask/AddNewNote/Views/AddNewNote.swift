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
                    DispatchQueue.main.async {
                        guard let image = image as? UIImage,
                              let scaledImage = image.resized(toWidth: self.textView.frame.size.width),
                              let encodedImageString = scaledImage.pngData()?.base64EncodedString(),
                              let attributedString = NSAttributedString(base64EndodedImageString: encodedImageString) else { return }
                        let attributedText = NSMutableAttributedString(attributedString: self.textView.attributedText)
                        attributedText.append(attributedString)
                        self.textView.attributedText = attributedText
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
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        let addPhoto = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .done, target: self, action: #selector(addPhoto))
        let correctTextStyle = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(correctTextStyle))
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
    
    @objc func correctTextStyle() {
        
    }
    
}



extension AddNewNote: AddNewNoteProtocol {
    
}
