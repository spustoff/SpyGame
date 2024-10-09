//
//  Ext+WebPic.swift
//  Spy
//
//  Created by Вячеслав on 11/13/23.
//

import SwiftUI
import Kingfisher

struct WebPic: View {

    var urlString: String

    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    
    let isPlaceholder: Bool

    var body: some View {

        if let url = URL(string: urlString) {
            
            let resource = KF.ImageResource(downloadURL: url, cacheKey: url.absoluteString)
            
            KFImage(source: .network(resource))
                .resizable()
                .placeholder {

                    if isPlaceholder {
                        
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.system(size: 13))
                    }
                }
                .downsampling(size: CGSize(width: width, height: height))
                .cacheOriginalImage()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: width)
                .frame(height: height)
                .cornerRadius(cornerRadius)
        }
    }
}


