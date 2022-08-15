import Combine

protocol NamesListViewModel1 {
    var showLoading: CurrentValueSubject<Bool, Never> { get }
    var showError: PassthroughSubject<Error?, Never> { get }
    
    func fetchNames()
    func saveName(name: String)
    func deleteNames()
    func observeNames() -> AnyPublisher<[String], Never>
}

final class NamesListViewModelImpl1: NamesListViewModel1 {
    
    let showLoading = CurrentValueSubject<Bool, Never>(false)
    let showError = PassthroughSubject<Error?, Never>()

    private let saveNameUseCase: SaveNameUseCase = SaveNameUseCaseImpl()
    private let getNamesUseCase: GetNamesUseCase = GetNamesUseCaseImpl()
    private let deleteNamesUseCase: DeleteNamesUseCase = DeleteNamesUseCaseImpl()
    private let observeNamesUseCase: ObserveNamesUseCase = ObserveNamesUseCaseImpl()

    func fetchNames() {
        showLoading.send(true)
        self.getNamesUseCase.execute { result in
            self.handleErrorIfNeeded(result: result)
            self.showLoading.send(false)
        }
    }
    
    func saveName(name: String) {
        showLoading.send(true)
        saveNameUseCase.execute(name: name) { result in
            self.handleErrorIfNeeded(result: result)
            self.showLoading.send(false)
        }
    }

    func deleteNames() {
        showLoading.send(true)
        deleteNamesUseCase.execute() { result in
            self.handleErrorIfNeeded(result: result)
            self.showLoading.send(false)
        }
    }
    
    func observeNames() -> AnyPublisher<[String], Never> {
        return observeNamesUseCase.execute()
    }
    
    private func handleErrorIfNeeded<T>(result: Result<T, Error>) {
        if case let .failure(error) = result {
            self.showError.send(error)
        }
    }
}
