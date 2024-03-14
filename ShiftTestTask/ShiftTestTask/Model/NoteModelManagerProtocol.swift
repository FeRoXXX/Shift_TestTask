//
//  NoteModelProtocol.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation

protocol NoteModelManagerProtocol {
    func getData() -> [NoteModel]?
    func setData(data: NoteModel)
    func getDataFromCoreData() -> [NoteModel]?
    func getCurrentNote(id: UUID) -> NoteModel?
    func setNewDataToCoreData(id: UUID?, text: NSAttributedString)
    func correctDataInCoreData(data: NoteModel)
    func deleteDataFromCoreData(id: UUID) -> Bool
}
