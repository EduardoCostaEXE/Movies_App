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
    
    var popularMovies: [Movie] = []
    var actionMovies: [Movie] = []
    var comedyMovies: [Movie] = []
    
    func fetchMovies(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        fetchMovies(endpoint: "/movie/popular", language: "pt-BR") { movies in
            self.popularMovies = movies ?? []
            group.leave()
        }
            
        group.enter()
        fetchMovies(endpoint: "/discover/movie", genre: 28, language: "pt-BR") { movies in
            self.actionMovies = movies ?? []
            group.leave()
        }
        
        group.enter()
        fetchMovies(endpoint: "/discover/movie", genre: 35, language: "pt-BR") { movies in
            self.comedyMovies = movies ?? []
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
        
    private func fetchMovies(endpoint: String, genre: Int? = nil, language: String, completion: @escaping ([Movie]?) -> Void) {
        var urlString = "https://api.themoviedb.org/3\(endpoint)?api_key=\(apiKey)&language=\(language)"
        if let genre = genre {
            urlString += "&with_genres=\(genre)"
        }
        
        guard let url = URL(string: urlString) else {
            print("URL inválida: \(urlString)")
            completion(nil)
            return
        }
        
        print("Fetching URL: \(urlString)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erro na requisição: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data else {
                print("Dados não encontrados")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.results)
                }
            } catch {
                print("Erro na decodificação: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON Recebido: \(jsonString)")
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}
