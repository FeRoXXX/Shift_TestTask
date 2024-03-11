//
//  NoteModelProtocol.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation

protocol NoteModelManagerProtocol {
    func getData() -> Data?
    func setData(data: Data)
}
