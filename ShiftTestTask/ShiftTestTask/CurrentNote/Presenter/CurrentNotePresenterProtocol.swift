//
//  CurrentNotePresenterProtocol.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation
import UIKit

protocol CurrentNotePresenterProtocol {
    func viewLoaded(controller: CurrentNote, view: CurrentNoteProtocol, id: UUID)
    func deleteNote(id: UUID)
    func viewDisappear(id: UUID, text: NSAttributedString)
}
