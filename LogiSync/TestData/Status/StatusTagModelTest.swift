//
//  StatusTagModelTest.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import Foundation
import SwiftUI

struct StatusTagModelTest {
    var id: String = UUID().uuidString  // タグID
    var label: String   // タグ名
    var symboleColor: Color // SFシンボルの色
    var symbole: String // SFシンボル
}
