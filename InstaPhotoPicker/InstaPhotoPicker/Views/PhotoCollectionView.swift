
import SwiftUI
import os.log

struct PhotoCollectionView: View {
    @ObservedObject var photoCollection : PhotoCollection
    @ObservedObject var model : DataModel

    @State var selectMultiPhoto:Bool = false

    @Environment(\.displayScale) private var displayScale
        
    private static let itemSpacing = 0.5
    private static let itemCornerRadius = 0
    private static let itemSize = CGSize(width: UIScreen.main.bounds.width / 4 - 2,
                                         height: UIScreen.main.bounds.width / 4 - 2)
    
    private var imageSize: CGSize {
        return CGSize(width: Self.itemSize.width * min(displayScale, 2),
                      height: Self.itemSize.height * min(displayScale, 2))
    }
    
    private let columns = [
        GridItem(.adaptive(minimum: itemSize.width, maximum: itemSize.height), spacing: itemSpacing)
    ]
    
    var body: some View {
        VStack{
            HStack{
           
                HStack{ NavigationLink {
                    VStack{
                        
                        List{
                                
                            HStack{
                                if let image = model.lastImage {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 90, height: 90)
                                }
                                    VStack(alignment:.leading){
                                        Text(model.photoCollection.albumName ?? "Recents")
                                            .font(.callout)
                                        Text(photoCollection.albumName ?? "0")
                                            .font(.caption)
                                    }
                                
                                Spacer()
                            }
                        }.listStyle(.plain)
                    }.navigationTitle("Select album")
                        .background(Color.black.opacity(0.5))
                        
                } label: {
                    Text(photoCollection.albumName ?? "Recents ")
                                           Image(systemName: "chevron.down")}
                                           .font(.subheadline)
                                           .bold()
                                           .foregroundColor(.white)
                }

                     

              
                
                Spacer()
                Button {
                    selectMultiPhoto.toggle()
                } label: {
                    Capsule()
                        .fill(selectMultiPhoto ? Color.blue : Color.gray.opacity(0.25))
                        .frame(width:100,height: 30)

                        .overlay {
                            HStack(spacing: 4){
                                Image(systemName: "rectangle.on.rectangle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .bold()
                                    .frame(width: 16)
                             Text("Select multiple")
                                    .font(.system(size: 9,weight: .semibold))
                            }

                        }
                }
                    .buttonStyle(.plain)
                   
               
                Button {
                    
                } label: {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 30,height: 30)
                        .overlay {
                            Image(systemName: "camera")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .bold()
                                .frame(width: 16)

                        }
                }.buttonStyle(.plain)

                
            }.padding(.horizontal)
            ScrollView {
                LazyVGrid(columns: columns, spacing: Self.itemSpacing) {
                    ForEach(photoCollection.photoAssets) { asset in
                        
                        PhotoView(model: model, asset: asset, cache: photoCollection.cache, selectMultiPhoto: $selectMultiPhoto)
                          
                                        }
                }
                
            }
        }.onAppear(){
            //model.photoCollection = PhotoCollection(smartAlbum: .smartAlbumFavorites)
        }
       
    }
    
}
