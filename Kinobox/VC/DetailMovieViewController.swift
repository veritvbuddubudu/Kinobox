//
//  DetailMovieViewController.swift
//  Kinobox
//
//  Created by Елена Горбунова on 07.08.2023.
//

import UIKit


class DetailMovieViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ColorBackground")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var kinopoiskLabel: UILabel = {
        let label = UILabel()
        label.text = "Кинопоиск"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var kinopoiskChartLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imdbLabel: UILabel = {
        let label = UILabel()
        label.text = "IMDB"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imdbChartLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieNameRuLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieNameOriginLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.textAlignment = .left
        label.numberOfLines = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productionYearLabelConst: UILabel = {
        let label = UILabel()
        label.text = "Год производства"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productionYearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var durationLabelConst: UILabel = {
        let label = UILabel()
        label.text = "Продолжительность"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var movieId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        fetchMovie()
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        view.addSubview(backgroundView)
        backgroundView.addSubview(imageMovie)
        backgroundView.addSubview(kinopoiskLabel)
        backgroundView.addSubview(kinopoiskChartLabel)
        backgroundView.addSubview(imdbLabel)
        backgroundView.addSubview(imdbChartLabel)
        backgroundView.addSubview(movieNameRuLabel)
        backgroundView.addSubview(movieNameOriginLabel)
        backgroundView.addSubview(descriptionLabel)
        backgroundView.addSubview(productionYearLabelConst)
        backgroundView.addSubview(productionYearLabel)
        backgroundView.addSubview(durationLabelConst)
        backgroundView.addSubview(durationLabel)
    }
    
    private func setupModel(movie: Movie) {
        kinopoiskChartLabel.text = String(describing: movie.ratingKinopoisk ?? 0)
        imdbChartLabel.text = String(describing: movie.ratingImdb ?? 0)
        movieNameRuLabel.text = movie.nameRu
        movieNameOriginLabel.text = movie.nameOriginal
        descriptionLabel.text = movie.description
        productionYearLabel.text = String(describing: movie.year ?? 0)
        durationLabel.text = "\(String(describing: movie.filmLength ?? 0)) мин."
        
        guard let url = movie.posterUrl else { return }
        setupImage(urlString: url)
    }
    
    private func setupImage(urlString: String?) {
        
        if let url = urlString {
            
            NetworkRequest.shared.requestDataFetch(urlString: url) { [weak self] result in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    self?.imageMovie.image = image
                case .failure(let error):
                    self?.imageMovie.image = nil
                    print("No album image" + error.localizedDescription)
                }
            }
        } else {
            imageMovie.image = nil
        }
    }
    
    private func fetchMovie() {
        
        guard let filmId = movieId else { return }
        
        let urlString = "https://kinopoiskapiunofficial.tech/api/v2.2/films/\(filmId)"
        
        NetworkDataFetch.shared.fetchMovie(urlString: urlString) { [weak self] movieModel, error in
            if error == nil {
                guard let movieModel = movieModel else { return }
                self?.setupModel(movie: movieModel)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}

//MARK: - Constraints

extension DetailMovieViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            backgroundView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            imageMovie.heightAnchor.constraint(equalToConstant:CGFloat(200)),
            imageMovie.widthAnchor.constraint(equalToConstant:CGFloat(150)),
            imageMovie.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 30),
            imageMovie.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            
            kinopoiskLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 30),
            kinopoiskLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            kinopoiskLabel.leadingAnchor.constraint(equalTo: imageMovie.trailingAnchor, constant: 70),
            
            kinopoiskChartLabel.topAnchor.constraint(equalTo: kinopoiskLabel.bottomAnchor, constant: 20),
            kinopoiskChartLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            kinopoiskChartLabel.leadingAnchor.constraint(equalTo: imageMovie.trailingAnchor, constant: 100),
            
            imdbLabel.topAnchor.constraint(equalTo: kinopoiskChartLabel.bottomAnchor, constant: 30),
            imdbLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            imdbLabel.leadingAnchor.constraint(equalTo: imageMovie.trailingAnchor, constant: 90),
            
            imdbChartLabel.topAnchor.constraint(equalTo: imdbLabel.bottomAnchor, constant: 20),
            imdbChartLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            imdbChartLabel.leadingAnchor.constraint(equalTo: imageMovie.trailingAnchor, constant: 100),
            
            movieNameRuLabel.topAnchor.constraint(equalTo: imageMovie.bottomAnchor, constant: 30),
            movieNameRuLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            movieNameOriginLabel.topAnchor.constraint(equalTo: movieNameRuLabel.bottomAnchor, constant: 10),
            movieNameOriginLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            descriptionLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -10),
            descriptionLabel.topAnchor.constraint(equalTo: movieNameOriginLabel.bottomAnchor, constant: 10),
            
            productionYearLabelConst.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            productionYearLabelConst.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -10),
            productionYearLabelConst.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            
            productionYearLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            productionYearLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -10),
            productionYearLabel.topAnchor.constraint(equalTo: productionYearLabelConst.bottomAnchor, constant: 5),
            
            durationLabelConst.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            durationLabelConst.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -10),
            durationLabelConst.topAnchor.constraint(equalTo: productionYearLabel.bottomAnchor, constant: 15),
            
            durationLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            durationLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -10),
            durationLabel.topAnchor.constraint(equalTo: durationLabelConst.bottomAnchor, constant: 5),
            
        ])
    }
}
