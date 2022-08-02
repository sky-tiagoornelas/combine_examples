import Combine

protocol StoreExampleViewModel {
    func fetchNames()
    func saveName(name: String)
    func deleteNames()
}

protocol StoreExampleViewModelDeletage: AnyObject {
    func onErrorSaving()
    func onNames(names: [String])
    func showLoading()
    func hideLoading()
}

final class StoreExampleViewModelImpl: StoreExampleViewModel {
    
    weak var delegate: StoreExampleViewModelDeletage?
    
    let saveNameUseCase: SaveNameUseCase
    let getNamesUseCase: GetNamesUseCase
    let deleteNamesUseCase: DeleteNamesUseCase
    
    init(
        saveNameUseCase: SaveNameUseCase = SaveNameUseCaseImpl(),
        getNamesUseCase: GetNamesUseCase = GetNamesUseCaseImpl(),
        deleteNamesUseCase: DeleteNamesUseCase = DeleteNamesUseCaseImpl()
    ) {
        self.saveNameUseCase = saveNameUseCase
        self.getNamesUseCase = getNamesUseCase
        self.deleteNamesUseCase = deleteNamesUseCase
    }
    
    func fetchNames() {
        delegate?.showLoading()
        getNamesUseCase.execute { result in
            self.handleFetchResult(result: result)
            self.delegate?.hideLoading()
        }
    }
    
    func saveName(name: String) {
        delegate?.showLoading()
        saveNameUseCase.execute(name: name) { result in
            switch result {
            case .success:
                self.getNamesUseCase.execute { result in
                    self.handleFetchResult(result: result)
                    self.delegate?.hideLoading()
                }
            case .failure:
                self.delegate?.onErrorSaving()
                self.delegate?.hideLoading()
            }
        }
    }

    func deleteNames() {
        delegate?.showLoading()

        deleteNamesUseCase.execute() { result in
            switch result {
            case .success:
                self.getNamesUseCase.execute { result in
                    self.handleFetchResult(result: result)
                    self.delegate?.hideLoading()
                }
            case .failure:
                self.delegate?.onErrorSaving()
                self.delegate?.hideLoading()
            }
        }
    }
}

extension StoreExampleViewModelImpl {
    private func handleFetchResult(result: Result<[String], Error>) {
        switch result {
        case let .success(names):
            delegate?.onNames(names: names)
        case .failure:
            delegate?.onErrorSaving()
        }
    }
}
