import UIKit
import Combine

final class BackgroundForegroundViewController: BaseViewController {
    
    lazy var enterBackgroundPublisher: NotificationCenter.Publisher = {
        return NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification, object: nil)
    }()
    
    lazy var enterForegroundPublisher: NotificationCenter.Publisher = {
        return NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification, object: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NSNotification"
        
        stackView.isHidden = true
        
        self.enterBackgroundPublisher.sink(receiveValue: { [weak self] value in
            self?.log(value.debugDescription)
        }).store(in: &self.cancellables)
        
        self.enterForegroundPublisher.sink(receiveValue: { [weak self] value in
            self?.log(value.debugDescription)
        }).store(in: &self.cancellables)
        
        log("Subscription started")
    }
}
