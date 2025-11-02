import Swinject

extension DIContainer {
    func buildContainer() -> Container {
        let container = Container()

        buildDataSources(container)
        buildRepositories(container)
        buildUseCases(container)

        return container
    }

    private func buildDataSources(_ container: Container) {
        container.register(MovieListDataSource.self) { _ in
            DefaultMovieListDataSource()
        }
        .inObjectScope(.container)

        container.register(MovieContentDataSource.self) { _ in
            DefaultMovieContentDataSource()
        }
        .inObjectScope(.container)

        container.register(MovieBoxDataSource.self) { _ in
            DefaultMovieBoxDataSource()
        }
        .inObjectScope(.container)
    }

    private func buildRepositories(_ container: Container) {
        container.register(MovieListRepository.self) { resolver in
            let dataSource = resolver.resolve(MovieListDataSource.self)!
            return DefaultMovieListRepository(dataSource: dataSource)
        }
        .inObjectScope(.container)

        container.register(MovieContentRepository.self) { resolver in
            let dataSource = resolver.resolve(MovieContentDataSource.self)!
            return DefaultMovieContentRepository(datasource: dataSource)
        }
        .inObjectScope(.container)

        container.register(MovieBoxRepository.self) { resolver in
            let dataSource = resolver.resolve(MovieBoxDataSource.self)!
            return DefaultMovieBoxRepository(dataSource: dataSource)
        }
        .inObjectScope(.container)
    }

    private func buildUseCases(_ container: Container) {
        container.register(MovieListUseCase.self) { resolver in
            let repository = resolver.resolve(MovieListRepository.self)!
            return DefaultMovieListUseCase(movieListRepository: repository)
        }
        .inObjectScope(.container)

        container.register(MovieContentUseCase.self) { resolver in
            let movieContentRepository = resolver.resolve(MovieContentRepository.self)!
            let movieBoxRepository = resolver.resolve(MovieBoxRepository.self)!

            return DefaultMovieContentUseCase(
                movieContentRepository: movieContentRepository,
                movieBoxRepository: movieBoxRepository
            )
        }
        .inObjectScope(.container)
    }
}
