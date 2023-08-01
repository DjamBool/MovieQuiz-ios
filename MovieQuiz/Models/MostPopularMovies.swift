//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Игорь Мунгалов on 01.08.2023.
//

import Foundation

struct MostPopularMovies {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
        }
}
