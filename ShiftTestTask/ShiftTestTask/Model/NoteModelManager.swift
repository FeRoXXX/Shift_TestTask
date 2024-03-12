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
                guard let title = i.title else { return nil}
                let note = NoteModel(id: i.id, title: title, text: i.text)
                modelArray?.append(note)
            }
            return modelArray
        } catch {
            //TODO: Error alert
            return nil
        }
    }
    
    func setNewDataToCoreData(data: NoteModel) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newData = Notes()
        newData.id = UUID()
        newData.title = data.title
        if let text = data.text {
            newData.text = text
        }
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
                existingNote.title = data.title
                if let text = data.text {
                    existingNote.text = text
                }
                
                do {
                    try context.save()
                } catch {
                    //TODO: Error alert
                }
            }
        } catch {
            //TODO: Error alert
        }
    }
    
    func deleteDataFromCoreData(id: UUID) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(id)")
        
        do {
            let existingNote = try context.fetch(fetchRequest).first
            
            if let existingNote = existingNote {
                context.delete(existingNote)
                
                do {
                    try context.save()
                } catch {
                    //TODO: Error alert
                }
            }
        } catch {
            //TODO: Error alert
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
