import UIKit

class DetailNoteVC: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: DetailNotePresenterInput?
    private var note: Note?

    // MARK: - Outlets
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private lazy var scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        
        return view
    }()
    
    private lazy var titleText = createTextViewWith(font: .boldSystemFont(ofSize: 32))
    private lazy var bodyText = createTextViewWith(font: .systemFont(ofSize: 17))

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupHierarchy()
        setupLayouts()
        setupKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
        setupToolBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            if titleText.text.isEmpty && bodyText.text.isEmpty {
                presenter?.deleteNote(note!)
            } else {
                presenter?.updateNoteWith(note: note!, title: titleText.text, bodyText: bodyText.text)
            }
        }
    }
    
    // MARK: - Setup
    
    func setupPresenter(presenter: DetailNotePresenterInput) {
        self.presenter = presenter
    }
    
    private func setupNavigationController() {

        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .systemYellow
    }
    
    private func setupToolBar() {
        
        navigationController?.setToolbarHidden(false, animated: false)

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                     target: self,
                                     action: nil)
        let checklistTool = UIBarButtonItem(image: UIImage(systemName: "checklist"))
        let cameraTool = UIBarButtonItem(image: UIImage(systemName: "camera"))
        let pencilTool = UIBarButtonItem(image: UIImage(systemName: "pencil.tip.crop.circle"))
        let newNoteTool = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"))
        
        toolbarItems = [checklistTool, spacer, cameraTool, spacer, pencilTool, spacer,newNoteTool]
        navigationController?.toolbar.tintColor = .systemYellow
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        scrollStackViewContainer.addArrangedSubview(titleText)
        scrollStackViewContainer.addArrangedSubview(bodyText)
    }
        
    private func setupLayouts() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        
        scrollStackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor).isActive = true
        scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor).isActive = true
        scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
    }
    
    // MARK: - Keyboard setup
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissKeyboard))
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        navigationItem.rightBarButtonItem = nil
    }
    
    private func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // MARK: - Functions for create UI
    
    func createTextViewWith(font: UIFont) -> UITextView {
        let textView = UITextView()
        textView.font = font
        textView.textColor = .label
        textView.textAlignment = .left
        
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.isScrollEnabled = false
        
        textView.delegate = self
        
        return textView
    }
}

// MARK: - Extensions

extension DetailNoteVC: DetailNotePresenterOutput {
    func showInformationFor(note: Note) {
        self.note = note
        titleText.text = note.title
        bodyText.text = note.bodyText
    }
}

extension DetailNoteVC: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}

