import UIKit
import Combine

final class PublisherOperatorsViewController: BaseViewController {
    
    var count = 0
    var publisher: PassthroughSubject<Int?, Never> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PublisherOperators"
    }
    
    override func onSubscribeTapped() {
        log("Subscribed!")
        
        publisher = PassthroughSubject()
        
        publisher
            .dropFirst()
            .compactMap { $0 }
            .filter { $0.isMultiple(of: 2) }
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.log("Received even number - \(value)")
            }.store(in: &cancellables)
        
    }
    
    override func onEmitTapped() {
        if count == 4 {
            publisher.send(nil)
        } else {
            publisher.send(count)
        }
        count += 1
    }
}

class PublisherOperators: Error {}
