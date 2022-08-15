import Combine

protocol ObserveNamesUseCase {
    func execute() -> AnyPublisher<[String], Never>
}

final class ObserveNamesUseCaseImpl: ObserveNamesUseCase {
  
    private let namesRepository: NamesRepository
    init(namesRepository: NamesRepository = NamesRepositoryImpl.shared) {
        self.namesRepository = namesRepository
    }
    
    func execute() -> AnyPublisher<[String], Never> {
        return namesRepository.observe()
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
