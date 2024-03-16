//
//  NoteModel.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation
import UIKit

struct NoteModel {
    var id: UUID? = UUID()
    var text: NSAttributedString
}

extension NoteModel {
    static let firstNote = [NoteModel(id: UUID(), text: NSAttributedString(string: "Это первая заметка\nВы можете удалить её сами или она удалится автоматически", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]))]
}
