import UIKit

class NoteCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Configuration
    
    static let identifier = "FlowLayoutCell"
    
    // MARK: - Outlets
    
    private lazy var noteView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightText
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    private lazy var titleLabel = createLabel(font: .systemFont(ofSize: 16), textColor: .label)
    private lazy var dateLabel = createLabel(font: .systemFont(ofSize: 12), textColor: .secondaryLabel)
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 2
        
        return stack
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
        setupHierarchy()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupCell() {
        backgroundColor = .systemGroupedBackground
    }
    
    private func setupHierarchy() {
        addSubview(mainStack)
        mainStack.addArrangedSubview(noteView)
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(dateLabel)
    }
        
    private func setupLayouts() {
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        noteView.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: 0.6).isActive = true
    }
    
    // MARK: - Configuration

    func configureCell(with note: Note?) {
        guard let note = note else { return }
        
        titleLabel.text = note.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        
        dateLabel.text = dateFormatter.string(from: note.date ?? Date())
    }
    
    // MARK: - Private functions for create UI
    
    private func createLabel(font: UIFont, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }
}
