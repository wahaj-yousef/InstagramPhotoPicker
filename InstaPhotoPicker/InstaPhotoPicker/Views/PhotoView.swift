
import SwiftUI
import Photos

struct PhotoView: View {
    @ObservedObject var model : DataModel
    
    var asset: PhotoAsset
    var cache: CachedImageManager?
    @State private var image: Image?
    @State private var imageRequestID: PHImageRequestID?
    @State private var selected: Bool = false
    @Binding var selectMultiPhoto: Bool

    @Environment(\.dismiss) var dismiss
    private let imageSize = CGSize(width: 1024, height: 1024)
    
    var body: some View {
        Group {
            ZStack(alignment: .topTrailing){
               
                if let image = image {
                    image
                    
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width
                               / 4 - 2, height: UIScreen.main.bounds.width / 4 - 2)
                        .clipped()
                        .onTapGesture  {
                            if !selectMultiPhoto{
                                model.lastImage = image
                            }
                            
                        }
                    
                } else {
                    ProgressView()
                }
                
                if selected {
                    Color.white.opacity(0.3)
                        .frame(width: UIScreen.main.bounds.width
                               / 4 - 2, height: UIScreen.main.bounds.width / 4 - 2)
                }
                
                if selectMultiPhoto {
                    checkButton()
                }
            }
        }.onChange(of: selectMultiPhoto){ newValue in
            model.lastImages = []
            selected = false

        }
       
        
        .task {
            guard image == nil, let cache = cache else { return }
            imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { result in
                Task {
                    if let result = result {
                        self.image = result.image
                    }
                }
            }
        }
    }
    private func checkButton() -> some View {
            
            Button {
                selected.toggle()
                if selected{
                    model.lastImages.append(image)
                } else {
                    model.lastImages.remove(at: model.lastImages.index(of:image)!)

                }
            } label: {
                Image(systemName: selected ? "circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(selected ? .blue: .white)
                    
                    .overlay{
                        if var num = model.lastImages.index(of:image){
                            Text("\(num + 1)")
                                .font(.system(size: 10))
                        }


                    }
            }
            .buttonBorderShape(.roundedRectangle(radius: 50))
            .buttonStyle(.plain)
            .padding(3)
            .onAppear(){
               
            }

    
     
    }
    
}
