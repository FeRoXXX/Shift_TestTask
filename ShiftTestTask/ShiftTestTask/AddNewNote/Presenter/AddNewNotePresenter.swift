//
//  AddNewNotePresenter.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation
import UIKit
import PhotosUI

class AddNewNotePresenter {
    private let model: NoteModelManagerProtocol
    private weak var controller: AddNewNote?
    private weak var view: AddNewNoteProtocol?
    
    init(model: NoteModelManagerProtocol) {
        self.model = model
    }
}

extension AddNewNotePresenter: AddNewNotePresenterProtocol {
    
    func viewLoaded(controller: AddNewNote, view: AddNewNoteProtocol) {
        
        self.controller = controller
        self.view = view
        
    }
    
    func saveData(text: NSAttributedString) {
        model.setNewDataToCoreData(id: nil, text: text)
    }
    
    func processingResultsFromPicker(results: [PHPickerResult], textView: UITextView) {
        results.imageProcessing { [weak self] image in
            DispatchQueue.main.async {
                guard let image = image,
                      let scaledImage = image.resized(toWidth: textView.frame.size.width),
                      let encodedImageString = scaledImage.pngData()?.base64EncodedString(),
                      let attributedString = NSAttributedString(base64EndodedImageString: encodedImageString) else { return }
                let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
                attributedText.append(attributedString)
                self?.view?.updateTextView(attributedText: attributedText)
            }
        }
    }
    
    func makeBold(textView: UITextView) {
        let currentLineRange = textView.findCurrentStringRange()
        guard let currentLineRange = currentLineRange else { return }
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        if textView.isBold() {
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18), range: currentLineRange)
        } else {
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: currentLineRange)
        }
        textView.attributedText = attributedString
    }
    
}
