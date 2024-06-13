//
//  StatusTestData.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import Foundation
import SwiftUI

struct StatusTestData {
    var StatusTagData: [StatusTagModelTest] = [
        StatusTagModelTest(label: "オンライン", symboleColor: Color(.green), symbole: "checkmark.circle.fill"),
        StatusTagModelTest(label: "オフライン", symboleColor: Color(.gray), symbole: "xmark.circle")
    ]
}
