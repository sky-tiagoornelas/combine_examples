import UIKit
import Combine

final class PublisherOperatorsViewController: BaseViewController {
    
    var count = 0
    var publisher: PassthroughSubject<Int?, Error> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PublisherOperators"
    }
    
    struct OBJ : Hashable, Equatable, Codable {
        let lastUpdated: String
    }
    
//    let myObject = OBJ(lastUpdated: "")
    public var myObject: CurrentValueSubject<String, Never> = CurrentValueSubject<String, Never>("")

    
    override func onSubscribeTapped() {

        let cancellable = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .map { DateFormatter().string(from: $0) }
            .assign(to: \.value, on: myObject)

        
        cancellable.cancel()
        
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
