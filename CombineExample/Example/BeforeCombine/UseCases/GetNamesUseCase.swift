protocol GetNamesUseCase {
    func execute(completion: @escaping (Result<[String], Error>) -> Void)
}

final class GetNamesUseCaseImpl: GetNamesUseCase {
    
    private let namesRepository: NamesRepository
    init(namesRepository: NamesRepository = NamesRepositoryImpl.shared) {
        self.namesRepository = namesRepository
    }
    
    func execute(completion: @escaping (Result<[String], Error>) -> Void) {
        namesRepository.fetch(completion: completion)
    }
}
