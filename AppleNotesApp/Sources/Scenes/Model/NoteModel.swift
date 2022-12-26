import UIKit
import CoreData

// MARK: - Input Protocol

protocol NoteModelInput {
    func fetchAllNotes() -> [Note]
    func createNewNote(title: String?, bodyText: String?) -> Note
    func updateNote(note: Note, title: String?, bodyText: String?)
    func deleteNote(note: Note)
}

final class NoteModel: NoteModelInput {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchAllNotes() -> [Note] {
        
        var noteModel = [Note]()
        do {
            noteModel = try context.fetch(Note.fetchRequest())
        }
        catch {
            print("Core Data Error: \(error)")
        }
        
        return noteModel
    }
    
    func createNewNote(title: String?, bodyText: String?) -> Note {
        
        let newNote = Note(context: context)
        newNote.title = title
        newNote.bodyText = bodyText
        newNote.date = Date()

        do {
            try context.save()
        }
        catch {
            print("Core Data Error: \(error)")
        }
        
        return newNote
    }
    
    func updateNote(note: Note, title: String?, bodyText: String?) {
        note.title = title!.isEmpty ? "Без названия" : title
        note.bodyText = bodyText!.isEmpty ? "Нет описания" : bodyText
        note.date = Date()
        
        do {
            try context.save()
        } catch {
            print("Core Data Error: \(error)")
        }
    }
    
    func deleteNote(note: Note) {
        context.delete(note)
        do {
            try context.save()
        } catch {
            print("Core Data Error: \(error)")
        }
    }   
}
