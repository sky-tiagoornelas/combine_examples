import Combine
import UIKit

final class StoreExampleViewController: UIViewController {
    
    private let viewModel = StoreExampleViewModelImpl()
    
    private lazy var input: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Enter a name"
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 8
        return field
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.style = .large
        loader.hidesWhenStopped = true
        return loader
    }()
    
    private lazy var results: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var saveButton = UIButton(type: .system,
                          primaryAction: UIAction(title: "Save", handler: { [weak self] _ in
        self?.onSaveTapped()
    }))
    
    private lazy var deleteButton = UIButton(type: .system,
                          primaryAction: UIAction(title: "Delete", handler: { [weak self] _ in
        self?.onDeleteTapped()
    }))
    
    private lazy var buttonsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [saveButton, deleteButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Store Example"
        view.backgroundColor = .systemBackground
        
        setupViews()
        
        viewModel.delegate = self
        viewModel.fetchNames()
    }
    
    private func setupViews() {
        view.addSubview(input)
        view.addSubview(loader)
        view.addSubview(results)
        view.addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            input.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            input.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            view.trailingAnchor.constraint(equalTo: input.trailingAnchor, constant: 32),
            input.heightAnchor.constraint(equalToConstant: 40),
            
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            results.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            results.topAnchor.constraint(equalTo: input.bottomAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: results.trailingAnchor, constant: 8),
            buttonsStack.topAnchor.constraint(greaterThanOrEqualTo: results.bottomAnchor, constant: 8),
            
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: buttonsStack.trailingAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: 16)
        ])
    }
    
    func onSaveTapped() {
        if let text = input.text, !text.isEmpty {
            viewModel.saveName(name: text)
            input.text = ""
        }
    }
    
    func onDeleteTapped() {
        
    }
}

extension StoreExampleViewController: StoreExampleViewModelDeletage {
    func onErrorSaving() {
        // TODO
    }
    
    func onNames(names: [String]) {
        DispatchQueue.main.async {
            self.results.text = names.map {
                String($0)
            }.joined(separator: ",")
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.loader.startAnimating()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.loader.stopAnimating()
        }
    }
}
