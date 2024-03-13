//
//  AddNewNotePresenter.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation
import UIKit

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
    
    func saveData(title: String, text: String?) {
        model.setNewDataToCoreData(title: title, text: text)
    }
    
    func findStrings(in textView: UITextView) -> (title: String?, text: String?) {
        guard let textView = textView.text else {
            return (nil, nil)
        }
        
        let lines = textView.components(separatedBy: CharacterSet.newlines)
        var title: String?
        var text: String?
        
        for (index, line) in lines.enumerated() {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedLine.isEmpty {
                if title == nil {
                    title = trimmedLine
                } else {
                    if text == nil {
                        text = trimmedLine
                    } else {
                        text! += "\n" + trimmedLine
                    }
                }
            }
        }
        
        return (title, text)
    }
    
}
