//
//  MovieReview.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/27/24.
//

import Foundation
import Kingfisher

struct MovieCard {
    let movieID: Int
    let poster: Data?
    let title: String
    var rate: Int
    var comment: String
    let creadedAt: Date

    static func makeMovieCard(_ entity: MovieContent.MovieCard) -> Self {
        return MovieCard(
            movieID: entity.movieID,
            poster: entity.poster,
            title: entity.title,
            rate: entity.rate,
            comment: entity.comment,
            creadedAt: entity.createdAt
        )
    }

    static func makeMovieCard(movieInfo: MovieContent.MovieInfo) async -> Self {
        var posterData: Data?

        // Construct full URL by combining base URL with path
        let fullURLString = API.tmdbImageRequestBaseUrl + movieInfo.posterPath
        if let url = URL(string: fullURLString) {
            do {
                let result = try await KingfisherManager.shared.retrieveImage(
                    with: url,
                    options: [.cacheMemoryOnly]
                )
                // Use JPEG with 0.8 quality for better storage efficiency (80-90% size reduction)
                posterData = result.image.jpegData(compressionQuality: 0.8)
            } catch {
                print("[MovieCard] Failed to retrieve poster image for movie ID \(movieInfo.id): \(error.localizedDescription)")
                posterData = nil
            }
        } else {
            print("[MovieCard] Failed to construct URL from path: \(movieInfo.posterPath)")
        }

        return MovieCard(
            movieID: movieInfo.id,
            poster: posterData,
            title: movieInfo.title,
            rate: 0,
            comment: "",
            creadedAt: .now
        )
    }
}
