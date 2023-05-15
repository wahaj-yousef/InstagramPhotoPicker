//
//  ContentView.swift
//  InstaPhotoPicker
//
//  Created by Wahaj on 04/04/2023.
//

import SwiftUI
import PhotosUI

struct RootView: View {
    @ObservedObject private var model = DataModel()
    
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var scaleImage: Bool = false
    var body: some View {
        NavigationView {
            
            VStack{
                ZStack(alignment: .bottomLeading){
                    VStack{
                        if model.lastImages.isEmpty{
                            
                            Rectangle()
                                .fill(.black)
                                .overlay{
                                    if let img =  model.lastImage {
                                        
                                        if scaleImage {
                                            img.resizable().scaledToFill()
                                        } else{
                                            img.resizable().scaledToFit()
                                            
                                        }
                                        
                                    }
                                    
                                }
                            
                        } else{
                            
                            ForEach(model.lastImages.indices){ i in
                                
                                Rectangle()
                                    .fill(.black)
                                    .overlay{
                                        if let img =  model.lastImages[i] {
                                            
                                            if scaleImage {
                                                img.resizable().scaledToFill()
                                            } else{
                                                img.resizable().scaledToFit()
                                                
                                            }
                                            
                                        }
                                        
                                    }

                            }
                            
                        }
                        
                        
                        
                        
                    }.frame( height: UIScreen.main.bounds.width )
                        .clipped()
                    Button {
                        scaleImage.toggle()
                    } label: {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 35,height: 35)
                            .overlay {
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .frame(width: 18)
                                
                            }
                    }.buttonStyle(.plain)
                        .padding(20)
                    
                }
               
                
            
                
                Divider()
                ZStack(alignment: .bottomTrailing){
                    PhotoCollectionView(photoCollection: model.photoCollection, model: model)
                    ZStack{
                        RoundedRectangle(cornerRadius: 40)
                            .fill(.ultraThinMaterial)
                            .frame( width: 240, height: 45)
                         
                                HStack{
                                    Text("POST")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .bold()
                                    Text("STORY")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .bold()
                                    Text("REEL")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .bold()
                                    Text("LIVE")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .bold()
                                }
                            
                    }.padding()
                }
                
                
                Spacer()
            }
            .navigationTitle("InstaPhotoPicker 🪄")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Image(systemName: "xmark").font(.title3)
                                ,trailing:
                                    Text("Next").bold().foregroundColor(.blue)
            )
        }.task {
            await model.loadPhotos()
        }
        .onChange(of: model.lastImage) { _ in
            scaleImage = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
