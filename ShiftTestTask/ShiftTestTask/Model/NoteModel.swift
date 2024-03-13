//
//  NoteModel.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation

struct NoteModel {
    var id: UUID? = UUID()
    var title: String
    var text: String?
}

extension NoteModel {
    static let firstNote = [NoteModel(id: UUID(), title: "Это первая заметка", text: "Вы можете удалить её сами или она удалится автоматически")]
}
