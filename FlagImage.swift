//
//  FlagImage.swift
//  GuessTheFlag
//
//  Created by Y K on 30.04.2023.
//

import SwiftUI

struct flagImage: View {
    let name: String
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct FlagImage_Previews: PreviewProvider {
    static var previews: some View {
        flagImage(name: "France")
    }
}
