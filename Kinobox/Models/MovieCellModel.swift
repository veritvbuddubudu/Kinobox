//
//  MovieCellModel.swift
//  Kinobox
//
//  Created by Елена Горбунова on 03.08.2023.
//

import UIKit

struct MovieCellModel: Decodable, Equatable {
    let films: [MovieSearch]
}

struct MovieSearch: Decodable, Equatable {
    let filmId: Int?
    let nameRu: String?
    let nameEn: String?
    let posterUrl: String?
}
