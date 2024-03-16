//
//  CurrentNotePresenter.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation
import UIKit
import PhotosUI

class CurrentNotePresenter {
    private let model : NoteModelManagerProtocol
    weak var controller: CurrentNote?
    weak var view: CurrentNoteProtocol?
    
    init(model: NoteModelManagerProtocol) {
        self.model = model
    }
}
extension CurrentNotePresenter: CurrentNotePresenterProtocol {
    
    func viewLoaded(controller: CurrentNote, view: CurrentNoteProtocol, id: UUID) {
        self.controller = controller
        self.view = view
        
        let firstNoteUUID = UserDefaults().value(forKey: "savedUUID") as? String
        
        if let firstNoteUUID = firstNoteUUID,
           id == UUID(uuidString: firstNoteUUID)  {
            view.putCurrentData(model: model.getFirstNote())
        } else {
            view.putCurrentData(model: model.getCurrentNote(id: id))
        }
    }
    
    func deleteNote(id: UUID) {
        if model.deleteDataFromCoreData(id: id) {
            view?.clearTextView()
            view?.popBack()
        }
    }
    
    func viewDisappear(id: UUID, text: NSAttributedString) {
        model.correctDataInCoreData(data: NoteModel(id: id, text: text))
        view?.clearTextView()
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
