//
//  ListOfNotesPresenterProtocol.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation

protocol ListOfNotesPresenterProtocol {
    func loadView(controller: ListOfNotes, view: ListOfNotesProtocol)
    func viewOpen()
}
