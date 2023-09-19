//
//  MovieItemCell.swift
//  Kinobox
//
//  Created by Елена Горбунова on 03.08.2023.
//

import UIKit

class MovieItemCell: UITableViewCell {
    
    private lazy var imageMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameMovieLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "test"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = .clear
        self.selectionStyle = .gray
        
        contentView.addSubview(imageMovie)
        contentView.addSubview(nameMovieLabel)
    }
    
    func configureMovieItemCell(movie: MovieSearch) {
        if let urlString = movie.posterUrl {
            NetworkRequest.shared.requestDataFetch(urlString: urlString) { [weak self] result in
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
        nameMovieLabel.text = movie.nameRu ?? movie.nameEn
    }
}

//MARK: - Constraints

extension MovieItemCell {
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            imageMovie.heightAnchor.constraint(equalToConstant:CGFloat(80)),
            imageMovie.widthAnchor.constraint(equalToConstant:CGFloat(50)),
            imageMovie.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageMovie.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            imageMovie.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            nameMovieLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameMovieLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            nameMovieLabel.leadingAnchor.constraint(equalTo: imageMovie.trailingAnchor, constant: 20),
            nameMovieLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
            
        ])
    }
}


