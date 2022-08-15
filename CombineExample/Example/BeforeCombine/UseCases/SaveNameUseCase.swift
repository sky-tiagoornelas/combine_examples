protocol SaveNameUseCase {
    func execute(name: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class SaveNameUseCaseImpl: SaveNameUseCase {
  
    private let namesRepository: NamesRepository
    init(namesRepository: NamesRepository = NamesRepositoryImpl.shared) {
        self.namesRepository = namesRepository
    }
    
    func execute(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        namesRepository.save(newName: name, completion: completion)
    }
}
