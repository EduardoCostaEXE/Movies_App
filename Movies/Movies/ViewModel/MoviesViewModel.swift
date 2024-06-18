//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Cabral Costa, Eduardo on 13/06/24.

import Foundation

class MoviesViewModel {
    static let shared = MoviesViewModel()

    private let apiService = APIService()

    var favoriteMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var actionMovies: [Movie] = []
    var comedyMovies: [Movie] = []

    func fetchMovies(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        apiService.fetchPopularMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.popularMovies = movies
            case .failure(let error):
                print("Failed to fetch popular movies: \(error)")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        apiService.fetchMovies(byGenre: "Action") { [weak self] result in
            switch result {
            case .success(let movies):
                self?.actionMovies = movies
            case .failure(let error):
                print("Failed to fetch action movies: \(error)")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        apiService.fetchMovies(byGenre: "Comedy") { [weak self] result in
            switch result {
            case .success(let movies):
                self?.comedyMovies = movies
            case .failure(let error):
                print("Failed to fetch comedy movies: \(error)")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
}
