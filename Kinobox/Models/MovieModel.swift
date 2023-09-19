//
//  MovieModel.swift
//  Kinobox
//
//  Created by Елена Горбунова on 07.08.2023.
//

import UIKit

struct Movie: Decodable, Equatable {
    let filmId: Int?
    let nameRu: String?
    let nameOriginal: String?
    let posterUrl: String?
    let ratingKinopoisk: Double?
    let ratingImdb: Double?
    let year: Int?
    let filmLength: Int?
    let description: String?
}
