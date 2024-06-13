//
//  TagItemUI.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI

struct TagItemUI: View {
    
    @Binding var symboleColor: Color
    @Binding var symbole: String
    @Binding var label: String
    @Binding var width: CGFloat
    @Binding var font: Font
    
    var body: some View {
        HStack{
            StatusIconUI(symboleColor: $symboleColor, symbole: $symbole, width: $width)
            Text(label).font(font)
        }
    }
}
