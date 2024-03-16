//
//  AddNewNotePresenterProtocol.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation
import UIKit
import PhotosUI

protocol AddNewNotePresenterProtocol {
    
    func viewLoaded(controller: AddNewNote, view: AddNewNoteProtocol)
    func saveData(text: NSAttributedString)
    func processingResultsFromPicker(results: [PHPickerResult], textView: UITextView)
    func makeBold(textView: UITextView)
    func viewDisappear()
    
}
