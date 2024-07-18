//
//  MessageUI.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/07/16.
//

import SwiftUI

struct MessageView: View {
    let message: String
    
    var body: some View {
        VStack{
            
            Text(message)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
        }
        
    }
}
