//
//  AddNewNoteProtocol.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation
import UIKit

protocol AddNewNoteProtocol: UIViewController {
    func clearTextView()
    func updateTextView(attributedText: NSAttributedString)
}
