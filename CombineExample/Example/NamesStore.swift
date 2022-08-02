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
    private let publisher: CurrentValueSubject<[String], Never>
    
    private var namesDb = [String]() {
        didSet {
            publisher.send(namesDb)
        }
    }
    
    private init() {
        publisher = CurrentValueSubject(namesDb)
    }
    
    func set(names: [String]) {
        namesDb = names
    }
    
    func add(newName: String) {
        namesDb.append(newName)
    }
    
    func get() -> [String] {
        return namesDb
    }
    
    func remove() {
        namesDb.removeAll()
    }
    
    func observe() -> AnyPublisher<[String], Never> {
        return publisher.eraseToAnyPublisher()
    }
}
