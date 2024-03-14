//
//  AddNewNotePresenterProtocol.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation
import UIKit

protocol AddNewNotePresenterProtocol {
    
    func viewLoaded(controller: AddNewNote, view: AddNewNoteProtocol)
    func saveData(text: NSAttributedString)
    
}
