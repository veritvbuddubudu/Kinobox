//
//  ViewController.swift
//  Kinobox
//
//  Created by Елена Горбунова on 02.08.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.alpha = 0.75
        textField.borderStyle = .roundedRect
        textField.textColor = .white
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        textField.attributedPlaceholder = NSAttributedString(string: "Введите текст", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        var button = UIButton()
        button.bounds = CGRect(x: 200, y: 200, width: 100, height: 40)
        button.animatedGradient(colors: [UIColor.systemPink.cgColor, UIColor.purple.cgColor, UIColor.systemPink.cgColor])
        button.setTitle("Поиск", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let popularMovieButton: UIButton = {
        var button = UIButton()
        button.bounds = CGRect(x: 200, y: 200, width: 200, height: 40)
        button.animatedGradient(colors: [UIColor.purple.cgColor, UIColor.systemPink.cgColor, UIColor.purple.cgColor])
        button.setTitle("Популярные фильмы", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        button.addTarget(self, action: #selector(popularMovieButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .darkGray
        tableView.sectionHeaderTopPadding = 0
        tableView.separatorColor = UIColor(named: "ColorBackground")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 11)
        tableView.layer.cornerRadius = 10
        tableView.register(MovieItemCell.self, forCellReuseIdentifier: "cell")
        tableView.register(CustomHeader.self,
                           forHeaderFooterViewReuseIdentifier: "sectionHeader")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    var movies = [MovieSearch]()
    var categories = ["Action", "Drama", "Science Fiction", "Kids", "Horror"]
    private var tableHeader = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupDelegate()
        setupConstraints()
        setupDelegateForTextFiled()
    }
 
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupDelegateForTextFiled() {
        searchTextField.delegate = self
    }
    
    func setupView() {
        view.backgroundColor = UIColor(named: "ColorBackground")
        
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(popularMovieButton)
        view.addSubview(tableView)
    }
    
    @objc private func searchButtonTapped() {
        
        guard let movieName = searchTextField.text else { return }
        
        let urlString = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(movieName)"
        
        NetworkDataFetch.shared.fetchMovieSearch(urlString: urlString) { [weak self] searchMovieCellModel, error in
            if error == nil {
                guard let searchMovieCellModel = searchMovieCellModel else { return }
                self?.movies = searchMovieCellModel.films
                self?.tableHeader = "Поиск по запросу: \(movieName)"
                self?.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    @objc private func popularMovieButtonTapped() {
        
        let urlString = "https://kinopoiskapiunofficial.tech/api/v2.2/films/top?type=TOP_100_POPULAR_FILMS"
        
        NetworkDataFetch.shared.fetchMovieSearch(urlString: urlString) { [weak self] popularMovieCellModel,
            error in
            if error == nil {
                guard let popularMovieCellModel = popularMovieCellModel else { return }
                self?.movies = popularMovieCellModel.films
                self?.tableHeader = "Популярные фильмы"
                self?.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}

//MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! CustomHeader
        view.mainLabel.text = tableHeader
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailMovieVC = DetailMovieViewController()
        let movie = movies[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        detailMovieVC.movieId = movie.filmId
        present(detailMovieVC, animated: true)
    }
}

//MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieItemCell
        let movie = movies[indexPath.row]
        cell.configureMovieItemCell(movie: movie)
        return cell
    }
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



//MARK: - Constraints

extension ViewController {
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            searchButton.widthAnchor.constraint(equalToConstant: 100),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            
            popularMovieButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popularMovieButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 20),
            popularMovieButton.widthAnchor.constraint(equalToConstant: 200),
            popularMovieButton.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: popularMovieButton.bottomAnchor, constant: 100),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

