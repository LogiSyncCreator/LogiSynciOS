//
//  MapSettingsButton.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/07/07.
//

import SwiftUI

struct MapSettingsButton: View {
    @State var isSheet: Bool = false
    @EnvironmentObject var environVM: EnvironmentViewModel
    @EnvironmentObject var locationMan: LocationManager
    @ObservedObject var mapVM: MapViewModel
    
    @State var interval: String = "0"
    @State var rudius: String = "0"
    @FocusState var isFocused: Bool
    @State var isAlert: Bool = false
    
    var body: some View {
        Button(action: {
            isSheet.toggle()
        }, label: {
            Image(systemName: "gearshape")
                .padding([.top, .bottom], 11)
                .padding([.leading, .trailing], 12)
        }).background(Material.ultraThick, in: RoundedRectangle(cornerRadius: 7.0)).disabled(environVM.model.account.user.role != "運転手")
            .sheet(isPresented: $isSheet, content: {
                List {
                    Section("マッチング") {
                        Text("担当者：\(environVM.model.nowMatchingUser.user.name)")
                        Text("会社名：\(environVM.model.nowMatchingUser.user.company)")
                        Text("目的地：\(environVM.model.nowMatchingInformation.address)")
                    }
                    
                    Section("自動送信") {
                        Text("\(locationMan.targetMatching.address)")
                    }
                    
                    Section("位置情報自動送信時間") {
                        HStack{
                            TextField("位置情報自動送信時間", text: $interval).focused($isFocused).onAppear(){
                                interval = String(locationMan.intervalTime)
                            }.keyboardType(.numberPad)
                            Button(action: {
                                if let intervalTime = Int(interval) {
                                    locationMan.intervalTime = intervalTime
                                    locationMan.saveUserDefaultIntervalTime(time: locationMan.intervalTime)
                                    isAlert.toggle()
                                }
                            }, label: {
                                Text(String(locationMan.intervalTime) == interval ? "" : interval.isEmpty ? "" : "保存")
                            })
                        }
                        .alert("警告", isPresented: $isAlert) {
                            
                        } message: {
                            Text("現在位置情報を共有している場合、一度共有を停止して再度共有を開始してください。")
                        }
                    }
                    
                    Section("位置情報通知範囲"){
                        HStack{
                            TextField("位置情報通知範囲", text: $rudius).onAppear(){
                                rudius = String(Int(locationMan.rudius))
                            }.keyboardType(.numberPad)
                            Button(action: {
                                if let rudius = Double(rudius) {
                                    locationMan.rudius = rudius
                                    locationMan.saveUserDefaultrudius(rudius: locationMan.rudius)
                                    isAlert.toggle()
                                }
                            }, label: {
                                Text(String(Int(locationMan.rudius)) == rudius ? "" : rudius.isEmpty ? "" : "保存")
                            })
                        }
                    }
                }
            })
    }
}

