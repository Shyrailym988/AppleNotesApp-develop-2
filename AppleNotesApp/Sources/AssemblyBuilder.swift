import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createAdditionalModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(note: Note?, router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = NotesListVC()
        let model = NoteModel()
        let presenter = NoteListPresenter(view: view, model: model, router: router)
        view.setupPresenter(presenter: presenter)
        
        return view
    }
    
    func createAdditionalModule(router: RouterProtocol) -> UIViewController {
        let view = NotesCollectionListVC()
        let model = NoteModel()
        let presenter = NoteListPresenter(view: view, model: model, router: router)
        view.setupPresenter(presenter: presenter)
        
        return view
    }
    
    func createDetailModule(note: Note?, router: RouterProtocol) -> UIViewController {
        let view = DetailNoteVC()
        let model = NoteModel()
        let presenter = DetailNotePresenter(view: view, model: model, router: router)
        view.setupPresenter(presenter: presenter)
        presenter.showNote(note ?? Note())
        
        return view
    }
}
