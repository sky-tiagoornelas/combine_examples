import UIKit
import Combine

final class UsernameRemoteValidationViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    var inputSubject = CurrentValueSubject<String?, Never>(nil)

    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var input: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Username"
        return field
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.style = .large
        loader.hidesWhenStopped = true
        loader.startAnimating()
        return loader
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIValidation"
        view.backgroundColor = .systemBackground
        
        setupViews()
        setupActions()
    }
    
    private func setupViews() {
        view.addSubview(input)
        view.addSubview(resultLabel)
        view.addSubview(loader)
        
        NSLayoutConstraint.activate([
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            view.trailingAnchor.constraint(equalTo: resultLabel.trailingAnchor, constant: 8),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 32),
            
            input.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            input.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            view.trailingAnchor.constraint(equalTo: input.trailingAnchor, constant: 8),
            
            resultLabel.topAnchor.constraint(equalTo: loader.bottomAnchor,constant: 16),
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let usernamePublisher = inputSubject
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .flatMap { username in
                return Future<Bool, Never> { [weak self] promise in
                    self?.validateIfUserNameExists(username: username) { result in
                        if case let .success(isValid) = result {
                            promise(.success(isValid))
                        }
                    }
                }
            }
            .eraseToAnyPublisher()
           
        // Text subscription
        usernamePublisher
            .map { isValid in
                isValid ? "Username is valid" : "Username is invalid"
            }.assign(to: \.text, on: resultLabel)
            .store(in: &cancellables)
        
        // Text color subscription
        usernamePublisher
            .map { isValid in
                self.loader.stopAnimating()
                return isValid
            }
            .map { isValid in
                isValid ? UIColor.green : UIColor.red
            }.assign(to: \.textColor, on: resultLabel)
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        input.addAction(.init(handler: { [weak self] _ in
            self?.inputSubject.send(self?.input.text)
            self?.loader.startAnimating()
        }), for: .editingChanged)
    }
    
    private func validateIfUserNameExists(username: String?, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if username == "Bla" || username?.isEmpty ?? true {
                completion(.success(false))
            } else {
                completion(.success(true))
            }
        }
    }
}
