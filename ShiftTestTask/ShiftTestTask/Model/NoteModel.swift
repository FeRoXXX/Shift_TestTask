//
//  NoteModel.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation

struct NoteModel {
    var id: UUID? = UUID()
    var text: NSAttributedString
}

extension NoteModel {
    static let firstNote = [NoteModel(id: UUID(), text: NSAttributedString(string: "Это первая заметка\n Вы можете удалить её сами или она удалится автоматически"))]
}
