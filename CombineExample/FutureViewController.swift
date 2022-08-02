import UIKit
import Combine

final class FutureViewController: BaseViewController {
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Future"
        
        emitButton.isEnabled = false
        cancelButton.isEnabled = false
    }
    	
    override func onSubscribeTapped() {
        
        let publisher = Future<String, Error> { promise in
            if self.count % 2 == 0 {
                promise(.success("A value"))
            } else {
                promise(.failure(FutureError()))
            }
            
            self.count += 1
        }
                
        publisher
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.log("Completed")
                case let .failure(error):
                    self?.log("Failed with error \(error)")
                }
        }, receiveValue: { [weak self] value in
            self?.log("Received \(value)")
        }).store(in: &cancellables)
        
        log("Subscription started")
    }
}

class FutureError : Swift.Error {}
