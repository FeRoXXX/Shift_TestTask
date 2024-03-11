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
    
    private func onClickedCell() {
        guard let view = view else { return }
        
    }
    
    private func onClickedAddNote() {
        self.router.toAddNote()
    }
    
    private func onClickedCurrentCell() {
        self.router.toCurrentCell()
    }
    
    private func setHandlers() {
        self.view?.goToNote = { [weak self] in
            self?.onClickedCurrentCell()
        }
        
        self.view?.goToAddNote = { [weak self] in
            self?.onClickedAddNote()
        }
    }
}
extension ListOfNotesPresenter: ListOfNotesPresenterProtocol {
    func loadView(controller: ListOfNotes, view: ListOfNotesProtocol) {
        self.controller = controller
        self.view = view
        
        self.setHandlers()
    }
}
