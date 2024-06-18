//
//  MoviesListViewController.swift
//  Movies
//
//  Created by Cabral Costa, Eduardo on 13/06/24.
//

import UIKit

class MoviesListViewController: UIViewController {
    private let viewModel = MoviesViewModel()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MovieSectionTableViewCell.self, forCellReuseIdentifier: MovieSectionTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchMovies()
    }

    private func setupView() {
        title = "Filmes"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func fetchMovies() {
        viewModel.fetchMovies { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieSectionTableViewCell.identifier, for: indexPath) as? MovieSectionTableViewCell else {
            return UITableViewCell()
        }
        let movies: [Movie]
        switch indexPath.section {
        case 0:
            movies = viewModel.favoriteMovies
            cell.configure(with: movies, title: "Favoritos", navigationController: navigationController!)
        case 1:
            movies = viewModel.popularMovies
            cell.configure(with: movies, title: "Populares", navigationController: navigationController!)
        case 2:
            movies = viewModel.actionMovies
            cell.configure(with: movies, title: "Ação", navigationController: navigationController!)
        case 3:
            movies = viewModel.comedyMovies
            cell.configure(with: movies, title: "Comédia", navigationController: navigationController!)
        default:
            movies = []
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
