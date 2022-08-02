import UIKit

class ViewController: UIViewController {

    var options: [Screen] = [
        .future,
        .deferred,
        .customNotification,
        .backgroundForegroundNotification,
        .publisherOperators,
        .uiValidation,
        .uiRemoteValidation,
        .storeExample
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Combine examples"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row].rawValue
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: UIViewController?
        
        switch options[indexPath.row]{
        case .future:
            vc = FutureViewController()
        case .deferred:
            vc = DeferredWithFutureViewController()
        case .customNotification:
            vc = CustomNotificationViewController()
        case .backgroundForegroundNotification:
            vc = BackgroundForegroundViewController()
        case .publisherOperators:
            vc = PublisherOperatorsViewController()
        case .uiValidation:
            vc = UIValidationViewController()
        case .uiRemoteValidation:
            vc = UsernameRemoteValidationViewController()
        case .storeExample:
            vc = StoreExampleViewController()
        }
        
        if let vc = vc {
            navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

enum Screen: String {
    case future = "Future"
    case deferred = "Deferred"
    case customNotification = "Custom Notification"
    case backgroundForegroundNotification = "Background Foreground Notification"
    case publisherOperators = "Publisher Operators"
    case uiValidation = "UI Validation"
    case uiRemoteValidation = "UI Remote Validation"
    case storeExample = "Store Example"
}
