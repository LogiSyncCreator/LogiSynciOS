//
//  MapLocationDeleteSheet.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/07/06.
//

import SwiftUI

struct MapLocationDeleteSheet: View {
    @ObservedObject var mapVM: MapViewModel
    @State var user: MyUser
    var body: some View {
        VStack{
            List{
                ForEach(mapVM.model.userLocations, id: \.self){ model in
                    Text(model.createAt)
                }.onDelete(perform: { indexSet in
                    rowRemove(offsets: indexSet)
                })
            }.toolbar{
                EditButton()
            }
        }
    }
    
    
    func rowRemove(offsets: IndexSet) {
        offsets.forEach { index in
            let model = mapVM.model.userLocations[index]
            Task {
                try await mapVM.deleteLocations(uuid: model.id)
            }
            
        }
    }
}
