import Combine
import UIKit

protocol ObserveNamesUseCase {
    func observe() -> AnyPublisher<[String], Never>
}

final class ObserveNamesUseCaseImpl: ObserveNamesUseCase {
    
    let namesRepository: NamesRepository
    
    init(namesRepository: NamesRepository = NamesRepositoryImpl.shared) {
        self.namesRepository = namesRepository
    }
    
    func observe() -> AnyPublisher<[String], Never> {
        return namesRepository.observe()
    }
}
