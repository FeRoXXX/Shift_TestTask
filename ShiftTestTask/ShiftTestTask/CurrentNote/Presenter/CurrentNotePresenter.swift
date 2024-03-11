//
//  CurrentNotePresenter.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation

class CurrentNotePresenter {
    private let model : NoteModelManagerProtocol
    weak var controller: CurrentNote?
    weak var view: CurrentNoteProtocol?
    
    init(model: NoteModelManagerProtocol) {
        self.model = model
    }
}
extension CurrentNotePresenter: CurrentNotePresenterProtocol {
    
}
