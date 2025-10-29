//
//  KFAsyncImageView.swift
//  MovieBox
//
//  Created by Claude Code on 10/30/25.
//

import SwiftUI
import Kingfisher

struct KFAsyncImageView: View {
    private let urlString: String
    private let size: CGSize
    private let cacheType: CacheType

    enum CacheType {
        case memoryOnly
        case all
    }

    init(urlString: String, size: CGSize, cacheType: CacheType = .all) {
        self.urlString = urlString
        self.size = size
        self.cacheType = cacheType
    }

    var body: some View {
        // Construct full URL by combining base URL with path
        let fullURL = URL(string: API.tmdbImageRequestBaseUrl + urlString)

        KFImage(fullURL)
            .placeholder {
                ImagePlaceholderView(width: size.width, height: size.height)
            }
            .setProcessor(DownsamplingImageProcessor(size: size))
            .scaleFactor(UIScreen.main.scale)
            .configureCachePolicy(for: cacheType)
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .clipped()
    }
}

fileprivate extension KFImage {
    func configureCachePolicy(for cacheType: KFAsyncImageView.CacheType) -> Self {
        switch cacheType {
        case .memoryOnly:
            return self
                .cacheMemoryOnly()
        case .all:
            return self
                .diskCacheExpiration(.days(1))
                .diskCacheAccessExtending(.expirationTime(.seconds(6 * 3600)))
                .cacheOriginalImage()
        }
    }
}

#Preview {
    KFAsyncImageView(
        urlString: "https://image.tmdb.org/t/p/w780/obKmfNexgL4ZP5cAmzdL4KbHHYX.jpg",
        size: CGSize(width: 300, height: 300),
        cacheType: .memoryOnly
    )
}
