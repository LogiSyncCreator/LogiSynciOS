//
//  StatusAccountModelTest.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import Foundation
import SwiftUI
import UIKit

struct StatusAccountModelTest {
    var id: String = UUID().uuidString
    var userId: String
    var pass: String
    var name: String
    var companyCode: String // 会社コード
    var group: String       // 会社名
    var selectedRole: String
    var uiimage: UIImage?
    var phone: String
    var profile: String
}
