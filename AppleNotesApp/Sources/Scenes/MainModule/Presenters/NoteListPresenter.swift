import Foundation

// MARK: - Input Protocol

protocol NoteListPresenterInput: AnyObject {
    
    init(view: NoteListPresenterOutput, model: NoteModelInput, router: RouterProtocol)
    
    func getNotesCount() -> Int?
    func getNoteBy(index: Int) -> Note?
    func addNewNote(title: String?, bodyText: String?)
    func deleteNoteBy(index: Int)
    func showNoteDetailBy(index: Int)
    func showGalleryList()
    func showList()
}

// MARK: - Output Protocol

protocol NoteListPresenterOutput: AnyObject {
    func reloadData()
}

final class NoteListPresenter: NoteListPresenterInput {
    
    // MARK: - Properties
    
    private weak var view: NoteListPresenterOutput?
    private var model: NoteModelInput?
    private var router: RouterProtocol?
    
    // MARK: - Initialization
    
    init(view: NoteListPresenterOutput, model: NoteModelInput, router: RouterProtocol) {
        self.view = view
        self.model = model
        self.router = router
    }
    
    // MARK: - Presenter input functions
    
    func getNotesCount() -> Int? {
        guard let model = model else { return nil }
        return model.fetchAllNotes().count
    }
    
    func getNoteBy(index: Int) -> Note? {
        guard let note = model?.fetchAllNotes()[index] else { return nil }
        return note
    }
    
    func addNewNote(title: String?, bodyText: String?) {
        guard let newNote = model?.createNewNote(title: title, bodyText: bodyText) else { return }
        view?.reloadData()
        router?.makeDetailViewController(note: newNote)
    }
    
    func deleteNoteBy(index: Int) {
        guard let note = model?.fetchAllNotes()[index] else { return }
        model?.deleteNote(note: note)
        view?.reloadData()
    }
    
    func showNoteDetailBy(index: Int) {
        guard let note = model?.fetchAllNotes()[index] else { return }
        router?.makeDetailViewController(note: note)
    }
    
    func showGalleryList() {
        router?.makeAdditionalController()
    }
    
    func showList() {
        router?.makeInitialViewController()
    }
}
