protocol NamesListViewModel {
    func fetchNames()
    func saveName(name: String)
    func deleteNames()
}

protocol NamesListViewModelDelegate: AnyObject {
    func onErrorSaving()
    func onNames(names: [String])
    func showLoading()
    func hideLoading()
}

final class NamesListViewModelImpl: NamesListViewModel {
    
    weak var delegate: NamesListViewModelDelegate?
    
    private let saveNameUseCase: SaveNameUseCase = SaveNameUseCaseImpl()
    private let getNamesUseCase: GetNamesUseCase = GetNamesUseCaseImpl()
    private let deleteNamesUseCase: DeleteNamesUseCase = DeleteNamesUseCaseImpl()
    
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

extension NamesListViewModelImpl {
    private func handleFetchResult(result: Result<[String], Error>) {
        switch result {
        case let .success(names):
            delegate?.onNames(names: names)
        case .failure:
            delegate?.onErrorSaving()
        }
    }
}
