import UIKit

class NotesCollectionListVC: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: NoteListPresenterInput?
    
    // MARK: - Outlets
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGroupedBackground
        
        collectionView.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: NoteCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self

        return collectionView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
    
        searchController.searchBar.placeholder = "Поиск..."
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.barTintColor = .systemGroupedBackground
        searchController.searchBar.tintColor = .label
        
        return searchController
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
        setupToolBar()
        setupView()
        setupHierarchy()
        setupLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    // MARK: - Setup
    
    private func setupNavigationController() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Заметки"
        let imageForNavigationItem = UIImage(systemName: "list.bullet")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageForNavigationItem,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(showList))
        navigationItem.rightBarButtonItem?.tintColor = .systemYellow
        navigationItem.searchController = searchController
    }
    
    private func setupToolBar() {
        
        navigationController?.setToolbarHidden(false, animated: false)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                     target: self,
                                     action: nil)
        let newNoteTool = UIBarButtonItem(barButtonSystemItem: .compose,
                                          target: self,
                                          action: #selector(createNewNote))
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        label.textAlignment = .center
        label.text = presenter?.getNotesCount()?.showCountNote()
        let noteCount = UIBarButtonItem(customView: label)
        
        toolbarItems = [spacer, noteCount, spacer, newNoteTool]
        navigationController?.toolbar.tintColor = .systemYellow
    }
    
    private func setupView() {
        view.backgroundColor = .systemGroupedBackground
    }
    
    private func setupHierarchy() {
        view.addSubview(collectionView)
    }
        
    private func setupLayouts() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: - Objc functions
    
    @objc func createNewNote() {
        presenter?.addNewNote(title: "", bodyText: "")
    }
    
    @objc func showList() {
        presenter?.showList()
    }
}

// MARK: - Extensions

extension NotesCollectionListVC {
    func setupPresenter(presenter: NoteListPresenterInput) {
        self.presenter = presenter
    }
}

extension NotesCollectionListVC: NoteListPresenterOutput {
    
    func reloadData() {
        collectionView.reloadData()
        setupToolBar()
    }
}

extension NotesCollectionListVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let counNote = presenter?.getNotesCount() else { return 0 }
        
        return counNote
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.identifier,
                                                       for: indexPath) as! NoteCollectionViewCell
        
        let note = presenter?.getNoteBy(index: indexPath.row)
        cell.configureCell(with: note)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width / 3) - 20, height: (view.frame.size.height / 6) )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        presenter?.showNoteDetailBy(index: indexPath.row)
    }
}
