protocol NamesStore {
    func set(names: [String])
    func add(newName: String)
    func get() -> [String]
    func remove()
}

final class NamesStoreImpl: NamesStore {
    
    static let shared = NamesStoreImpl()
    
    private var namesStorage = [String]()
    
    private init() {}
    
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
}
