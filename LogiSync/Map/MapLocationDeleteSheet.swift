//
//  MapLocationDeleteSheet.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/07/06.
//

import SwiftUI
import Foundation

struct MapLocationDeleteSheet: View {
    @ObservedObject var mapVM: MapViewModel
    @State var user: MyUser
    var body: some View {
        VStack{
            List{
                ForEach(mapVM.model.userLocations, id: \.self){ model in
                    Text("\(isoDateFormatter(isoDate: model.createAt)) \(model.status)")
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
    
    func isoDateFormatter(isoDate: String) -> String {
        print(isoDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let date = dateFormatter.date(from: isoDate) else {
            return "無効な日付形式"
        }
        
        let jstFormatter = DateFormatter()
        jstFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        jstFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        
        let jstDate = jstFormatter.string(from: date)
        return jstDate
    }
}
