//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Cabral Costa, Eduardo on 13/06/24.

import Foundation

class MoviesViewModel {
    private let apiKey = "42c9e433f49c9956a59378574f5ef333"
    private let baseURL = "https://api.themoviedb.org/3/movie/popular"
    //Token de leitura: eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0MmM5ZTQzM2Y0OWM5OTU2YTU5Mzc4NTc0ZjVlZjMzMyIsInN1YiI6IjY2NmI1ODJlZDU0ZGU2NzIyMjI0Nzg3MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._HLfKpxlQfSa2wqQGxHDBmZ8ht3sXnm5y6w5Bk4SaVo
    
    var movies: [Movie] = []
    
    func fetchMovies(completion: @escaping () -> Void) {
        guard let url = URL(string: "\(baseURL)?api_key=\(apiKey)&language=pt-BR") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                self.movies = response.results
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
}
