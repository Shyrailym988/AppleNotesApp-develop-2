import Foundation

// MARK: - Input Protocol

protocol DetailNotePresenterInput: AnyObject {
    
    init(view: DetailNotePresenterOutput, model: NoteModelInput, router: RouterProtocol)
    
    func showNote(_ note: Note)
    func updateNoteWith(note: Note, title: String?, bodyText: String?)
    func deleteNote(_ note: Note)
    func returnToMainView()
}

// MARK: - Output Protocol

protocol DetailNotePresenterOutput: AnyObject {
    func showInformationFor(note: Note)
}

final class DetailNotePresenter: DetailNotePresenterInput {
    
    // MARK: - Properties
    
    private weak var view: DetailNotePresenterOutput?
    private var model: NoteModelInput?
    private var router: RouterProtocol?
    
    init(view: DetailNotePresenterOutput, model: NoteModelInput, router: RouterProtocol) {
        self.view = view
        self.model = model
        self.router = router
    }
    
    func showNote(_ note: Note) {
        view?.showInformationFor(note: note)
    }
    
    func updateNoteWith(note: Note, title: String?, bodyText: String?) {
        model?.updateNote(note: note, title: title, bodyText: bodyText)
    }
    
    func deleteNote(_ note: Note) {
        model?.deleteNote(note: note)
    }
    
    func returnToMainView() {
        router?.popToRoot()
    }
}
