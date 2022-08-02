import UIKit
import Combine

class BaseViewController: UIViewController {
    let label = UITextView()

    var cancellables = Set<AnyCancellable>()
    
    lazy var subscribeButton = UIButton(type: .system,
                          primaryAction: UIAction(title: "Subscribe", handler: { [weak self] _ in
        self?.onSubscribeTapped()
    }))
    
    lazy var emitButton = UIButton(type: .system,
                          primaryAction: UIAction(title: "Emit", handler: { [weak self] _ in
        self?.onEmitTapped()
    }))
    
    lazy var cancelButton = UIButton(type: .system,
                          primaryAction: UIAction(title: "Cancel", handler: { [weak self] _ in
        self?.onCancelTapped()
    }))
    
    lazy var stackView = UIStackView(arrangedSubviews: [subscribeButton, emitButton, cancelButton])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isScrollEnabled = true
        label.isEditable = false
        label.isSelectable = false
        
        view.addSubview(stackView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: label.bottomAnchor)
        ])
    }
    
    func log(_ string: String) {
        label.text = label.text + "\n" + string + "\n"
        let location = label.text.count - 1
        let bottom = NSMakeRange(location, 1)
        label.scrollRangeToVisible(bottom)
    }
    
    func onSubscribeTapped() {}
    
    func onEmitTapped() {}
    
    func onCancelTapped() {
        self.cancellables.first?.cancel()
        self.cancellables.removeAll()
        self.log("Subscription cancelled")
    }
}
