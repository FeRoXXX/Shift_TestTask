//
//  CurrentNote.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import UIKit

class CurrentNote: UIViewController {

    var presenter : CurrentNotePresenterProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
extension CurrentNote: CurrentNoteProtocol {
    
}
