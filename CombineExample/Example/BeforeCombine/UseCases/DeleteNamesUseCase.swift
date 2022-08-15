protocol DeleteNamesUseCase {
    func execute(completion: @escaping (Result<Void, Error>) -> Void)
}

final class DeleteNamesUseCaseImpl: DeleteNamesUseCase {
  
    private let namesRepository: NamesRepository
    init(namesRepository: NamesRepository = NamesRepositoryImpl.shared) {
        self.namesRepository = namesRepository
    }
    
    func execute(completion: @escaping (Result<Void, Error>) -> Void) {
        namesRepository.deleteAll(completion: completion)
    }
}
