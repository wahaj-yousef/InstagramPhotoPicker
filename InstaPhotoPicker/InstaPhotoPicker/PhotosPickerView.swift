//
//  PhotosPickerView.swift
//  InstaPhotoPicker
//
//  Created by Wahaj on 14/04/2023.
//

import SwiftUI

struct PhotosPickerView: View {
    @ObservedObject var photoCollection : PhotoCollection
    
    @Environment(\.displayScale) private var displayScale
        
    private static let itemSpacing = 12.0
    private static let itemCornerRadius = 15.0
    private static let itemSize = CGSize(width: 90, height: 90)
    
    private var imageSize: CGSize {
        return CGSize(width: Self.itemSize.width * min(displayScale, 2), height: Self.itemSize.height * min(displayScale, 2))
    }
    
    private let columns = [
        GridItem(.adaptive(minimum: itemSize.width, maximum: itemSize.height), spacing: itemSpacing)
    ]
    
    var body: some View {
        ScrollView {
            
            LazyVGrid(columns: columns, spacing: Self.itemSpacing) {
                ForEach(photoCollection.photoAssets) { asset in
                    NavigationLink {
                        PhotoView(asset: asset, cache: photoCollection.cache)
                    } label: {
                        photoItemView(asset: asset)
                    }
                    .buttonStyle(.borderless)
                    .accessibilityLabel(asset.accessibilityLabel)
                }
            }
            .padding([.vertical], Self.itemSpacing)
        }
    }
    private func photoItemView(asset: PhotoAsset) -> some View {
        PhotoItemView(asset: asset, cache: photoCollection.cache, imageSize: imageSize)
            .frame(width: Self.itemSize.width, height: Self.itemSize.height)
            .clipped()
            .cornerRadius(Self.itemCornerRadius)
            .overlay(alignment: .bottomLeading) {
                if asset.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 1)
                        .font(.callout)
                        .offset(x: 4, y: -4)
                }
            }
            .onAppear {
                Task {
                    await photoCollection.cache.startCaching(for: [asset], targetSize: imageSize)
                }
            }
            .onDisappear {
                Task {
                    await photoCollection.cache.stopCaching(for: [asset], targetSize: imageSize)
                }
            }
    }
}


