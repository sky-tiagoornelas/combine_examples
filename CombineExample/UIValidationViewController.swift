import UIKit
import Combine

final class UIValidationViewController: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    
    var input1Subject = CurrentValueSubject<String?, Never>(nil)
    var input2Subject = CurrentValueSubject<String?, Never>(nil)

    private lazy var header: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var input1: UITextField = {
        let field = UITextField()
        field.placeholder = "Username"
        return field
    }()
    
    private lazy var input2: UITextField = {
        let field = UITextField()
        field.placeholder = "Zip Code"
        return field
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [input1, input2])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Proceed", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIValidation"
        view.backgroundColor = .systemBackground
        
        setupViews()
        setupActions()
                
        Publishers.CombineLatest(input1Subject, input2Subject)
            .receive(on: DispatchQueue.main)
            .map {
                guard let username = $0, let zipCode = $1 else {
                    return false
                }
                
                if username.isEmpty { return false }
                
                if zipCode.isEmpty { return false }
                
                return zipCode.allSatisfy { $0.isNumber }
            }
            .assign(to: \.isEnabled, on: button)
            .store(in: &cancellables)
        
        input1Subject
            .receive(on: DispatchQueue.main)
            .map { "Welcome \($0 ?? "")!" }
            .assign(to: \.text, on: header)
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        input1.addAction(.init(handler: { [weak self] _ in
            self?.input1Subject.send(self?.input1.text)
        }), for: .editingChanged)
        
        input2.addAction(.init(handler: { [weak self] _ in
            self?.input2Subject.send(self?.input2.text)
        }), for: .editingChanged)
    }
}

extension UIValidationViewController {
    private func setupViews() {
        view.addSubview(header)
        view.addSubview(stackView)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            view.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: 8),
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 8),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 16),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 16),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
