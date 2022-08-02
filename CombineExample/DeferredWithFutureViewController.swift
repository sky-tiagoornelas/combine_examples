import UIKit
import Combine

final class DeferredWithFutureViewController: BaseViewController {
    var count = 0
    var deferred: Deferred<Future<String, DeferredExampleError>>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Deferred"
        
        cancelButton.isEnabled = false
    }
    
    override func onSubscribeTapped() {
        guard cancellables.isEmpty else {
            log("Already subscribed")
            return
        }
        
        deferred = Deferred {
            Future { [weak self] promise in
                self?.log("Subscription started")
                guard let self = self else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if self.count % 2 == 0 {
                        promise(.success("Success event"))
                    } else {
                        promise(.failure(DeferredExampleError()))
                    }
                    
                    self.count += 1
                }
            }
        }
    }
    
    override func onEmitTapped() {
        deferred?.sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                self?.log("Completed")
            case let .failure(error):
                self?.log("Failed with error \(error)")
            }
            self?.onCancelTapped()
        }, receiveValue: { [weak self] value in
            self?.log("Recieved \(value)")
        }).store(in: &cancellables)
    }
}

class DeferredExampleError: Error{ }
