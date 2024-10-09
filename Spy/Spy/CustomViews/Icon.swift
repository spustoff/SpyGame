//
//  Icon.swift
//  SpyGame
//
//  Created by Александр Печинкин on 09.10.2024.
//

import SwiftUI

struct Icon: View {
    var image: String
    var body: some View {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 32, height: 32)
    }
}

#Preview {
    Icon(image: "Property 1=arrow.clockwise")
}
