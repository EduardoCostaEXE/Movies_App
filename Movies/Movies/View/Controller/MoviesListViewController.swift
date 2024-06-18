//
//  MoviesListViewController.swift
//  Movies
//
//  Created by Cabral Costa, Eduardo on 13/06/24.
//

import UIKit

class MoviesListViewController: UIViewController {
    private let viewModel = MoviesViewModel.shared

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
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavorites), name: .favoritesUpdated, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadFavorites()
    }

    private func setupView() {
        title = "Movies"
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

    @objc private func reloadFavorites() {
        tableView.reloadData()
    }
}

extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let isWithFavorite = viewModel.favoriteMovies.count > 0
        return isWithFavorite ? 4 : 3
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
            if viewModel.favoriteMovies.count > 0 {
                movies = viewModel.favoriteMovies
                cell.configure(with: movies, title: "Favorites", navigationController: navigationController!)
            } else {
                movies = viewModel.popularMovies
                cell.configure(with: movies, title: "Popular", navigationController: navigationController!)
            }
        case 1:
            if viewModel.favoriteMovies.count > 0 {
                movies = viewModel.popularMovies
                cell.configure(with: movies, title: "Popular", navigationController: navigationController!)
            } else {
                movies = viewModel.actionMovies
                cell.configure(with: movies, title: "Action", navigationController: navigationController!)
            }
        case 2:
            if viewModel.favoriteMovies.count > 0 {
                movies = viewModel.actionMovies
                cell.configure(with: movies, title: "Action", navigationController: navigationController!)
            } else {
                movies = viewModel.comedyMovies
                cell.configure(with: movies, title: "Comedy", navigationController: navigationController!)
            }
        case 3:
            movies = viewModel.comedyMovies
            cell.configure(with: movies, title: "Comedy", navigationController: navigationController!)
        default:
            movies = []
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
