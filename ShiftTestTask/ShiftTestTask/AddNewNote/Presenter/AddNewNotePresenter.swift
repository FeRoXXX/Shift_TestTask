//
//  AddNewNotePresenter.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation

class AddNewNotePresenter {
    private let model: NoteModelManagerProtocol
    private weak var controller: AddNewNote?
    private weak var view: AddNewNoteProtocol?
    
    init(model: NoteModelManagerProtocol) {
        self.model = model
    }
}

extension AddNewNotePresenter: AddNewNotePresenterProtocol {
    
}
