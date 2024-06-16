//
//  RegistViewModel.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/16.
//

import Foundation

class RegistViewModel: ObservableObject {
    @Published var model = RegistModel()
    @Published var proxyID: String = ""
    @Published var companyCheck: Bool = false
    
    
    func inputCheck(check: String)->String{
        var res = ""
        
        switch check {
        case "profile":
            // プロフィールの入力確認
            if model.userProfile.isEmpty || model.userProfile == "プロフィールを入力してください" {
                res = "プロフィールが入力されていません"
            }
        case "コード":
            // 会社コード
            // Combine実装後、フラグ操作で会社コードが合っているかも確認する
            
            if model.companyCode.isEmpty {
                res = "会社コードが未入力です"
                break
            }
            if self.companyCheck == false {
                res = "会社コードが不適格です"
                break
            }
        case "id":
            // id check
            if model.userId.isEmpty {
                res = "IDが未入力です"
                break
            }
            if model.userId.count < 5 {
                res = "IDは5文字以上入力してください"
                break
            }
        case "pass":
            // pass check
            if model.userPass.isEmpty {
                res = "パスワードが未入力"
                break
            }
            if model.userPass.count < 5 {
                res = "パスワードは5文字以上入力してください"
                break
            }
        case "phone":
            // 連絡先の確認
            if model.userPhone.isEmpty {
                res = "電話番号が入力されていません"
                break
            }
        case "氏名":// 氏名の確認
            if model.userName.isEmpty {
                res = "氏名が入力されていません"
                break
            }
        default: break
            
        }
        
        return res
    }
    func inputCheck(checkId: String){
        switch checkId {
        case "profile":
            // プロフィールの入力確認
            if model.userProfile.isEmpty || model.userProfile == "プロフィールを入力してください" {
                self.proxyID = "profile"
                break
            }
        case "コード":
            // 会社コード
            // Combine実装後、フラグ操作で会社コードが合っているかも確認する
            
            if model.companyCode.isEmpty {
                proxyID = "コード"
                break
            }
            if self.companyCheck == false {
                proxyID = "コード"
                break
            }
        case "id":
            // id check
            if model.userId.isEmpty {
                proxyID = "id"
                break
            }
            if model.userId.count < 5 {
                proxyID = "id"
                break
            }
        case "pass":
            // pass check
            if model.userPass.isEmpty {
                proxyID = "pass"
                break
            }
            if model.userPass.count < 5 {
                proxyID = "pass"
                break
            }
        case "phone":
            // 連絡先の確認
            if model.userPhone.isEmpty {
                proxyID = "phone"
                break
            }
        case "氏名":// 氏名の確認
            if model.userPhone.isEmpty {
                proxyID = "氏名"
                break
            }
        default: break
            
        }
    }
}
