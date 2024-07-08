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
            
        case "会社名":
            if model.company.isEmpty {
                res = "会社名が未入力です"
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
        default:
            break
            
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
        default:
            proxyID = ""
            break
            
        }
    }
}
