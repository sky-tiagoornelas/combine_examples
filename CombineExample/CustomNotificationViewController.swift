import UIKit
import Combine

final class CustomNotificationViewController: BaseViewController {

    lazy var publisher: NotificationCenter.Publisher = {
        return NotificationCenter.default.publisher(for: .myNotification, object: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Custom NSNotification"
    }
    
    override func onSubscribeTapped() {
        guard cancellables.isEmpty else {
            log("Already subscribed")
            return
        }
        
        self.publisher.sink(receiveValue: { [weak self] value in
            self?.log(value.debugDescription)
        }).store(in: &self.cancellables)
        
        log("Subscription started")
    }
    
    override func onEmitTapped() {
        NotificationCenter.default.post(name: .myNotification, object: "A notification")
    }
}

fileprivate extension Notification.Name {
    static let myNotification = Notification.Name("MyNotification")
}
