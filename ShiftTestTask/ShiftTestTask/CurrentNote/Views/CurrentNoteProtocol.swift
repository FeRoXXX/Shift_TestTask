//
//  CurrentNoteProtocol.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation
import UIKit

protocol CurrentNoteProtocol: UIViewController {
    func putCurrentData(model: NoteModel?)
    func popBack()
}
