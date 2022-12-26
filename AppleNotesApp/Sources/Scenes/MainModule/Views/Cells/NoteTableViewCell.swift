import UIKit

class NoteTableViewCell: UITableViewCell {
        
    static let identifier = "NoteTableViewCell"
    
    // MARK: - Outlets
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 2
        
        return stack
    }()
    
    lazy var titleLabel = createLabel(font: .boldSystemFont(ofSize: 17), textColor: .label)
    lazy var bodyLabel = createLabel(font: .systemFont(ofSize: 16), textColor: .secondaryLabel)
    lazy var dateLabel = createLabel(font: .systemFont(ofSize: 16), textColor: .secondaryLabel)

    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
        setupHierarchy()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .secondarySystemGroupedBackground
    }
    
    private func setupHierarchy() {
        addSubview(mainStack)
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(bodyLabel)
        mainStack.addArrangedSubview(dateLabel)
    }
        
    private func setupLayouts() {
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
    }

    // MARK: - Configuration

    func configureCell(with note: Note?) {
        guard let note = note else { return }
        
        titleLabel.text = note.title
        bodyLabel.text = note.bodyText
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        
        dateLabel.text = dateFormatter.string(from: note.date ?? Date())
    }
    
    // MARK: - Private functions for create UI
    
    private func createLabel(font: UIFont, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }
}
