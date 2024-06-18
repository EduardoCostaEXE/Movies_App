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
    
    private var sections: [Section] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchMovies()
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
            guard let self = self else { return }
            self.configureSections()
            self.tableView.reloadData()
        }
    }

    private func configureSections() {
        sections.removeAll()

        if viewModel.favoriteMovies.count > 0 {
            sections.append(.favorite)
        }
        sections.append(contentsOf: [.popular, .action, .comedy])
    }
}

extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieSectionTableViewCell.identifier, for: indexPath) as? MovieSectionTableViewCell else {
            return UITableViewCell()
        }

        let movies: [Movie]
        let title: String

        switch sections[indexPath.section] {
        case .favorite:
            movies = viewModel.favoriteMovies
            title = "Favorites"
        case .popular:
            movies = viewModel.popularMovies
            title = "Popular"
        case .action:
            movies = viewModel.actionMovies
            title = "Action"
        case .comedy:
            movies = viewModel.comedyMovies
            title = "Comedy"
        }

        cell.configure(with: movies, title: title, navigationController: navigationController!)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

enum Section {
    case favorite
    case popular
    case action
    case comedy
}
