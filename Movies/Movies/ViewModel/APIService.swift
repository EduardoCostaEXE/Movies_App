//
//  APIService.swift
//  Movies
//
//  Created by Cabral Costa, Eduardo on 18/06/24.
//

import Foundation

class APIService {
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "YOUR_KEY"

    func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=en-US&page=1"
        fetchData(from: urlString, completion: completion)
    }

    func fetchMovies(byGenre genre: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let genreId = genre == "Action" ? 28 : (genre == "Comedy" ? 35 : 0)
        let urlString = "\(baseURL)/discover/movie?api_key=\(apiKey)&language=en-US&with_genres=\(genreId)&page=1"
        fetchData(from: urlString, completion: completion)
    }

    private func fetchData(from urlString: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }

            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(movieResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
