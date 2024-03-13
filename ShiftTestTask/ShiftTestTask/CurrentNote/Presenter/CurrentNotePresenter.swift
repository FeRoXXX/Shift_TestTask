//
//  CurrentNotePresenter.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation
import UIKit

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
        
        controller.putCurrentData(model: model.getCurrentNote(id: id))
    }
    
    func deleteNote(id: UUID) {
        if model.deleteDataFromCoreData(id: id) {
            controller?.popBack()
        }
    }
    
    func viewDisappear(id: UUID, title: String, text: String?) {
        model.correctDataInCoreData(data: NoteModel(id: id, title: title, text: text))
    }
    
}
