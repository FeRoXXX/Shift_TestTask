//
//  AddNewNoteAssembley.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation
import UIKit

class AddNewNoteAssembley {
    static func build() -> UIViewController {
        let model = NoteModelManager()
        let presenter = AddNewNotePresenter(model: model)
        let controller = AddNewNote()
        controller.presenter = presenter
        
        return controller
    }
}
