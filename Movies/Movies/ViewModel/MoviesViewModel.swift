//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Cabral Costa, Eduardo on 13/06/24.

import Foundation

class MoviesViewModel {
    private let apiKey = "42c9e433f49c9956a59378574f5ef333"
    private let baseURL = "https://api.themoviedb.org/3"
    //Token de leitura: eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0MmM5ZTQzM2Y0OWM5OTU2YTU5Mzc4NTc0ZjVlZjMzMyIsInN1YiI6IjY2NmI1ODJlZDU0ZGU2NzIyMjI0Nzg3MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._HLfKpxlQfSa2wqQGxHDBmZ8ht3sXnm5y6w5Bk4SaVo
    
    var popularMovies: [Movie] = []
    var actionMovies: [Movie] = []
    var comedyMovies: [Movie] = []
    var favoriteMovies: [Movie] = []

    func fetchMovies(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        fetchMovies(for: .popular) { [weak self] movies in
            self?.popularMovies = movies
            group.leave()
        }

        group.enter()
        fetchMovies(for: .action) { [weak self] movies in
            self?.actionMovies = movies
            group.leave()
        }

        group.enter()
        fetchMovies(for: .comedy) { [weak self] movies in
            self?.comedyMovies = movies
            group.leave()
        }

        group.notify(queue: .main) {
            completion()
        }
    }

    private func fetchMovies(for category: MovieCategory, completion: @escaping ([Movie]) -> Void) {
        let categoryURL: String
        switch category {
        case .popular:
            categoryURL = "\(baseURL)/movie/popular?api_key=\(apiKey)"
        case .action:
            categoryURL = "\(baseURL)/discover/movie?api_key=\(apiKey)&with_genres=28"
        case .comedy:
            categoryURL = "\(baseURL)/discover/movie?api_key=\(apiKey)&with_genres=35"
        }

        guard let url = URL(string: categoryURL) else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion([])
                return
            }
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(response.results)
            } catch {
                completion([])
            }
        }.resume()
    }
}
