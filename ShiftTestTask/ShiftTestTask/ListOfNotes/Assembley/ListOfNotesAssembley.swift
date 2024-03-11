//
//  ListOfNotesAssembley.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation
import UIKit

final class ListOfNotesAssembley {
    static func build() -> UIViewController {
        let model = NoteModelManager()
        let router = Router()
        
        let presenter = ListOfNotesPresenter(model: model, router: router)
        let controller = ListOfNotes()
        controller.presenter = presenter
        
        let targetControllerFirst = AddNewNoteAssembley.build()
        let targetControllerSecond = CurrentNoteAssembley.build()
        
        router.setRootController(controller: controller)
        router.setTargetControllers(targetControllerFirst: targetControllerFirst, targetControllerSecond: targetControllerSecond)
        
        return controller
    }
}
