import UIKit
import Combine

final class PublisherOperatorsViewController: BaseViewController {
    
    var count = 0
    var publisher: PassthroughSubject<Int?, Error> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PublisherOperators"
    }
    
    override func onSubscribeTapped() {
        
        log("Subscribed!")
        
        publisher = PassthroughSubject()
        
        publisher
            .compactMap { $0 }
            .dropFirst()
            .filter { $0.isMultiple(of: 2) }
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.log("Finished")
                case let .failure(error):
                    self?.log("Receiver error publisher \(error)")
                }
            }, receiveValue: { [weak self] value in
                self?.log("Received even number - \(value)")
            }).store(in: &cancellables)
        
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
