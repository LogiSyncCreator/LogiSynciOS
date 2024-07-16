//
//  MsgChangeView.swift
//  SampleChat
//
//  Created by 中島瑠斗 on 2024/07/09.
//

import SwiftUI

struct MsgChangeView: View {
    
    @ObservedObject var viewModel: MsgChangeViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var editMode: EditMode = .inactive
    
    @State private var newMessage = ""

    
    var body: some View {
        VStack {
            List {
                Section{
                    ForEach($viewModel.quickMessages) { $message in
                        HStack {
                            TextField("メッセージを入力", text: $message.message)
                        }
                    }
                    .onDelete(perform: viewModel.deleteMessage)
                } footer: {
                    HStack{
                        Spacer()
                        Text("\(viewModel.quickMessages.count) / 10")
                            .font(.caption)
                    }
                }
                
            }
            
            if viewModel.quickMessages.count < 10 {
                HStack {
                    TextField("新しいメッセージ", text: $newMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button{
                        viewModel.addMessage(message: newMessage)
                        newMessage = ""
                    } label: {
                        
                        
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                    }
                    .padding()
                }
            }
            
        }
        .navigationBarItems(trailing: EditButton())
        .environment(\.editMode, $editMode)
    }
    
}
