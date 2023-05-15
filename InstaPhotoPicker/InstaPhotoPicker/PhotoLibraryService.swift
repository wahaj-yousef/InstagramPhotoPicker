//import Foundation
//import Photos
//import UIKit
//
//class PhotoLibraryService: ObservableObject {
//    /// Requests an image copy given a photo asset id.
//    ///
//    /// The image caching manager performs the fetching, and will
//    /// cache the photo fetched for later use. Please know that the
//    /// cache is temporary – all photos cached will be lost when the
//    /// app is terminated.
//    func fetchImage(
//        byLocalIdentifier localId: PHAssetLocalIdentifier,
//        targetSize: CGSize = PHImageManagerMaximumSize,
//        contentMode: PHImageContentMode = .default
//    ) async throws -> UIImage? {
//        let results = PHAsset.fetchAssets(
//            withLocalIdentifiers: [localId],
//            options: nil
//        )
//        guard let asset = results.firstObject else {
//            throw QueryError.phAssetNotFound
//        }
//        let options = PHImageRequestOptions()
//        options.deliveryMode = .opportunistic
//        options.resizeMode = .fast
//        options.isNetworkAccessAllowed = true
//        options.isSynchronous = true
//        return try await withCheckedThrowingContinuation { [weak self] continuation in
//            /// Use the imageCachingManager to fetch the image
//            self?.imageCachingManager.requestImage(
//                for: asset,
//                targetSize: targetSize,
//                contentMode: contentMode,
//                options: options,
//                resultHandler: { image, info in
//                    /// image is of type UIImage
//                    if let error = info?[PHImageErrorKey] as? Error {
//                        continuation.resume(throwing: error)
//                        return
//                    }
//                    continuation.resume(returning: image)
//                }
//            )
//        }
//    }
//}
