//
//  AddNewNote.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import UIKit

class AddNewNote: UIViewController {

    var presenter: AddNewNotePresenterProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
extension AddNewNote: AddNewNoteProtocol {
    
}
