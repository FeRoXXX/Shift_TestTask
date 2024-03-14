//
//  NoteModelManager.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation
import UIKit
import CoreData

class NoteModelManager {
    var model: NoteModel?
    var modelArray: [NoteModel]?
    init(model: NoteModel? = nil) {
        self.model = model
    }
}

extension NoteModelManager {

    func getDataFromCoreData() -> [NoteModel]? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            modelArray = []
            for i in result {
                guard let text = i.text,
                      text.string != "" else { return nil}
                let note = NoteModel(id: i.id, text: text)
                modelArray?.append(note)
            }
            return modelArray
        } catch {
            //TODO: Error alert
            return nil
        }
    }
    
    func getCurrentNote(id: UUID) -> NoteModel? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(id)")
        
        do {
            let existingNote = try context.fetch(fetchRequest).first
            guard let existingNote = existingNote,
                  let text = existingNote.text else { return nil }
            return NoteModel(id: existingNote.id, text: text)
        } catch {
            //TODO: - Error Alert
            return nil
        }
    }
    
    func setNewDataToCoreData(id: UUID? = nil, text: NSAttributedString) {
        guard text.string != "" else { return }
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newData = Notes(context: context)
        if id == nil {
            newData.id = UUID()
        } else {
            newData.id = id
        }
        
        newData.text = text
        
        do {
            try context.save()
        } catch {
            //TODO: Error alert
        }
    }
    
    func correctDataInCoreData(data: NoteModel) {
        guard let id = data.id else { return }
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(id)")
        
        do {
            let existingNote = try context.fetch(fetchRequest).first
            
            if let existingNote = existingNote {
                existingNote.text = data.text
                
                do {
                    try context.save()
                } catch {
                    //TODO: Error alert
                }
            } else {
                setNewDataToCoreData(id: data.id, text: data.text)
            }
        } catch {
            //TODO: Error alert
        }
    }
    
    func deleteDataFromCoreData(id: UUID) -> Bool{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(id)")
        do {
            let existingNote = try context.fetch(fetchRequest).first
            
            if let existingNote = existingNote {
                context.delete(existingNote)
                
                do {
                    try context.save()
                    return true
                } catch {
                    //TODO: Error alert
                    return false
                }
            }
            return true
        } catch {
            //TODO: Error alert
            return false
        }
    }
}

extension NoteModelManager: NoteModelManagerProtocol {
    func getData() -> [NoteModel]? {
        return modelArray
    }
    
    func setData(data: NoteModel) {
        self.model = data
    }
    
}
