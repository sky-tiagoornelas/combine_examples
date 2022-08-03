protocol NamesStore {
    func set(names: [String])
    func add(newName: String)
    func get() -> [String]
    func remove()
}

final class NamesStoreImpl: NamesStore {
    
    static let shared = NamesStoreImpl()
    
    private var namesDb = [String]()
    
    private init() {}
    
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
}
