//
//  ListOfNotesPresenter.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation

final class ListOfNotesPresenter {
    private var model: NoteModelManagerProtocol
    private let router: Router
    private weak var controller: ListOfNotes?
    private weak var view: ListOfNotesProtocol?
    
    init(model: NoteModelManagerProtocol, router: Router) {
        self.model = model
        self.router = router
    }
}

private extension ListOfNotesPresenter {
    
    private func onClickedAddNote() {
        self.router.toAddNote()
    }
    
    private func onClickedCurrentCell(_ id: UUID) {
        self.router.toCurrentCell(id)
    }
    
    private func setHandlers() {
        self.view?.goToNote = { [weak self] id in
            self?.onClickedCurrentCell(id)
        }
        
        self.view?.goToAddNote = { [weak self] in
            self?.onClickedAddNote()
        }
    }
    
    private func updateTable() {
        view?.updateTableData(data: model.getDataFromCoreData())
    }
}
extension ListOfNotesPresenter: ListOfNotesPresenterProtocol {
    func loadView(controller: ListOfNotes, view: ListOfNotesProtocol) {
        self.controller = controller
        self.view = view
        let firstNote = model.getFirstNote()
        if let firstNote = firstNote {
            UserDefaults().setValue(firstNote.id?.uuidString, forKey: "savedUUID")
        }
        self.setHandlers()
        if UserDefaults().bool(forKey: "NoFirstOpen") {
            updateTable()
        } else {
            view.updateTableData(data: NoteModel.firstNote)
            UserDefaults().setValue(true, forKey: "NoFirstOpen")
        }
    }
    
    func viewOpen() {
        updateTable()
    }
    
}
