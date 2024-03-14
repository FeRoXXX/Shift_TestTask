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
    
    func saveData(text: NSAttributedString) {
        model.setNewDataToCoreData(id: nil, text: text)
    }
    
}
