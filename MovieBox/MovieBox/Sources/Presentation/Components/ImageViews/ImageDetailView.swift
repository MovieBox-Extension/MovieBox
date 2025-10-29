//
//  ImageDetailView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 12/10/24.
//

import SwiftUI
import Kingfisher

struct ImageDetailView: View {

    private let imagePath: String?
    private let width: CGFloat
    let onClose: () -> Void

    init(imagePath: String?, width: CGFloat, onClose: @escaping () -> Void, imageData: Data? = nil) {
        self.imagePath = imagePath
        self.width = width
        self.onClose = onClose
    }

    var body: some View {
        NavigationStack {

            VStack(alignment: .center) {

                if let imagePath = imagePath {
                    // Construct full URL by combining base URL with path
                    let fullURL = URL(string: API.tmdbImageRequestBaseUrl + imagePath)

                    KFImage(fullURL)
                        .placeholder {
                            ProgressView()
                        }
                        .setProcessor(DownsamplingImageProcessor(size: CGSize(width: width, height: width * 1.5)))
                        .scaleFactor(UIScreen.main.scale)
                        .cacheOriginalImage()
                        .resizable()
                        .scaledToFit()
                        .frame(width: width)
                } else {
                    ProgressView()
                }

            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        onClose()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }
                }
            }

        }
    }
}
