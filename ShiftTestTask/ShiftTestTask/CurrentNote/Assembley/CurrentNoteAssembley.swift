//
//  CurrentNoteAssembley.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation
import UIKit

final class CurrentNoteAssembley{
    static func build() -> UIViewController {
        let model = NoteModelManager()
        let presenter = CurrentNotePresenter(model: model)
        let controller = CurrentNote()
        controller.presenter = presenter
        return controller
    }
}
