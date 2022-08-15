import Combine

protocol NamesStore {
    func set(names: [String])
    func add(newName: String)
    func get() -> [String]
    func remove()
    func observe() -> AnyPublisher<[String], Never>
}

final class NamesStoreImpl: NamesStore {
    
    static let shared = NamesStoreImpl()
    
    private var namesStorage = [String]() {
        didSet {
            subject.send(namesStorage)
        }
    }
    private var subject: CurrentValueSubject<[String], Never>
    
    private init() {
        subject = CurrentValueSubject(namesStorage)
    }
    
    func set(names: [String]) {
        namesStorage = names
    }
    
    func add(newName: String) {
        namesStorage.append(newName)
    }
    
    func get() -> [String] {
        return namesStorage
    }
    
    func remove() {
        namesStorage.removeAll()
    }
    
    func observe() -> AnyPublisher<[String], Never> {
        return subject.eraseToAnyPublisher()
    }
}
