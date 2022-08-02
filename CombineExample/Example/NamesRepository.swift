import Combine
import Foundation

protocol NamesRepository {
    func save(newName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func fetch(completion: @escaping (Result<[String], Error>) -> Void)
    func deleteAll(completion: @escaping (Result<Void, Error>) -> Void)
    func observe() -> AnyPublisher<[String], Never>
}

final class NamesRepositoryImpl: NamesRepository {
    
    static let requestTimeout = 0.5
    
    static let shared = NamesRepositoryImpl()
    
    private let namesStore: NamesStore
    private init(namesStore: NamesStore = NamesStoreImpl.shared) {
        self.namesStore = namesStore
    }
    
    func save(newName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + Self.requestTimeout) {
            if Int.random(in: 1...10) > 8 {
                completion(.failure(NSError()))
            } else {
                self.namesStore.add(newName: newName)
                completion(.success(()))
            }
        }
    }
    
    func fetch(completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + Self.requestTimeout) {
            let items = self.namesStore.get()
            self.namesStore.set(names: items)
            completion(.success(items))
        }
    }
    
    func deleteAll(completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + Self.requestTimeout) {
            self.namesStore.remove()
            completion(.success(()))
        }
    }
    
    func observe() -> AnyPublisher<[String], Never> {
        return namesStore.observe()
    }
}
