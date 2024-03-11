//
//  NoteModelManager.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation

class NoteModelManager {
    var model : NoteModel?
    init(model: NoteModel? = nil) {
        self.model = model
    }
}

extension NoteModelManager: NoteModelManagerProtocol {
    func getData() -> Data? {
        return model?.data
    }
    
    func setData(data: Data) {
        self.model?.data = data
    }
    
    
}
